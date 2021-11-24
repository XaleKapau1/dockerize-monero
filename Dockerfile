# Created: 2021-11-24 14:38 CST
# Author(s): XaleKapau1
# Last Edited: 2021-11-24 14:38 CST
# Dockerfile for creating an image of Ubuntu with the Monero wallet and daemon installed (https://github.com/monero-project/monero)

FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  make \
  pkg-config \
  libboost-all-dev \
  libssl-dev \
  libzmq3-dev \
  libpgm-dev \
  libnorm-dev \
  libunbound-dev \
  libsodium-dev \
  libunwind8-dev \
  liblzma-dev \
  libreadline6-dev \
  libldns-dev \
  libexpat1-dev \
  libgtest-dev \
  ccache \
  doxygen \
  graphviz \
  qttools5-dev-tools \
  libhidapi-dev \
  libusb-1.0-0-dev \
  libprotobuf-dev \
  protobuf-compiler \
  libudev-dev \
  git \
  screen \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/src/gtest
RUN cmake . && make; mv lib/libg* /usr/lib/
WORKDIR /root/sources
RUN git clone --recursive https://github.com/monero-project/monero
WORKDIR /root/sources/monero
RUN git checkout release-v0.17; git submodule update --init --force; make
WORKDIR /root/xmr
RUN cp /root/sources/monero/build/Linux/release-v0.17/release/bin/* .; \
  touch start_monerod.sh; \
  printf '#!/bin/bash\n' | tee -a start_monerod.sh; \
  printf 'screen -dmS monerod /root/xmr/monerod\n' | tee -a start_monerod.sh; \
  touch stop_monerod.sh; \
  printf '#!/bin/bash\n' | tee -a stop_monerod.sh; \
  printf 'screen -S monerod -X stuff exit\r' | tee -a stop_monerod.sh; \
  chmod +x start_monerod.sh; \
  chmod +x stop_monerod.sh
