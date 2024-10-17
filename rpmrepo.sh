#!/bin/bash

CONTEXT_DIR=$(dirname "$(realpath "${BASH_SOURCE}")")
SCRIPT_NAME=$(basename "$0")

. ${CONTEXT_DIR}/bashutils/basicenv.sh

OPS_SH_DIR="${CONTEXT_DIR}/ops"

REPO_SOURCE=${REPO_SOURCE:-"0"}

. "${CONTEXT_DIR}/ops/env.sh"

. "${OPS_SH_DIR}/build.sh"

. "${OPS_SH_DIR}/install.sh"

trap __terminate INT TERM
trap __cleanup EXIT

TEMP_FILES=()

build-all() {
  build-nginx
  build-galera4
}

install-all() {
  install-nginx
  install-galera4
}

server-install() {
  install-reposerver

  REPO_SOURCE=1
  install-all
}

local-install() {
  install-repostore

  REPO_SOURCE=2
  install-all
}

main() {
  case "${1-}" in
  build-repo)
    build-repo
    ;;
  build-nginx)
    build-nginx
    ;;
  build-galera4)
    build-galera4
    ;;
  build-all)
    build-all
    ;;
  install-repo)
    install-repo
    ;;
  install-nginx)
    install-nginx
    ;;
  install-galera4)
    install-galera4
    ;;
  install-all)
    install-all
    ;;
  install-repostore)
    install-repostore
    ;;
  install-reposerver)
    install-reposerver
    ;;
  server-install)
    server-install
    ;;
  local-install)
    local-install
    ;;
  *)
    echo "The operation: ${1-} is not supported!"
    exit 1
    ;;
  esac
}

terminate() {
  echo "terminating..."
}

cleanup() {
  if [[ "${#TEMP_FILES[@]}" -gt 0 ]]; then
    echo "Cleaning temp_files...."

    for temp_file in "${TEMP_FILES[@]}"; do
      rm -f "${temp_file}" || true
    done
  fi
}

main "$@"
