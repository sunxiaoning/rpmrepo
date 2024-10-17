set-nginx-origin() {
  REPO_ORIGIN_URL='https://nginx.org/packages/centos/$releasever/$basearch/'
  REPO_GPG_KEY=https://nginx.org/keys/nginx_signing.key
}

build-nginx() {
  echo "Build nginx repo ..."

  APP_NAME="${NGINX_APP_NAME}"

  APP_VERSION="${LATEST_NGINX_VERSION}"
  build-repo

  APP_VERSION="1.24.0"
  build-repo

  APP_VERSION="1.22.1"
  build-repo
}
