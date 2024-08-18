#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

. hack/env.sh

export APP_NAME
export APP_VERSION

REPO_SOURCE=${REPO_SOURCE:-"0"}

REPO_ORIGIN_URL=""

REPO_SERVER_PROTOCOL=${REPO_SERVER_PROTOCOL:-"http"}
REPO_SERVER_NAME=${REPO_SERVER_NAME:-"localhost"}
REPO_SERVER_URL="${REPO_SERVER_PROTOCOL}://${REPO_SERVER_NAME}"

REPO_LOCAL_ROOT_PATH=${REPO_LOCAL_ROOT_PATH:-/opt/rpmrepo}
REPO_LOCAL_URL="file://${REPO_LOCAL_ROOT_PATH}"

export REPO_SOURCE_MARKER=""
export APP_REPO_URL=""
export REPO_ENABLED=${REPO_ENABLED:-"1"}
export REPO_GPG_CHECK=${REPO_GPG_CHECK:-"1"}
export REPO_GPG_KEY=${REPO_GPG_KEY:-""}
export REPO_MODULE_HOTFIXES=${REPO_MODULE_HOTFIXES:-"true"}

build-repo() {
  echo "Build ${APP_NAME}.repo ..."
  set-apprepourl
  mkdir -p repo/${APP_NAME}
  bashutils/render.sh "repo/repo.repo.tmpl" "repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo"
}

set-apprepourl() {
  case "${REPO_SOURCE}" in
  0)
    REPO_SOURCE_MARKER="official"
    set-reporiginurl
    APP_REPO_URL="${REPO_ORIGIN_URL}"
    ;;
  1)
    REPO_SOURCE_MARKER="private"
    APP_REPO_URL="${REPO_SERVER_URL}/${APP_NAME}/${APP_VERSION}"
    REPO_GPG_CHECK="0"
    ;;
  2)
    REPO_SOURCE_MARKER="local"
    APP_REPO_URL="${REPO_LOCAL_URL}/${APP_NAME}/${APP_VERSION}"
    REPO_GPG_CHECK="0"
    ;;
  *)
    echo "Unknown REPO_SOURCE: ${REPO_SOURCE}!"
    exit 1
    ;;
  esac
  echo "Use APP REPO_URL: ${APP_REPO_URL} ."
}

set-reporiginurl() {
  case "${APP_NAME}" in
  nginx*)
    REPO_ORIGIN_URL='https://nginx.org/packages/centos/$releasever/$basearch/'
    REPO_GPG_KEY=https://nginx.org/keys/nginx_signing.key
    ;;
  galera-4)
    local minor_version=$(echo "${APP_VERSION}" | cut -d '.' -f 3)
    REPO_ORIGIN_URL="https://releases.galeracluster.com/${APP_NAME}.${minor_version}/redhat/\$releasever/\$basearch/"
    REPO_GPG_KEY="https://releases.galeracluster.com/GPG-KEY-galeracluster.com"
    ;;
  mysql-wsrep-8.0)
    local minor_version=$(echo "${APP_VERSION}" | cut -d '.' -f 3)
    REPO_ORIGIN_URL="https://releases.galeracluster.com/${APP_NAME}.${minor_version}-${APP_RELEASE}/redhat/\$releasever/\$basearch/"
    REPO_GPG_KEY="https://releases.galeracluster.com/GPG-KEY-galeracluster.com"
    ;;
  *)
    echo "Unknown repository for APP_NAME: ${APP_NAME}"
    exit 1
    ;;
  esac
}

build-nginx() {
  echo "Build nginx repo ..."
  APP_NAME=nginx
  APP_VERSION=1.26.1
  build-repo

  APP_VERSION=1.24.0
  build-repo

  APP_VERSION=1.22.1
  build-repo
}

build-galera4() {
  echo "Build galera4 repo ..."
  APP_NAME=galera-4
  APP_VERSION=26.4.19
  build-repo

  APP_NAME=mysql-wsrep-8.0
  APP_VERSION=8.0.37
  APP_RELEASE=26.19
  build-repo
}

main() {
  if [[ "1" == "${USE_DOCKER}" ]]; then
    echo "Begin to build with docker."
    case "${1-}" in
    repo)
      build-repo-docker
      ;;
    nginx)
      build-nginx-docker
      ;;
    galera4)
      build-galera4-docker
      ;;
    *)
      build-nginx-docker
      build-galera4-docker
      ;;
    esac
  else
    echo "Begin to build in the local environment."
    case "${1-}" in
    repo)
      build-repo
      ;;
    nginx)
      build-nginx
      ;;
    galera4)
      build-galera4
      ;;
    *)
      build-nginx
      build-galera4
      ;;
    esac
  fi
}

main "$@"
