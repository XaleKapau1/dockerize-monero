#!/bin/bash

# Created: 2021-11-24 16:17 CST
# Author(s): XaleKapau1
# Last Edited: 2021-11-24 16:17 CST
# Bash script to build a Docker image of Ubuntu with the Monero wallet and daemon installed (https://github.com/monero-project/monero)

docker image pull ubuntu:latest
docker build --no-cache -t monero-ubuntu .
#docker run -it monero-ubuntu
