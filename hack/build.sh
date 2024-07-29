#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

APP_NAME=nginx
APP_VERSION=1.26.1

REPO_ROOT_PATH=/opt/rpmrepo

LOCAL_CACHE_PATH=${LOCAL_CACHE_PATH:-"file://${REPO_ROOT_PATH}"}

WEB_PROTOCOL=${WEB_PROTOCOL:-"http"}
SERVER_NAME=${SERVER_NAME:-"localhost"}

REPO_URL=${REPO_URL:-"${WEB_PROTOCOL}://${SERVER_NAME}"}

USE_REPO_SERVER=${USE_REPO_SERVER:-"0"}

APP_REPO_URL=${LOCAL_CACHE_PATH}/${APP_NAME}/${APP_VERSION}

build-repo() {
    echo "Build ${APP_NAME}.repo ..."
    if [[ "1" == "${USE_REPO_SERVER}" ]]; then
      APP_REPO_URL=${REPO_URL}/${APP_NAME}/${APP_VERSION}
      echo "Use APP REPO_URL: ${APP_REPO_URL} ."
    else
      APP_REPO_URL=${LOCAL_CACHE_PATH}/${APP_NAME}/${APP_VERSION}
    fi
    mkdir -p repo/${APP_NAME}
    AppName=${APP_NAME} AppVersion=${APP_VERSION} BaseUrl=${APP_REPO_URL} hack/render.sh "repo/repo.repo.tmpl" "repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo"
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
  build-repo
}

build-repoall() {
  echo "Build all repo ..."
  build-nginx
  build-galera4
}


main() {
  if [[ "1" == "${USE_DOCKER}" ]]; then
    echo "Begin to build with docker."
    case "${1-}" in
    download)
      download-docker
      ;;
    repo)
      build-repo-docker
      ;;
    nginx)
      build-nginx-docker
      ;;
    galera4)
      build-galera4-docker
      ;;
    repoall)
      build-repoall-docker
      ;;
    *)
      build-repoall-docker
      ;;
    esac
  else
    echo "Begin to build in the local environment."
    case "${1-}" in
    download)
      prepare
      ;;
    repo)
      build-repo
      ;;
    nginx)
      build-repo-nginx
      ;;
    galera4)
      build-galera4
      ;;
    repoall)
      build-repoall
      ;;
    *)
      build-repoall
      ;;
    esac
  fi
}

main "$@"
