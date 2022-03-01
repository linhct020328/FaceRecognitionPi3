import cv2
import os

cam = cv2.VideoCapture(0)
cam.set(3, 640) # set video width
cam.set(4, 480) # set video height

face_detector = cv2.CascadeClassifier('./cascades/haarcascade_frontalface_default.xml')

# For each person, enter one numeric face id
face_id = input('\n enter user id end press <return> ==>  ')

print("\n [INFO] Initializing face capture. Look the camera and wait ...")
# Initialize individual sampling face count
count = 0

while(True):
    ret, frame = cam.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_detector.detectMultiScale(gray, 1.3, 7)

    for (x,y,w,h) in faces:
        cv2.rectangle(frame, (x,y), (x+w,y+h), (255,0,0), 2)
        orig = (gray[y:y + h, x:x + w])

    cv2.imshow('frame', frame)

    key = cv2.waitKey(1) & 0xFF
    if key == ord("y"):
        p = "dataset/User." + str(face_id) + '.' + str(count) + '.jpg'
        cv2.imwrite(p, orig)
        count += 1

    elif key == ord("q"):
        break

    elif count >= 100:
        break

print("[INFO] {} face images stored".format(count))
print("[INFO] cleaning up...")
cam.release()
cv2.destroyAllWindows()