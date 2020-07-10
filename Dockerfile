FROM arm32v7/debian:stretch-slim
#COPY tmp/qemu-arm-static /usr/bin/qemu-arm-static

LABEL maintainer="Lars Kellogg-Stedman <lars@oddbit.com>"
LABEL maintainer="Raymond M Mouthaan <raymondmmouthaan@gmail.com>"

ENV SQUEEZE_VOL /srv/squeezebox
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# this is the version of LMS to use
#
# ARG VERSION=7.9.2
ARG VERSION=8.0
ARG PACKAGE_URL=http://www.mysqueezebox.com/update/?version=${VERSION}&revision=1&geturl=1&os=deb

# Install requirements and utilities
RUN apt-get update && \
    apt-get -y install curl wget nano faad flac lame sox libio-socket-ssl-perl \
    iputils-ping \
    iproute2 \
    && apt-get clean

# Download and install LMS
RUN echo download LMS from $PACKAGE_URL && \
    wget -O 'logitechmediaserver_all.deb' $(wget -q -O - ${PACKAGE_URL}) -q && \
    mv logitechmediaserver_all.deb /tmp/logitechmediaserver.deb && \
    dpkg -i /tmp/logitechmediaserver.deb && \
    rm -f /tmp/logitechmediaserver.deb && \
    apt-get clean

# This will be created by the entrypoint script.
RUN userdel squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]
