#!/bin/sh
set -euo pipefail

if [ "$1" = 'unittest' ]; then
    shift
    ${APP_ROOT_DIR}/exec_unittests.sh "$@"
else
    exec "$@"
fi