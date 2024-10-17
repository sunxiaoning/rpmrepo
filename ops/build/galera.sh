set-galera-origin() {
  local minor_version=$(echo "${APP_VERSION}" | cut -d '.' -f 3)
  REPO_ORIGIN_URL="https://releases.galeracluster.com/${APP_NAME}.${minor_version}/redhat/\$releasever/\$basearch/"
  REPO_GPG_KEY="https://releases.galeracluster.com/GPG-KEY-galeracluster.com"
}

set-mysql-wsrep-origin() {
  local minor_version=$(echo "${APP_VERSION}" | cut -d '.' -f 3)
  REPO_ORIGIN_URL="https://releases.galeracluster.com/${APP_NAME}.${minor_version}-${APP_RELEASE}/redhat/\$releasever/\$basearch/"
  REPO_GPG_KEY="https://releases.galeracluster.com/GPG-KEY-galeracluster.com"
}

build-galera4() {
  echo "Build galera4 repo ..."

  APP_NAME="${GALERA4_APP_NAME}"

  APP_VERSION="${LATEST_GALERA_4_VERSION}"
  build-repo

  APP_VERSION="26.4.19"
  build-repo

  APP_NAME="${MYSQL_WSREP_80_APP_NAME}"

  APP_VERSION="${LATEST_MYSQL_WSREP_80_VERSION}"
  build-repo

  APP_VERSION="8.0.37"
  build-repo
}