ARG BASE=swr.cn-south-1.myhuaweicloud.com/ascendhub/ascend-infer:24.0.RC1-ubuntu20.04

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

USER root

ARG PIP_NO_CACHE_DIR=off
RUN pip3 install torch==2.2.0 && \ 
  pip3 install pyyaml setuptools && \ 
  pip3 install torch-npu==2.2.0