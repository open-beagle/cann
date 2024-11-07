ARG BASE=debian:12

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

USER root

ARG DEBIAN_FRONTEND=noninteractive

# 1. 驱动路径环境变量设置
ARG ASCEND_BASE=/usr/local/Ascend
ENV LD_LIBRARY_PATH=\
$ASCEND_BASE/driver/lib64:\
$ASCEND_BASE/driver/lib64/common:\
$ASCEND_BASE/driver/lib64/driver:\
$ASCEND_BASE/driver/tools/hccn_tool/:\
$TOOLKIT_PATH/opp/built-in/op_impl/ai_core/tbe/op_tiling/lib/linux/aarch64/:\
$LD_LIBRARY_PATH

# TOOLKIT环境变量
ARG TOOLKIT_PATH=$ASCEND_BASE/ascend-toolkit/latest
ENV GLOG_v=2 \
LD_LIBRARY_PATH=$TOOLKIT_PATH/lib64:$LD_LIBRARY_PATH \
TBE_IMPL_PATH=$TOOLKIT_PATH/opp/op_impl/built-in/ai_core/tbe \
PATH=$TOOLKIT_PATH/ccec_compiler/bin:$PATH \
ASCEND_OPP_PATH=$TOOLKIT_PATH/opp \
ASCEND_AICPU_PATH=$TOOLKIT_PATH

ENV PYTHONPATH=$TBE_IMPL_PATH:$PYTHONPATH

RUN mkdir -p /tmp/Ascend-cann/ && \
  curl -fL -o /tmp/Ascend-cann/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run \
    https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C19SPC703/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run?response-content-type=application/octet-stream && \
    chmod +x /tmp/Ascend-cann/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run && \
    /tmp/Ascend-cann/Ascend-cann-toolkit_8.0.RC3.alpha003_linux-aarch64.run \
    --quiet --install --install-for-all --extract=/tmp/Ascend-cann/toolkit && \
  echo ". /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /etc/profile && \
  rm -rf /tmp/Ascend-cann

USER 1000
