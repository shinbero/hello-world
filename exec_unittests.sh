#!/bin/bash

# Please execute this script in container.

set -euxo pipefail

# The directory in which this script is placed.
BASE_DIR="$(dirname "$0")"

# cd /app/src
cd ${BASE_DIR}/src
python exec_tests.py
