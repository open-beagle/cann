ARG BASE=debian:12

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

USER root

ARG DEBIAN_FRONTEND=noninteractive

COPY *.exp /tmp/Ascend-cann/

RUN curl -fL -o /tmp/Ascend-cann/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run \
  https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream && \
  chmod +x /tmp/Ascend-cann/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run && \
  expect /tmp/Ascend-cann/install_cann_toolkit.exp && \
  curl -fL -o /tmp/Ascend-cann-kernels-910b_8.0.RC3.alpha003_linux-aarch64.run \
  https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-kernels-910b_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream && \
  chmod +x /tmp/Ascend-cann-kernels-910b_8.0.RC3.alpha003_linux-aarch64.run && \
  expect /tmp/Ascend-cann/install_cann_kernel.exp && \
  echo ". /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /etc/profile && \
  rm -rf /tmp/Ascend-cann

USER 1000
