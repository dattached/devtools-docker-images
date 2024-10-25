#!/usr/bin/env bash

set -e -o pipefail

SCRIPT_NAME="${SCRIPT_NAME:-$(basename ${0})}"
SCRIPT_LIB="${SCRIPT_LIB:-$(dirname ${0})/lib}"

SCRIPT_DESC="Install and configure uv with system pip under root."
SCRIPT_USAGE="${SCRIPT_NAME} [-h]"

SCRIPT_EXAMPLE_LANG="Dockerfile"
SCRIPT_EXAMPLE=$(cat <<EOF
# Dockerfile
RUN --mount=type=cache,dst=/root/.cache/pip \\
    --mount=type=bind,from=dattached/bootstrap,dst=/b \\
    bash /b/${SCRIPT_NAME}
EOF
)
SCRIPT_DOCS_TEMPLATE() {
  echo 'Generates `uv` config:'
  echo '```toml'
  echo "# ${DEFAULT_UV_CONFIG_PATH}"
  echo "${DEFAULT_UV_CONFIG}"
  echo '```'
}


# main

. ${SCRIPT_LIB}/dattach

DEFAULT_UV_CONFIG_PATH="/root/.config/uv/uv.toml"
DEFAULT_UV_CONFIG=$(cat <<EOF
python_downloads = "never"
link_mode = "copy"
[pip]
require_hashes = true
verify_hashes = true
EOF
)

main() {
  mkdir -p "$(dirname "${DEFAULT_UV_CONFIG_PATH}")"
  echo "${DEFAULT_UV_CONFIG}" > "${DEFAULT_UV_CONFIG_PATH}"
  pip install uv
}


# run

if [ "${SCRIPT_SOURCE}" != true ]
then
  FLAGS_HELP="$(script_help)"
  FLAGS "$@" || exit $?
  eval set -- "${FLAGS_ARGV}"
  main "$@"
fi
