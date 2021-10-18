#!/bin/bash
# Samet Ahmet Şahin 11.10.2021
echo "This script will run xhost and run the Embedded Eclipse Docker container and display Eclipse GUI"
echo "The projects folder will be at /home/usernamehere/EmbeddedEclipse"
xhost +
sudo docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --device /dev/bus/usb/002 -v "/home/$USER/EmbeddedEclipse/projects/:/apps/projects/:rw" embeddedeclipsedockerized /apps/eclipse/eclipse