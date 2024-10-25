#!/usr/bin/env sh

BASE="$(realpath "$(dirname "$0")/..")"
alacritty --hold --working-directory "${BASE}" -T "$(basename ${BASE})" &
