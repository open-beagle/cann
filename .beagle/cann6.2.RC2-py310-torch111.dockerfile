ARG BASE

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

ARG DEBIAN_FRONTEND=noninteractive

USER root
COPY --chown=root:root ./entrypoint.sh /opt/npu/entrypoint.sh
ENV BEAGLE_ROOT=/beagle
RUN apt-get update && \
    apt-get -y install ssh && \
    umask 0022  && \
    curl -k https://repo.huaweicloud.com/python/3.10.15/Python-3.10.15.tar.xz -o Python-3.10.15.tar.xz && \
    tar -xf Python-3.10.15.tar.xz && cd Python-3.10.15 && ./configure --prefix=/usr/local/Python-3.10.15 --enable-shared && \
    make && make install && \
    ln -sf /usr/local/Python-3.10.15/bin/python3 /usr/bin/python3 && \
    ln -sf /usr/local/Python-3.10.15/bin/python3 /usr/bin/python && \
    ln -sf /usr/local/Python-3.10.15/bin/pip3 /usr/bin/pip3 && \
    ln -sf /usr/local/Python-3.10.15/bin/pip3 /usr/bin/pip && \
    cd .. && \
    rm -rf Python* && rm -rf /usr/local/python3.7.5 && \
    cp /usr/local/Python-3.10.15/lib/libpython3.10.so.1.0 /usr/lib

RUN pip install jupyter jupyterlab -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

ENV LD_LIBRARY_PATH=/usr/local/Python-3.10.15/lib: \
    PATH=/usr/local/Python-3.10.15/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    ASCEND_TOOLKIT_HOME=/usr/local/Ascend/ascend-toolkit/latest \
    LD_LIBRARY_PATH=$TOOLKIT_PATH/fwkacllib/lib64/:/usr/local/Python-3.10.15/lib/python3.10/site-packages/torch/lib:/usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:/usr/local/Ascend/add-ons/:/usr/lib/aarch64_64-linux-gnu:$LD_LIBRARY_PATH \
    PATH=$PATH:$TOOLKIT_PATH/fwkacllib/ccec_compiler/bin/:$TOOLKIT_PATH/toolkit/tools/ide_daemon/bin/ \
    ASCEND_OPP_PATH=$TOOLKIT_PATH/opp/ \
    OPTION_EXEC_EXTERN_PLUGIN_PATH=$TOOLKIT_PATH/fwkacllib/lib64/plugin/opskernel/libfe.so:$TOOLKIT_PATH/fwkacllib/lib64/plugin/opskernel/libaicpu_engine.so:$TOOLKIT_PATH/fwkacllib/lib64/plugin/opskernel/libge_local_engine.so \
    PYTHONPATH=$TOOLKIT_PATH/fwkacllib/python/site-packages/:$TOOLKIT_PATH/fwkacllib/python/site-packages/auto_tune.egg/auto_tune:$TOOLKIT_PATH/fwkacllib/python/site-packages/schedule_search.egg:$PYTHONPATH \
    ASCEND_AICPU_PATH=$TOOLKIT_PATH \
    PATH=${ASCEND_TOOLKIT_HOME}/bin:${ASCEND_TOOLKIT_HOME}/compiler/ccec_compiler/bin:${ASCEND_TOOLKIT_HOME}/tools/ccec_compiler/bin:/usr/local/Python-3.10.15/bin:$PATH \
    PYTHONPATH=${ASCEND_TOOLKIT_HOME}/python/site-packages:${ASCEND_TOOLKIT_HOME}/opp/built-in/op_impl/ai_core/tbe:$PYTHONPATH \
    DDK_PATH=/usr/local/Ascend/ascend-toolkit/latest \
    NPU_HOST_LIB=$DDK_PATH/acllib/lib64/stub

RUN curl -L https://cache.wodcloud.com/kubernetes/bgctl/arm64/bgctl > \
  /usr/local/bin/bgctl && \ 
  chmod +x /usr/local/bin/bgctl && \ 
  chmod +x /opt/npu/entrypoint.sh

WORKDIR /beagle

CMD ["sh","/opt/npu/entrypoint.sh"]