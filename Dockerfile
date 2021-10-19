FROM ubuntu:focal
WORKDIR /app
COPY . /app
RUN apt update
RUN apt install -y --no-install-recommends libxcursor1 libxinerama1 libxrandr2 libxi6 libswt-gtk-4-jni openocd gcc-arm-none-eabi usbutils 

# add new user

RUN groupadd -r eclipse && useradd -r -s /bin/bash -g eclipse eclipse
RUN echo "eclipse" | passwd --stdin eclipse
RUN chown -R eclipse:eclipse /app
USER eclipse

# Extra packages for testing, will comment in production
# RUN apt install -y --no-install-recommends xterm
CMD tail -f /dev/null
