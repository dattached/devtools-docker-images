#!/usr/bin/env bash

set -e -o pipefail

SCRIPT_NAME="${SCRIPT_NAME:-$(basename ${0})}"
SCRIPT_LIB="${SCRIPT_LIB:-$(dirname ${0})/lib}"

SCRIPT_DESC="Add https://apt.postgresql.org repository with latest PostgreSQL packages."
SCRIPT_USAGE="${SCRIPT_NAME} [-h]"

SCRIPT_EXAMPLE_LANG="Dockerfile"
SCRIPT_EXAMPLE=$(cat <<EOF
# Dockerfile
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
  apt-get install -y --no-install-recommends ca-certificates postgresql-common
  YES=true /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
}


# run

if [ "${SCRIPT_SOURCE}" != true ]
then
  FLAGS_HELP="$(script_help)"
  FLAGS "$@" || exit $?
  eval set -- "${FLAGS_ARGV}"
  main "$@"
fi
