FROM openjdk:11-stretch

#
# Slightly modified https://hub.docker.com/r/kongkoro/pycharm/dockerfile
#
# To run it firt allow connection from docker to X11 then Docker run
# $ xhost +local:docker
# $ docker run -it -v /tmp/.X11-unix/:/tmp/.X11-unix/ -e DISPLAY=$DISPLAY docker-pycharm

ENV PYCHARM_HOME=/etc/pycharm
RUN apt-get update &&\
    apt-get install -y \
    wget \
    git \
    libxrender1 \
    libxtst6 \
    python \
    --no-install-recommends &&\
    wget https://download-cf.jetbrains.com/python/pycharm-edu-2019.2.tar.gz -O /tmp/pycharm.tar.gz &&\
    mkdir ${PYCHARM_HOME} && tar -xzvf /tmp/pycharm.tar.gz -C ${PYCHARM_HOME} --strip=1 &&\
    wget -P /tmp/ https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py &&\
    rm -rf /var/lib/apt-lists; rm -rf /tmp/*; apt-get purge wget -y; apt-get autoremove -y

# RUN echo $(ls -lR /etc/pycharm)
ENTRYPOINT ["/etc/pycharm/bin/pycharm.sh"]

