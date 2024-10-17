set-reporiginurl() {
  case "${APP_NAME}" in
  nginx*)
    set-nginx-origin
    ;;
  galera-4)
    set-galera-origin
    ;;
  mysql-wsrep-8.0)
    set-mysql-wsrep-origin
    ;;
  *)
    echo "Unknown repository for APP_NAME: ${APP_NAME}"
    exit 1
    ;;
  esac
}
