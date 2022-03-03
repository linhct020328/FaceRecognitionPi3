import base64
from Aes256CBC import *
import paho.mqtt.client as paho
from PIL import Image
import ssl

topic = "testServo"
mqtt_broker = "192.168.0.103"#ip mqtt-windowm   #"broker.mqtt-dashboard.com"
mqtt_port = 1883
mqttUser = "linh99"
mqttPassword = "1234567890"

pathCa = './certs_localhost/mqtt_ca.crt'
pathClient = './certs_localhost/mqtt_client.crt'
pathClientKey = './certs_localhost/mqtt_client.key'

nrunknown = 0
frameSize = (640, 480)
path = './unknown'

def convertAesToMsg(string, key, iv):
    decoded= decrypt_aes_256(string, key, iv)
    return decoded

def on_connect(client, userdata, flags, rc):
    print("Connected with result code: " + str(rc))


def on_message(client, userdata, msg):
    key = 'qwertyuiopasdfghjklzxcvbnm123456'
    iv = 'caothithuylinh99'
    message = (msg.payload).decode("utf-8")
    if (len(message) <= 24):
        text_msg = convertAesToMsg(message, key, iv)
        print(str(text_msg))
    else:
        global nrunknown
        img_msg = convertAesToMsg(message, key, iv)
        nrunknown = nrunknown + 1
        img = bytes.fromhex(img_msg)
        imgRes = Image.frombytes("RGB", frameSize, img, "raw", "BGR")
        q = "unknown/unknown" + str(nrunknown) + ".jpg"
        imgRes.save(q)


client = paho.Client()
client.tls_set(pathCa, pathClient, pathClientKey, tls_version=ssl.PROTOCOL_TLSv1_2)
client.tls_insecure_set(True)
client.connect(mqtt_broker, mqtt_port)
client.username_pw_set(username= mqttUser, password= mqttPassword)
client.subscribe(topic)
client.on_message = on_message
client.loop_forever()
