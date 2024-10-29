uninstall-repo() {
  echo "Uninstall ${APP_NAME}-${APP_VERSION}.repo"

  rm -f "/etc/yum.repos.d/${APP_NAME}-${APP_VERSION}.repo"

  refresh-yumcache
}

uninstall-nginx() {
  APP_NAME=nginx

  APP_VERSION="${LATEST_NGINX_VERSION}"
  uninstall-repo

  # APP_VERSION="1.24.0"
  # uninstall-repo

  # APP_VERSION="1.22.1"
  # uninstall-repo
}

uninstall-galera4() {
  APP_NAME="${GALERA4_APP_NAME}"

  APP_VERSION="${LATEST_GALERA_4_VERSION}"
  uninstall-repo

  # APP_VERSION="26.4.19"
  # uninstall-repo
}

uninstall-mysql-wsrep8() {
  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"

  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"
  uninstall-repo

  # APP_VERSION="8.0.37"
  # uninstall-repo
}

uninstall-repostore() {
  echo "uninstall-repostore is not supported!"
}
