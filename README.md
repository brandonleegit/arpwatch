# arpwatch

## Build your own Arpwatch Docker container for monitoring your network

While there are Arpwatch packages and solutions out there that you can download, it is great to be able to build these on your own. This project shares a Dockerfile to be able to build your own Arpwatch container. Running arpwatch as a container allows much more easily keeping things updated, and even copying the solution to multiple docker hosts.

## What do you need?

First, you will need just a few things for building your own Arpwatch container. You will need:

1) A Docker host
2) You will need to know the interface names of your Docker host network addresses
3) You will need to have some type of self-hosted or public email relay to be able to receive notifications
