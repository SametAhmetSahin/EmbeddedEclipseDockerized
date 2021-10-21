#!/bin/bash
# Samet Ahmet Şahin 11.10.2021
echo "This will build the Docker image of Eclipse Embedded C/C++"
sudo DOCKER_BUILDKIT=1 docker build -t embeddedeclipsedockerizeduservariant .
echo "Image built"
