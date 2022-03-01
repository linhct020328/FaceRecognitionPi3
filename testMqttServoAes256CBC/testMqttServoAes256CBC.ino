#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <Servo.h>
#include "Base64.h"
//#include "certificates.h"

Servo myservo; 
int pos = 0;
int buttonState = 0; 
int directionState = 0; 
#define servo D2
#define buttonPin D3

const char* ssid = "Meo Meo";
const char* password = "mangcut9987"; 
const char* mqtt_server = "192.168.0.103"; //"ip mqtt-windowm   //"broker.mqtt-dashboard.com"
const int mqtt_port = 1883;
const char *topic = "testServo";
String clientId = "mqtt-servo";

const char* mqttUser = "linh99";
const char* mqttPassword = "1234567890";

File ca_crt_str = SPIFFS.open("./certs/mqtt_ca.crt", "r");
File client_crt_str = SPIFFS.open("./certs/mqtt_client.crt", "r");
File client_key_str = SPIFFS.open("./certs/mqtt_client.key", "r");

const char *CMD_OPEN = "open";
const char *CMD_CLOSE = "close";

BearSSL::WiFiClientSecure espClient;
PubSubClient client(espClient);

BearSSL::X509List   ca_crt(ca_crt_str);
BearSSL::X509List   client_crt(client_crt_str);
BearSSL::PrivateKey client_key(client_key_str);

byte cipher_key[] = "qwertyuiopasdfghjklzxcvbnm123456";
byte cipher_iv[] = "caothithuylinh99";

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void setup() {
  myservo.attach(servo);
  pinMode(buttonPin, INPUT);
  Serial.begin(115200);
  
  setup_wifi();
  
  espClient.setTrustAnchors(&ca_crt);
  espClient.allowSelfSignedCerts();            
  espClient.setClientRSACert(&client_crt, &client_key);
  espClient.setInsecure();

  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  thuCong();
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    clientId += String(random(0xffff), HEX);
    if (client.connect(clientId.c_str(), mqttUser, mqttPassword)) {
      Serial.println("connected");
      //client.publish(topic, "hello"); 
      client.subscribe(topic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  char mesages[100];
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("]");

  for (int i = 0; i < length; i++)
  {
    char receivedChar = (char)payload[i];

    mesages[i] = receivedChar;
  }

  String decdata = decrypt(mesages);
  Serial.println(decdata);
  
  Serial.println();
  if (strcmp((char*)decdata.c_str(),CMD_OPEN) == 0 && directionState == 0) {
    directionState = 1;
    openDoor();
  } 
  else if (strcmp((char*)decdata.c_str(),CMD_CLOSE) == 0 && directionState == 1) {
    directionState = 0;   
    closeDoor();
  }
}

String encrypt(String plain_data){
  int i;
  // PKCS#7 Padding (Encryption), Block Size : 16
  int len = plain_data.length();
  int n_blocks = len / 16 + 1;
  uint8_t n_padding = n_blocks * 16 - len;
  uint8_t data[n_blocks*16];
  memcpy(data, plain_data.c_str(), len);
  for(i = len; i < n_blocks * 16; i++){
    data[i] = n_padding;
  }
  
  uint8_t key[32], iv[16];
  memcpy(key, cipher_key, 32);
  memcpy(iv, cipher_iv, 16);

  // encryption context
  br_aes_big_cbcenc_keys encCtx;

  // reset the encryption context and encrypt the data
  br_aes_big_cbcenc_init(&encCtx, key, 32);
  br_aes_big_cbcenc_run( &encCtx, iv, data, n_blocks*16 );

  // Base64 encode
  len = n_blocks*16;
  char encoded_data[ base64_enc_len(len) ];
  base64_encode(encoded_data, (char *)data, len);
  
  return String(encoded_data);
}

// AES CBC Decryption
String decrypt(String encoded_data_str){  
  int input_len = encoded_data_str.length();
  char *encoded_data = const_cast<char*>(encoded_data_str.c_str());
  int len = base64_dec_len(encoded_data, input_len);
  uint8_t data[ len ];
  base64_decode((char *)data, encoded_data, input_len);
  
  uint8_t key[32], iv[16];
  memcpy(key, cipher_key, 32);
  memcpy(iv, cipher_iv, 16);

  int n_blocks = len / 16;

  br_aes_big_cbcdec_keys decCtx;

  br_aes_big_cbcdec_init(&decCtx, key, 32);
  br_aes_big_cbcdec_run( &decCtx, iv, data, n_blocks*16 );

  // PKCS#7 Padding (Decryption)
  uint8_t n_padding = data[n_blocks*16-1];
  len = n_blocks*16 - n_padding;
  char plain_data[len + 1];
  memcpy(plain_data, data, len);
  plain_data[len] = '\0';

  return String(plain_data);
}

void closeDoor(){
  String msg = "closeDoor";
  for (pos = 0; pos <= 135; pos += 1) {
    myservo.write(pos);
    delay(15);
  }

  String encdata = encrypt(msg);
  
  client.publish(topic, (char*)encdata.c_str()); 
  client.subscribe(topic);
}

void openDoor(){
  String msg = "openDoor";
  for (pos = 135; pos >= 0; pos -= 1) {
    myservo.write(pos);
    delay(15);
  }
  String encdata = encrypt(msg);
  
  client.publish(topic, (char*)encdata.c_str()); 
  client.subscribe(topic);
}

void thuCong(){
   buttonState = digitalRead(buttonPin);
   if (directionState == 0){
     if (buttonState == HIGH) {
        directionState = 1;
        openDoor();
     }
 
   } else if (directionState == 1) {
     if (buttonState == HIGH) {
        directionState = 0;   
        closeDoor();
     }
   }
}
