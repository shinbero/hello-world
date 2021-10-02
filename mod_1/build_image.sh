#!/bin/sh

# 本スクリプトに関して:
# 本来はGitOpsに従い、Gitサーバでマージされた段階で自動でbuildされるべきだが、
# Localで試しにbuildしてみる際には本スクリプトを利用する。
# tagはローカル専用ということで、'local_tmp'となる.

# The directory in which this script is placed.
BASE_DIR="$(dirname "$0")"
cd ${BASE_DIR}

. ../common_setup.sh


BASE_IMAGE=$(sh get_base_image.sh ${env_DOCKER_REGISTRY:-''})

docker image build \
    -t mod_1:local_tmp \
    --build-arg base_image="${BASE_IMAGE}" .
