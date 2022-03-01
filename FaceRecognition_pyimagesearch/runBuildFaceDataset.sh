#!/bin/bash

mkdir dataset/${@}
python build_face_dataset.py  --output dataset/${@}
