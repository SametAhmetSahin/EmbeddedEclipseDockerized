FROM ubuntu:focal
WORKDIR /apps
COPY . /apps
RUN apt update
RUN apt install -y --no-install-recommends libxcursor1 libxinerama1 libxrandr2 libxi6 libswt-gtk-4-jni openocd gcc-arm-none-eabi usbutils 
# Extra packages for testing, will comment in production
# RUN apt install -y --no-install-recommends xterm
CMD tail -f /dev/null
