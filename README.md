# Arpwatch Docker Container build

## Detailed blog post walkthrough

Check out the detailed blog post here that steps you through the process in detail: https://www.virtualizationhowto.com/2025/01/build-your-own-arpwatch-docker-container-to-watch-your-network/

## Build your own Arpwatch Docker container for monitoring your network

While there are Arpwatch packages and solutions out there that you can download, it is great to be able to build these on your own. This project shares a Dockerfile to be able to build your own Arpwatch container. Running arpwatch as a container allows much more easily keeping things updated, and even copying the solution to multiple docker hosts.

## What do you need?

First, you will need just a few things for building your own Arpwatch container. You will need:

1) A Docker host
2) You will need to know the interface names of your Docker host network addresses
3) You will need to have some type of self-hosted or public email relay to be able to receive notifications

## Steps to build the container

1) Clone down the repository with the Dockerfile
2) Modify the interface names, email relay server address, and recipient email address for notifications
3) Build the docker container
4) Run the docker container

```
docker build . -t arpwatch:latest
```

```
docker run -dit --privileged --network host --restart always -v $(pwd)/varlib-arpwatch:/var/lib/arpwatch --name arpwatch arpwatch:latest
```
If you prefer Docker Compose, that will look like the following:

```
version: '3.8'

services:
  arpwatch:
    image: arpwatch:latest
    container_name: arpwatch
    privileged: true
    network_mode: host
    restart: always
    volumes:
      - ./varlib-arpwatch:/var/lib/arpwatch
```