RPMSYNC_SH_FILE="${CONTEXT_DIR}/rpmsync/rpmsync.sh"

export REPO_ORIGIN_SOURCE=${REPO_ORIGIN_SOURCE:-"0"}

. "${OPS_SH_DIR}/install/galera.sh"

. "${OPS_SH_DIR}/install/nginx.sh"

install-repo() {
  build-repo

  TEMP_FILES+=("${CONTEXT_DIR}/repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo")

  install -D -m 644 "${CONTEXT_DIR}/repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo" "/etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo"

  refresh-yumcache
}

install-repostore() {
  "${RPMSYNC_SH_FILE}" install-repoall
}
