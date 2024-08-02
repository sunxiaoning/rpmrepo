#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

APP_NAME=nginx
APP_VERSION=1.26.1

export REPO_ROOT_PATH=${SERVER_NAME:-"/opt/rpmrepo"}

NGINX_VERSION=1.26.1
RELEASE=2
DIST=${DIST:-"el8"}
ARCH=${ARCH:-"x86_64"}

export SERVER_NAME=${SERVER_NAME:-"localhost"}

RPMSYNC_MODULE=rpmsync

export NGCONF_DATADIR=/etc/nginx/conf.d/*.conf

export CLEAN_NGDATA_ONINSTALL=${CLEAN_NGDATA_ONINSTALL:-"0"}
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
  if rpm -q "nginx-${NGINX_VERSION}" &> /dev/null; then
    echo "Nginx is already installed!"
    return 0
  fi

  if [[ "1" == "${STOPNG_ONINSTALL}" ]]; then
    hack/run.sh stop
  else
    local service_status=$(systemctl is-active nginx)
    if [[ "${service_status}" != "inactive" ]] && [[ "${service_status}" != "dead" ]]; then
      echo "nginx has not been shutdown completed!"
      exit 1
    fi
  fi

  if [[ "1" == "${CLEAN_NGDATA_ONINSTALL}" ]]; then
    echo "Clean old ngconf datadir ..."
    rm -rf ${NGCONF_DATADIR}
  fi

  if rpm -q "nginx" &> /dev/null; then
    echo "Find old nginx pkg installed, abort!"
    exit 1
  fi

  rpm -ivh "${REPO_ROOT_PATH}/nginx/${NGINX_VERSION}/nginx-${NGINX_VERSION}-${RELEASE}.${DIST}.${ARCH}.rpm"

  if ! rpm -q "nginx-${NGINX_VERSION}" &> /dev/null; then
    echo "nginx not installed!"
    exit 1
  fi
}

install-repoconf() {
  local repo_conf_name="default"
  if [[ "${SERVER_NAME}" != "localhost" ]]; then
    repo_conf_name=${SERVER_NAME}
  fi
  hack/render.sh conf/repo.conf.tmpl "conf/${repo_conf_name}.conf"
  install -D -m 644 "conf/${repo_conf_name}.conf" "/etc/nginx/conf.d/${repo_conf_name}.conf" 
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
    repostore)
      install-repostore-docker
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
    repostore)
      install-repostore
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
