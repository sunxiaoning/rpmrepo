install-galera4() {
  APP_NAME="${GALERA4_APP_NAME}"

  APP_VERSION="${LATEST_GALERA_4_VERSION}"
  install-repo

  # APP_VERSION="26.4.19"
  # install-repo
}

install-mysql-wsrep8() {
  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"

  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"
  install-repo

  # APP_VERSION="8.0.37"
  # install-repo
}
