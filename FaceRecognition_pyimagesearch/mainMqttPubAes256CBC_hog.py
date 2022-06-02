import face_recognition
import pickle
from time import strftime
import time
import cv2
import ssl

import paho.mqtt.client as paho
from Aes256CBC import *

clientId = "mqtt-servo"
topic = "testServo"
mqtt_broker = "192.168.0.103"#ip mqtt-windowm   #"broker.mqtt-dashboard.com"
mqtt_port = 1883

mqttUser = "linh99"
mqttPassword = "1234567890"

pathCa = './certs_localhost/mqtt_ca.crt'
pathClient = './certs_localhost/mqtt_client.crt'
pathClientKey = './certs_localhost/mqtt_client.key'

CMD_OPEN = 'open'
CMD_CLOSE = 'close'

client = paho.Client()
client.tls_set(pathCa, pathClient, pathClientKey, tls_version=ssl.PROTOCOL_TLSv1_2)
client.tls_insecure_set(True)
client.connect(mqtt_broker, mqtt_port)
client.username_pw_set(username=mqttUser, password=mqttPassword)

cascadePath = "./cascades/haarcascade_frontalface_default.xml"
path = "trainer/encodings_hog.pickle"

data = pickle.loads(open(path, "rb").read())
detector = cv2.CascadeClassifier(cascadePath)

cam = cv2.VideoCapture(0)
cam.set(3, 640)  # set video widht
cam.set(4, 480)  # set video height

minW = 0.1 * cam.get(3)
minH = 0.1 * cam.get(4)

font1 = cv2.FONT_HERSHEY_SIMPLEX
font2 = cv2.FONT_HERSHEY_DUPLEX

nrunknown = 0

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
	rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

	rects = detector.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=7, minSize=(int(minW), int(minH)))

	boxes = [(y, x + w, y + h, x) for (x, y, w, h) in rects]

	encodings = face_recognition.face_encodings(rgb, boxes)
	names = []
	confidences = []

	key = 'qwertyuiopasdfghjklzxcvbnm123456'  # 32bit
	iv = "caothithuylinh99"  # 16bit
	for encoding in encodings:
		matches = face_recognition.compare_faces(data["encodings"], encoding)
		name = "Unknown"

		face_distances = face_recognition.face_distance(data["encodings"], encoding)

		if True in matches:
			matchedIdxs = [i for (i, b) in enumerate(matches) if b]
			counts = {}

			for i in matchedIdxs:
				name = data["names"][i]
				counts[name] = counts.get(name, 0) + 1
				confidence = str((max(face_distances)*100).__round__(2))+"%"
				door_unlock(key, iv)

			name = max(counts, key=counts.get)

		else:
			#door_lock(key, iv)
			_, img_encode = cv2.imencode('.jpg', frame)
			imgByte = img_encode.tobytes()
			img = imgByte.hex()
			imgSend = convertMsgToAes(img, key, iv)
			client.publish(topic, imgSend)

		names.append(name)
		confidences.append(confidence)

	for ((top, right, bottom, left), name, confidence) in zip(boxes, names, confidences):
		cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 2)
		y = top - 15 if top - 15 > 15 else top + 15
		text = name + ":" + confidence
		cv2.putText(frame, text, (left, y), font1, 1, (0, 255, 0), 2)

	fpsInfo = "FPS: " + str((1.0 / (time.time() - start_time)).__round__(2))
	cv2.putText(frame, fpsInfo, (10, 20), font2, 0.5, (255, 100, 0), 1)

	full_datetime = strftime("%d/%m/%y at %I:%M%p")
	cv2.putText(frame, full_datetime, (10, 470), font2, 0.5, (255, 100, 0), 1)

	cv2.imshow("Frame", frame)
	key = cv2.waitKey(1) & 0xFF

	if key == ord("q"):
		break

cam.release()
cv2.destroyAllWindows()
