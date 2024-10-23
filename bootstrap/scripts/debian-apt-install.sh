#!/usr/bin/env bash

set -e -o pipefail

SCRIPT_NAME="$(basename ${0})"
SCRIPT_DIR=$(dirname ${0})


# options

. ${SCRIPT_DIR}/lib/shflags

FLAGS_HELP="Install arbitrary packages.
USAGE: ${SCRIPT_NAME} [-h] [--noupdate] [--noclean] package [package...]"

DEFINE_boolean 'update' true "update APT cache" ''
DEFINE_boolean 'clean' true "clean APT cache and temporary files" ''


# main

main() {

  # update apt cache
  if [ ${FLAGS_update} -eq ${FLAGS_TRUE} ]; then
    apt-get update;
  fi

  # install
  apt-get install -y "$@"

  # cleanup
  if [ ${FLAGS_clean} -eq ${FLAGS_TRUE} ]; then
    apt-get clean;
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;
  fi

}

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"
main "$@"
