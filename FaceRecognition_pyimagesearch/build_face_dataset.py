import argparse
import cv2
import os

ap = argparse.ArgumentParser()
ap.add_argument("-o", "--output", required=True,
	help="path to output directory")
args = vars(ap.parse_args())

cascadePath = "./cascades/haarcascade_frontalface_default.xml"

detector = cv2.CascadeClassifier(cascadePath)

label = input("What is your name:")
label = label.strip().lower()

print("[INFO] starting video stream...")
cam = cv2.VideoCapture(0)
cam.set(3, 640)  # set video widht
cam.set(4, 480)  # set video height

minW = 0.1 * cam.get(3)
minH = 0.1 * cam.get(4)
total = 0

while True:
	ret, frame = cam.read()
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	rects = detector.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=7, minSize=(int(minW), int(minH)))

	for (x, y, w, h) in rects:
		cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
		orig = (gray[y:y + h, x:x + w]).copy()
	cv2.imshow("Frame", frame)
	key = cv2.waitKey(1) & 0xFF

	if key == ord("y"):
		p = os.path.sep.join([args["output"], "{}.jpg".format(label + str(total).zfill(5))])
		cv2.imwrite(p, orig)
		total += 1

	elif key == ord("q"):
		break

	elif total >= 100:
		break

print("[INFO] {} face images stored".format(total))
print("[INFO] cleaning up...")
cv2.destroyAllWindows()
cam.stop()
