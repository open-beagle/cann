#!/bin/bash

set -x

if [ ! -z "$ROOT_PASSWORD" ]; then
  sed -i 's/^#PermitRootLogin.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
  echo -e "$ROOT_PASSWORD\n$ROOT_PASSWORD" | passwd root
fi

sed -i 's/^#PubkeyAuthentication.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config

mkdir -p /root/.ssh && chmod 700 /root/.ssh
export PATH=/opt/conda/bin:$PATH
service ssh start

if [[ -e $BEAGLE_ROOT/entrypoint.sh ]]; then
  sh $BEAGLE_ROOT/entrypoint.sh &
fi

jupyter-lab --generate-config
config_file=$(jupyter --config-dir)/jupyter_lab_config.py
mkdir $BEAGLE_ROOT
jupyter lab --allow-root --ip "0.0.0.0" --IdentityProvider.token="$ROOT_PASSWORD" --ServerApp.root_dir="$BEAGLE_ROOT"