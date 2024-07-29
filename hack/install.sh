#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

APP_NAME=nginx
APP_VERSION=1.26.1

REPO_ROOT_PATH=/opt/rpmrepo

NGINX_VERSION=1.26.1
RELEASE=2
DIST=${DIST:-"el8"}
ARCH=${ARCH:-"x86_64"}

SERVER_NAME=${SERVER_NAME:-"localhost"}

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

install-repoall() {
  install-nginx
  install-galera4
}

install-reposerver() {
  rpm -ivh "${REPO_ROOT_PATH}/nginx/${NGINX_VERSION}/nginx-${NGINX_VERSION}-${RELEASE}.${DIST}.${ARCH}.rpm"
  rm -f /etc/nginx/conf.d/*.conf
}

install-repoconf() {
  ServerName=${SERVER_NAME}  RepoRootPath=${REPO_ROOT_PATH} hack/render.sh conf/repo.conf.tmpl "conf/${SERVER_NAME}.conf"
  install -D -m 644 "conf/${SERVER_NAME}.conf" "/etc/nginx/conf.d/${SERVER_NAME}.conf" 
  nginx -t
}


main() {
  if [[ "1" == "${USE_DOCKER}" ]]; then
    echo "Begin to build with docker."
    case "${1-}" in
    repo)
      install-repo-docker
      ;;
    nginx)
      install-nginx-docker
      ;;
    galera4)
      install-galera4-docker
      ;;
    repoall)
      install-repoall-docker
      ;;
    reposerver)
      install-reposerver-docker
      ;;
    repoconf)
      install-repoconf-docker
      ;;
    *)
      install-repo-docker
      ;;
    esac
  else
    echo "Begin to build in the local environment."
    case "${1-}" in
    repo)
      install-repo
      ;;
    nginx)
      install-nginx
      ;;
    galera4)
      install-galera4
      ;;
    repoall)
      install-repoall
      ;;
    reposerver)
      install-reposerver
      ;;
    repoconf)
      install-repoconf
      ;;
    *)
      install-repo
      ;;
    esac
  fi
}

main "$@"
