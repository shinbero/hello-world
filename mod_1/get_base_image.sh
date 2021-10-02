#!/bin/bash
set -eu

if [[ $# -ne 1  ]]; then
    echo "Usage: sh get_base_image.sh <Registry server" \
        "or '' if use docker hub.>" >&2
    exit 1
fi

IMAGE_REGISTRY=$1

BASE_IMAGE=daiana/python:3.9.7-alpine3.14-1.0

# 引数でregistryサーバを渡された場合は、registryをimage名の一部とする.
if [[ ! -z ${IMAGE_REGISTRY} ]]; then
    BASE_IMAGE=${IMAGE_REGISTRY}/${BASE_IMAGE}
fi


echo "$BASE_IMAGE"
