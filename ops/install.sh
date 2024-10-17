RPMSYNC_SH_FILE="${CONTEXT_DIR}/rpmsync/rpmsync.sh"

RPMSERVER_SH_FILE="${CONTEXT_DIR}/rpmserver/rpmserver.sh"

export REPO_ORIGIN_SOURCE=${REPO_ORIGIN_SOURCE:-"0"}

. "${OPS_SH_DIR}/install/galera.sh"

. "${OPS_SH_DIR}/install/nginx.sh"

install-repo() {
  build-repo

  TEMP_FILES+=("${CONTEXT_DIR}/repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo")

  install -D -m 644 "${CONTEXT_DIR}/repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo" "/etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo"
}

install-nginx() {
  APP_NAME=nginx

  APP_VERSION="${LATEST_NGINX_VERSION}"
  install-repo

  APP_VERSION="1.24.0"
  install-repo

  APP_VERSION="1.22.1"
  install-repo
}

install-galera4() {
  APP_NAME="${GALERA4_APP_NAME}"

  APP_VERSION="${LATEST_GALERA_4_VERSION}"
  install-repo

  APP_VERSION="26.4.19"
  install-repo

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"

  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"
  install-repo

  APP_VERSION="8.0.37"
  install-repo
}

install-repostore() {
  "${RPMSYNC_SH_FILE}" install-repoall
}

install-reposerver() {
  "${RPMSERVER_SH_FILE}" autorun-reposerver
}
