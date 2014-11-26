#!/bin/bash
/usr/bin/gm import -display :0.0 -crop 1920x1080+0+0 -window root -resize 1280 $HOME/Pictures/Webcam/costi/screens/`date +'%Y-%m-%d-shot-%H-%M-%S.jpg'`
