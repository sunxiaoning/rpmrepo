export REPO_SOURCE_MARKER=""

export APP_NAME
export APP_VERSION

export APP_REPO_URL=""

REPO_ORIGIN_URL=""

REPO_SERVER_PROTOCOL=${REPO_SERVER_PROTOCOL:-"http"}
REPO_SERVER_NAME=${REPO_SERVER_NAME:-"localhost"}
REPO_SERVER_URL="${REPO_SERVER_PROTOCOL}://${REPO_SERVER_NAME}"

REPO_LOCAL_ROOT_PATH=${REPO_LOCAL_ROOT_PATH:-/opt/rpmrepo}
REPO_LOCAL_URL="file://${REPO_LOCAL_ROOT_PATH}"

export REPO_ENABLED=${REPO_ENABLED:-"1"}
export REPO_GPG_CHECK=${REPO_GPG_CHECK:-"1"}
export REPO_GPG_KEY=${REPO_GPG_KEY:-""}
export REPO_MODULE_HOTFIXES=${REPO_MODULE_HOTFIXES:-"true"}

. "${OPS_SH_DIR}/build/galera.sh"

. "${OPS_SH_DIR}/build/nginx.sh"

. "${OPS_SH_DIR}/build/reporigin.sh"

RENDER_SH_FILE="${CONTEXT_DIR}/bashutils/render.sh"

build-repo() {
  echo "Build ${APP_NAME}-${APP_VERSION}.repo ..."

  set-apprepourl

  mkdir -p repo/${APP_NAME}

  "${RENDER_SH_FILE}" "repo/repo.repo.tmpl" "${CONTEXT_DIR}/repo/${APP_NAME}/${APP_NAME}-${APP_VERSION}.repo"
}

set-apprepourl() {
  case "${REPO_SOURCE}" in
  0)
    REPO_SOURCE_MARKER="official"
    set-reporiginurl
    APP_REPO_URL="${REPO_ORIGIN_URL}"
    ;;
  1)
    REPO_SOURCE_MARKER="private"
    APP_REPO_URL="${REPO_SERVER_URL}/${APP_NAME}/${APP_VERSION}"
    REPO_GPG_CHECK="0"
    ;;
  2)
    REPO_SOURCE_MARKER="local"
    APP_REPO_URL="${REPO_LOCAL_URL}/${APP_NAME}/${APP_VERSION}"
    REPO_GPG_CHECK="0"
    ;;
  *)
    echo "Unknown REPO_SOURCE: ${REPO_SOURCE}!"
    exit 1
    ;;
  esac
  echo "Use APP REPO_URL: ${APP_REPO_URL} ."
}
