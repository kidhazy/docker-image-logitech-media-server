# Docker Container for Logitech Media Server

- [Description](#description)
  - [Changes](#changes)
- [Changes from original source](#changes-from-original-source)
- [Usage (Copied from original instructions)](#usage-copied-from-original-instructions)
- [Using docker-compose](#using-docker-compose)
- [Build Status](#build-status)

## Description

This image is based on the [Docker Container for Logitech Media Server](https://hub.docker.com/r/larsks/logitech-media-server/) ([Github](https://github.com/larsks/docker-image-logitech-media-server)). It was adapted according to the PR by [RaymondMouthaan](https://github.com/RaymondMouthaan) to support additional architectures. The source can be found on [github](https://github.com/DOliana/docker-image-logitech-media-server).

Until the PR is reviewed this is a testing image.

To get the latest package version visit the [download page](http://downloads.slimdevices.com/nightly/index.php?ver=7.9)

To always get the latest version use [this url](http://www.mysqueezebox.com/update/?version=7.9.2&revision=1&geturl=1&os=deb)

Find the image on [docker hub](https://hub.docker.com/r/doliana/logitech-media-server/)

### Changes

- 24.11.2019:
  - the "latest" tag has been removed - so either latest-7.9.2 or latest-7.9.0 should be used. This simplifies the deployment pipeline.
  - migrated from travis-ci to Azure DevOps pipeline

## Changes from original source

- Always use latest 7.9.X version from [mysqueezebox](http://downloads.slimdevices.com/nightly/index.php?ver=7.9)
- Change to use deb_all package to simplify installation

## Usage (Copied from original instructions)

This is a Docker image for running the Logitech Media Server package
(aka SqueezeboxServer).

Run Directly:

    docker run -p 9000:9000 \
               -p 9090:9090 \
               -p 3483:3483 \
               -p 3483:3483/udp \
               -v /etc/localtime:/etc/localtime:ro \
               -v /etc/timezone:/etc/timezone:ro \
               -v <local-state-dir>:/srv/squeezebox \
               -v <audio-dir>:/srv/music \
               larsks/logitech-media-server

The web interface runs on port 9000.  If you also want this available
on port 80 (so you can use `http://yourserver/` without a port number
as the URL), you can add `-p 80:9000`, but you *must* also include `-p
9000:9000` because the players expect to be able to contact the server
on that port.

## Using docker-compose

There is a [docker-compose-logitech-media-server.yml](https://github.com/DOliana/docker-image-logitech-media-server/blob/master/docker-compose-logitech-media-server.yml) included in this repository that
you will let you bring up a Logitech Media Server container using
`docker-compose`.  The compose file includes the following:

    volumes:
      - ${AUDIO_DIR}:/srv/music

To provide a value for `AUDIO_DIR`, create a `.env`
file that points `AUDIO_DIR` at the location of your music library,
for example:

    AUDIO_DIR=/home/USERNAME/Music

[docker-compose-logitech-media-server.yml]: docker-compose-logitech-media-server.yml

## Build Status

![Build Status](https://dev.azure.com/DenisOliana/HomeAutomation/_apis/build/status/DOliana.docker-image-logitech-media-server?branchName=master)
