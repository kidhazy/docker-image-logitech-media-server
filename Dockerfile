FROM golang:1.12.0 AS builder
# Uses an amd64 image to download the qemu-arm-static binary for the arm image in the next build step
# This allows the arm images to be built on x86 architecture - eg. the Docker Hub automatic build platform
# Also needs the hooks/pre_build steps to register qemu-arm-static 
WORKDIR /builder/working/directory
RUN curl -L https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .

FROM arm32v7/debian:stretch-slim
# Copy across the qemu binary that was downloaded in the previous build step.  
# This is to allow us to build on the x86 architecture of the Docker Hub environment for automatic builds.
COPY --from=builder /builder/working/directory/qemu-arm-static /usr/bin

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
    iproute2 && \
    apt-get clean

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
