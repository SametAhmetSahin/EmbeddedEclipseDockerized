#!/bin/bash
# Samet Ahmet Şahin 11.10.2021
echo "This script will run xhost and run the Embedded Eclipse Docker container and display Eclipse GUI\n"
echo "The projects folder and the configuration (todo) folder will be at /home/usernamehere/EmbeddedEclipse"
xhost +
mkdir /home/$USER/EmbeddedEclipse/
mkdir /home/$USER/EmbeddedEclipse/projects/
sudo chown -hR $USER:$USER /home/$USER/EmbeddedEclipse
sudo docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --device /dev/bus/usb/002 -v "/home/$USER/EmbeddedEclipse/projects/:/apps/projects/:rw" embeddedeclipsedockerizeduservariant /bin/bash #/app/eclipse/eclipse
#-v "/home/$USER/EmbeddedEclipse/configuration:/apps/eclipse/configuration/:rw"
