set -o nounset
set -o errexit
set -o pipefail

USE_DOCKER=${USE_DOCKER:-"0"}

APP_NAME=nginx
APP_VERSION=1.26.1
APP_RELEASE=1

