FROM ubuntu:focal
WORKDIR /app
COPY . /app
RUN apt update
RUN echo -e "8\n20" apt install -y --no-install-recommends libxcursor1 libxinerama1 libxrandr2 libxi6 libswt-gtk-4-jni openocd gcc-arm-none-eabi usbutils build-essential libcanberra-gtk3-0 gdb-multiarch

# add new user

RUN groupadd -r eclipse && useradd -r -s /bin/bash -g eclipse eclipse
# RUN echo "eclipse" | passwd --stdin eclipse
RUN chown -R eclipse:eclipse /app
#RUN echo -e eclipse | passwd eclipse
RUN chpasswd passwd.txt
USER eclipse

# Extra packages for testing, will comment in production
# RUN apt install -y --no-install-recommends xterm
CMD tail -f /dev/null
