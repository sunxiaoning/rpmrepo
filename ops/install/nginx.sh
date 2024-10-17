install-nginx() {
  APP_NAME=nginx

  APP_VERSION="${LATEST_NGINX_VERSION}"
  install-repo

  APP_VERSION="1.24.0"
  install-repo

  APP_VERSION="1.22.1"
  install-repo
}
