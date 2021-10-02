#!/bin/sh

# Please execute this script in container.

set -euxo pipefail

# The directory in which this script is placed.
BASE_DIR="$(cd $( dirname "$0" ) && pwd)"
cd ${BASE_DIR}/src

# If not specified unittest result directory from arg,
# output to BASE_DIR.
RESULT_DIR=${1:-${BASE_DIR}}

python -m pytest --junitxml ${RESULT_DIR}/unittest-results.xml tests
