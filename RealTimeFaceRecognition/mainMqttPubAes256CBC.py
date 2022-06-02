# send msg:      aes256cbc
# send image:    base64
# mqtt_broker:   "192.168.0.103"#ip mqtt-windowm
#                "192.168.227.128"#ip mqtt-ubuntu


import paho.mqtt.client as paho
import cv2
import time
from time import strftime
import ssl
from Aes256CBC import *

clientId = "mqtt-servo"
topic = "testServo"
mqtt_broker = "192.168.0.103"#ip mqtt-windowm   #"broker.mqtt-dashboard.com"
mqtt_port = 1883
mqttUser = "linh99"
mqttPassword = "1234567890"

CMD_OPEN = 'open'
CMD_CLOSE = 'close'

pathCa = './certs_localhost/mqtt_ca.crt'
pathClient = './certs_localhost/mqtt_client.crt'
pathClientKey = './certs_localhost/mqtt_client.key'

client = paho.Client()
client.tls_set(pathCa, pathClient, pathClientKey, tls_version=ssl.PROTOCOL_TLSv1_2)
client.tls_insecure_set(True)
client.connect(mqtt_broker, mqtt_port)
client.username_pw_set(username=mqttUser, password=mqttPassword)

recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read('trainer/trainer.yml')
cascadePath = "./cascades/haarcascade_frontalface_default.xml"
faceCascade = cv2.CascadeClassifier(cascadePath)

font1 = cv2.FONT_HERSHEY_SIMPLEX
font2 = cv2.FONT_HERSHEY_DUPLEX

id = 0

names = ['None', 'Hien', 'Linh', 'Nhat',  'Tuan']
nrunknown = 0

cam = cv2.VideoCapture(0)
cam.set(3, 640)  # set video widht
cam.set(4, 480)  # set video height

minW = 0.1 * cam.get(3)
minH = 0.1 * cam.get(4)

def convertMsgToAes(msg, key, iv):
    encoded = Aes256CBC.encrypt_aes_256(msg, key, iv)
    return encoded

def door_lock(key, iv):
    lock = convertMsgToAes(CMD_CLOSE, key, iv)
    client.publish(topic, lock)

def door_unlock(key, iv):
    unlock = convertMsgToAes(CMD_OPEN, key, iv)
    client.publish(topic, unlock)

while True:
    start_time = time.time()
    ret, frame = cam.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    faces = faceCascade.detectMultiScale(
        gray,
        scaleFactor=1.2,
        minNeighbors=7,
        minSize=(int(minW), int(minH)),
    )

    key = 'qwertyuiopasdfghjklzxcvbnm123456'#32bit
    iv = "caothithuylinh99"#16bit
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        id, confidence = recognizer.predict(gray[y:y + h, x:x + w])

        if (confidence < 100):
            id = names[id]
            confidence = "  {0}%".format(round(confidence))
            door_unlock(key, iv)

        else:
            id = "unknown"
            confidence = "  {0}%".format(round(confidence - 100))
            #door_lock(key, iv)
            _, img_encode = cv2.imencode('.jpg', frame)
            imgByte = img_encode.tobytes()
            img = imgByte.hex()
            imgSend = convertMsgToAes(img, key, iv)
            client.publish(topic, imgSend)

        data = str(id +":"+ confidence)
        cv2.putText(frame, data, (x + 5, y - 5), font1, 1, (0, 255, 0), 2)

    fpsInfo = "FPS: " + str((1.0 / (time.time() - start_time)).__round__(2))
    cv2.putText(frame, fpsInfo, (10,20), font2, 0.5, (255, 100, 0), 1)

    full_datetime = strftime("%d/%m/%y at %I:%M%p")
    cv2.putText(frame, full_datetime, (10,470),font2, 0.5, (255, 100, 0), 1)

    cv2.imshow('camera', frame)

    key = cv2.waitKey(1) & 0xFF

    if key == ord("q"):
        break

print("\n [INFO] Exiting Program and cleanup stuff")
cam.release()
cv2.destroyAllWindows()
