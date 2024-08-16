#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

APP_NAME=nginx
APP_VERSION=1.26.1

export REPO_ROOT_PATH=${REPO_ROOT_PATH:-"/opt/rpmrepo"}

NGINX_VERSION=1.26.1
RELEASE=2
DIST=${DIST:-"el8"}
ARCH=${ARCH:-"x86_64"}

export SERVER_NAME=${SERVER_NAME:-"localhost"}

RPMSYNC_MODULE=rpmsync
RPMSERVER_MODULE=rpmserver

# export GH_TOKEN=${GH_TOKEN:-""}
# export GH_TOKEN_FILE=${GH_TOKEN_FILE:-".gh_token.txt"}

#export NGCONF_DATADIR=/etc/nginx/conf.d/*.conf

export STOPNG_ONINSTALL=${STOPNG_ONINSTALL:-"0"}

PROJECT_PATH=$(pwd)

install-repo() {
  install -D -m 644 "repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo" "/etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo" 
}

install-nginx() {
  APP_NAME=nginx
  APP_VERSION=1.26.1
  install-repo
  
  APP_VERSION=1.24.0
  install-repo

  APP_VERSION=1.22.1
  install-repo
}

install-galera4() {
  APP_NAME=galera-4
  APP_VERSION=26.4.19
  install-repo

  APP_NAME=mysql-wsrep-8.0
  APP_VERSION=8.0.37
  install-repo
}

install-repostore() {
  cd "${RPMSYNC_MODULE}"
  make install-repoall
  cd "${PROJECT_PATH}"
}

install-reposerver() {
  cd "${RPMSERVER_MODULE}"
  make autorun-reposerver
  cd "${PROJECT_PATH}"
}

main() {
  if [[ "1" == "${USE_DOCKER}" ]]; then
    echo "Begin to build with docker."
    case "${1-}" in
    repostore)
      install-repostore-docker
      ;;
    reposerver)
      install-reposerver-docker
      ;;
    repo)
      install-repo-docker
      ;;
    nginx)
      install-nginx-docker
      ;;
    galera4)
      install-galera4-docker
      ;;
    *)
      install-repo-docker
      ;;
    esac
  else
    echo "Begin to build in the local environment."
    case "${1-}" in
    repostore)
      install-repostore
      ;;
    reposerver)
      install-reposerver
      ;;
    repo)
      install-repo
      ;;
    nginx)
      install-nginx
      ;;
    galera4)
      install-galera4
      ;;
    *)
      install-repo
      ;;
    esac
  fi
}

main "$@"
