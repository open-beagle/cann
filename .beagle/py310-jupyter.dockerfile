ARG BASE=debian:12

FROM $BASE

ARG AUTHOR
ARG VERSION

LABEL maintainer=$AUTHOR version=$VERSION

USER root

ARG DEBIAN_FRONTEND=noninteractive

ENV BEAGLE_ROOT=/beagle
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple/ && \
  python3 -m venv ~/.venv && \
  . ~/.venv/bin/activate && \
  pip install --no-cache-dir jupyter jupyterlab-language-pack-zh-CN && \
  ln -s /root/.venv/bin/jupyter /usr/bin/jupyter && \
  ln -s /root/.venv/bin/jupyter-console /usr/bin/jupyter-console && \
  ln -s /root/.venv/bin/jupyter-dejavu /usr/bin/jupyter-dejavu && \
  ln -s /root/.venv/bin/jupyter-events /usr/bin/jupyter-events && \
  ln -s /root/.venv/bin/jupyter-execute /usr/bin/jupyter-execute && \
  ln -s /root/.venv/bin/jupyter-kernel /usr/bin/jupyter-kernel && \
  ln -s /root/.venv/bin/jupyter-kernelspec /usr/bin/jupyter-kernelspec && \
  ln -s /root/.venv/bin/jupyter-lab /usr/bin/jupyter-lab && \
  ln -s /root/.venv/bin/jupyter-labextension /usr/bin/jupyter-labextension && \
  ln -s /root/.venv/bin/jupyter-labhub /usr/bin/jupyter-labhub && \
  ln -s /root/.venv/bin/jupyter-migrate /usr/bin/jupyter-migrate && \
  ln -s /root/.venv/bin/jupyter-nbconvert /usr/bin/jupyter-nbconvert && \
  ln -s /root/.venv/bin/jupyter-notebook /usr/bin/jupyter-notebook && \
  ln -s /root/.venv/bin/jupyter-qtconsole /usr/bin/jupyter-qtconsole && \
  ln -s /root/.venv/bin/jupyter-run /usr/bin/jupyter-run && \
  ln -s /root/.venv/bin/jupyter-server /usr/bin/jupyter-server && \
  ln -s /root/.venv/bin/jupyter-troubleshoot /usr/bin/jupyter-troubleshoot && \
  ln -s /root/.venv/bin/jupyter-trust /usr/bin/jupyter-trust 

# COPY --chown=root:root settings/plugin.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings

COPY --chown=root:root ./entrypoint.sh /opt/nvidia/entrypoint.sh

RUN curl -L https://cache.wodcloud.com/kubernetes/bgctl/arm64/bgctl > \
  /usr/local/bin/bgctl && \ 
  chmod +x /usr/local/bin/bgctl && \ 
  chmod +x /opt/nvidia/entrypoint.sh

WORKDIR /beagle

ENTRYPOINT ["/opt/nvidia/entrypoint.sh"]