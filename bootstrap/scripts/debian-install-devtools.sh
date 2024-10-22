#!/usr/bin/env bash

set -ex -o pipefail


# update apt cache
apt update

# install download helpers
apt install -y curl wget

# install stream editors
apt install -y jq

# install git
apt install -y git

# install zsh and friends
apt install -y lsd zsh
wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | RUNZSH=no CHSH=yes sh

# install task
if [ -n "${TASK_VERSION}" ];
then TASK_RELEASE="v${TASK_VERSION}"
else TASK_RELEASE=$(wget -qO- https://api.github.com/repos/go-task/task/releases/latest | jq -r '.name')
fi
TASK_URL="https://github.com/go-task/task/releases/download/${TASK_RELEASE}/task_linux_amd64.deb"
wget -q ${TASK_URL} -P /tmp
apt install -y /tmp/task_linux_amd64.deb

# cleanup temporary apt files
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
