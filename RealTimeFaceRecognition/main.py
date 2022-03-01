import cv2
import time
from time import strftime

recognizer = cv2.face.LBPHFaceRecognizer_create()
recognizer.read('trainer/trainer.yml')
cascadePath = "./cascades/haarcascade_frontalface_default.xml"
faceCascade = cv2.CascadeClassifier(cascadePath)

font1 = cv2.FONT_HERSHEY_SIMPLEX
font2 = cv2.FONT_HERSHEY_DUPLEX

# iniciate id counter
id = 0

# names related to ids: example ==> Marcelo: id=1,  etc
names = ['None', 'Hien', 'Linh',  'Nhat', 'Phuong',  'Vy']
nrunknown = 0
# Initialize and start realtime video capture
cam = cv2.VideoCapture(0)
cam.set(3, 640)  # set video widht
cam.set(4, 480)  # set video height

# Define min window size to be recognized as a face
minW = 0.1 * cam.get(3)
minH = 0.1 * cam.get(4)


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

    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
        id, confidence = recognizer.predict(gray[y:y + h, x:x + w])

        if (confidence < 100):
            id = names[id]
            confidence = "  {0}%".format(round(confidence))
            print("open")
        else:
            id = "unknown"
            confidence = "  {0}%".format(round(confidence))
            print("close")
            nrunknown = nrunknown + 1
            cv2.imwrite("unknown/unknown" + str(nrunknown) + ".jpg", gray[y:y + h, x:x + w])

        data = str(id +":"+ confidence)
        cv2.putText(frame, data, (x + 5, y - 5), font1, 1, (255, 255, 255), 2)

    fpsInfo = "FPS: " + str((1.0 / (time.time() - start_time)).__round__(2))
    cv2.putText(frame, fpsInfo,(10,20) ,font2, 0.5, (255, 255, 255), 1)

    full_datetime = strftime("%d/%m/%y at %I:%M%p")
    cv2.putText(frame, full_datetime, (10,470),font2, 0.5, (255, 255, 255), 1)

    cv2.imshow('camera', frame)

    key = cv2.waitKey(1) & 0xFF

    if key == ord("q"):
        break

# Do a bit of cleanup
print("\n [INFO] Exiting Program and cleanup stuff")
cam.release()
cv2.destroyAllWindows()