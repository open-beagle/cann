ARG BASE=swr.cn-south-1.myhuaweicloud.com/ascendhub/ascend-infer:24.0.RC1-ubuntu20.04

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

ARG PIP_NO_CACHE_DIR=off
RUN pip3 install torch==2.4.0 torchvision torchaudio && \ 
  pip3 install pyyaml setuptools && \ 
  pip3 install torch-npu==2.4.0