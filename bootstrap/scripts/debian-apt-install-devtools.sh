#!/usr/bin/env bash

set -e -o pipefail

SCRIPT_NAME="$(basename ${0})"
SCRIPT_DIR=$(dirname ${0})


# options

. ${SCRIPT_DIR}/lib/shflags

FLAGS_HELP="Install standard devtools.
USAGE: ${SCRIPT_NAME} [-h] [--noaptupdate] [--noaptclean]"

DEFINE_boolean 'aptupdate' true "update APT cache" ''
DEFINE_boolean 'aptclean' true "clean APT cache and temporary files" ''


# main

main() {

  # update apt cache
  if [ ${FLAGS_aptupdate} -eq ${FLAGS_TRUE} ]; then
    apt-get update;
  fi

  # install download helpers
  apt-get install -y curl wget

  # install stream editors
  apt-get install -y jq

  # install git
  apt-get install -y git

  # install zsh and friends
  apt-get install -y lsd zsh
  wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | RUNZSH=no CHSH=yes sh

  # install task
  if [ -n "${TASK_VERSION}" ];
  then TASK_RELEASE="v${TASK_VERSION}"
  else TASK_RELEASE=$(wget -qO- https://api.github.com/repos/go-task/task/releases/latest | jq -r '.name')
  fi
  TASK_URL="https://github.com/go-task/task/releases/download/${TASK_RELEASE}/task_linux_amd64.deb"
  wget -q ${TASK_URL} -P /tmp
  apt-get install -y /tmp/task_linux_amd64.deb

  # cleanup
  if [ ${FLAGS_aptclean} -eq ${FLAGS_TRUE} ]; then
    apt-get clean;
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
  fi

}

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"
main "$@"
