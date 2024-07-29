#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

start-reposerver() {
  setsenginx
  systemctl start nginx
}

setsenginx() {
  setsehttpd_t
}

setsehttpd_t() {
  if semanage permissive -l | grep -q httpd_t; then
    exit 0
  fi
  echo "Adding httpd_t to permissive mode."
  semanage permissive -a httpd_t
}

reload-reposerver() {
  systemctl reload nginx
}


stop-reposerver() {
  systemctl stop nginx
}


main() {
    case "${1-}" in
    start)
        start-reposerver
        ;;
    reload)
        reload-reposerver
        ;;
    stop)
        stop-reposerver
        ;;
    *)
        echo "Action not support! start/reload/stop only!"
    esac
}

main "$@"
