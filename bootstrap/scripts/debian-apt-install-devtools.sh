#!/usr/bin/env bash

set -e -o pipefail

SCRIPT_NAME="${SCRIPT_NAME:-$(basename ${0})}"
SCRIPT_LIB="${SCRIPT_LIB:-$(dirname ${0})/lib}"

SCRIPT_DESC="Install standard devtools."
SCRIPT_USAGE="${SCRIPT_NAME} [-h]"

SCRIPT_EXAMPLE_LANG="Dockerfile"
SCRIPT_EXAMPLE=$(cat <<EOF
# Dockerfile
ENV TASK_VERSION=x.y.z
# if TASK_VERSION is not specified, the latest GitHub release version is used
RUN --mount=type=cache,dst=/var/cache/apt,sharing=locked \\
    --mount=type=cache,dst=/var/lib/apt,sharing=locked \\
    --mount=type=bind,from=dattached/bootstrap,dst=/b \\
    apt-get update; \\
    bash /b/${SCRIPT_NAME}; \\
    rm -rf /tmp/* /var/tmp/*
EOF
)


# main

. ${SCRIPT_LIB}/dattach

main() {

  export DEBIAN_FRONTEND=noninteractive

  PKG_DOWNLOADERS="curl wget"
  PKG_EDITORS="jq"
  PKG_GIT_ETC="git"
  PKG_ZSH_ETC="lsd zsh"

  apt-get install -y \
    ${PKG_DOWNLOADERS} ${PKG_EDITORS} ${PKG_GIT_ETC} ${PKG_ZSH_ETC}

  # oh my zsh
  wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
    | RUNZSH=no CHSH=yes sh

  # install task
  if [ -n "${TASK_VERSION}" ];
  then TASK_RELEASE="v${TASK_VERSION}"
  else TASK_RELEASE=$(wget -qO- https://api.github.com/repos/go-task/task/releases/latest | jq -r '.name')
  fi
  TASK_URL="https://github.com/go-task/task/releases/download/${TASK_RELEASE}/task_linux_amd64.deb"
  wget -q ${TASK_URL} -P /tmp
  apt-get install -y /tmp/task_linux_amd64.deb

}


# run

if [ "${SCRIPT_SOURCE}" != true ]
then
  FLAGS_HELP="$(script_help)"
  FLAGS "$@" || exit $?
  eval set -- "${FLAGS_ARGV}"
  main "$@"
fi
