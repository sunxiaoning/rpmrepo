#!/bin/bash

CONTEXT_DIR=$(dirname "$(realpath "${BASH_SOURCE}")")
SCRIPT_NAME=$(basename "$0")

. ${CONTEXT_DIR}/bashutils/basicenv.sh

OPS_SH_DIR="${CONTEXT_DIR}/ops"

REPO_SOURCE=${REPO_SOURCE:-"0"}

. "${CONTEXT_DIR}/ops/env.sh"

. "${OPS_SH_DIR}/build.sh"

. "${OPS_SH_DIR}/install.sh"

. "${OPS_SH_DIR}/uninstall.sh"

trap __terminate INT TERM
trap __cleanup EXIT

TEMP_FILES=()

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
  install-repo)
    install-repo
    ;;
  install-nginx)
    install-nginx
    ;;
  install-galera4)
    install-galera4
    ;;
  install-mysql-wsrep8)
    install-mysql-wsrep8
    ;;
  install-repostore)
    install-repostore
    ;;
  uninstall-repo)
    uninstall-repo
    ;;
  uninstall-nginx)
    uninstall-nginx
    ;;
  uninstall-galera4)
    uninstall-galera4
    ;;
  uninstall-mysql-wsrep8)
    uninstall-mysql-wsrep8
    ;;
  uninstall-repostore)
    uninstall-repostore
    ;;
  *)
    echo "The operation: ${1-} is not supported!"
    exit 1
    ;;
  esac
}

terminate() {
  echo "[${SCRIPT_NAME}] Terminating..."
}

cleanup() {
  if [[ "${#TEMP_FILES[@]}" -gt 0 ]]; then
    echo "[${SCRIPT_NAME}] Cleaning temp_files...."

    for temp_file in "${TEMP_FILES[@]}"; do
      rm -f "${temp_file}" || true
    done
  fi
}

main "$@"
