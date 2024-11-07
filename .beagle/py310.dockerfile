ARG BASE=debian:12

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install -y \
  iputils-ping xz-utils jq vim curl wget git openssh-server && \
  apt clean

RUN apt update && \
  apt install -y \
  build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev && \
  curl -sfL -o /tmp/Python-3.10.15.tar.xz \
  https://repo.huaweicloud.com/python/3.10.15/Python-3.10.15.tar.xz && \
  tar -xvf /tmp/Python-3.10.15.tar.xz -C /tmp && \
  cd /tmp/Python-3.10.15 && \
  ./configure --enable-optimizations && \
  make -j 4 && \
  make altinstall && \
  cd /usr/local/bin && \
  ln -s python3.10 python3 && \
  ln -s python3.10 python && \
  ln -s pip3.10 pip3 && \
  ln -s pip3.10 pip && \
  python --version && \
  apt remove -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev && \
  apt clean && \
  rm -rf /tmp/Python-3.10.15.tar.xz /tmp/Python-3.10.15
