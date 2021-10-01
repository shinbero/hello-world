#!/bin/bash

set -Euo pipefail

# To trap unbound variable error, needs to trap 'EXIT', too.
trap 'exit_with_err_msg $?' ERR EXIT

function log(){
    echo -e "[$(date +"%Y-%m-%d %H:%M:%S%Z")]" "$@"
}

function exit_with_err_msg(){
    exit_code=$1

    if [[ $exit_code == "0" ]]; then
        return
    fi

    log "[ERROR] Error code, '${exit_code}' detected" \
        " at '${BASH_SOURCE[1]}':${BASH_LINENO[0]}." >&2

    log "exit 1." >&2
    exit 1
}

function get_base_docker_image_name(){
    local RESULT_IMAGE_REPOSITORY=$1

    # repository = Docker imageのタグの前の部分。
    # 例: hoge.io/daiana/foo:1.0　というdocker imageがあった場合
    # 以下のような名前の分解ができる.
    # hoge.io = registry
    # daiana/foo = repository (daiana部分をownerと呼ぶ事も.)
    # 1.0 = tag

    get_result_image_name RESULT_IMAGE "${RESULT_IMAGE_REPOSITORY}"

    image_name=$(
        . ./base_docker_image/util.sh    \
        && util.hoge "${base_image_repository}"
    )
    echo image_name
}

function base_docker_image_build(){
    # Check base image existence and if not exists, build it.
    local base_image_name=$1

    if [[ ! -z $( \
            docker image ls --format "{{.Repository}}:{{.Tag }}" \
            | grep "${base_image_name}" \
            || true ) ]]; then
        log "Image already exists. OK."
    else
        log "Because image was not found locally, start pulling."

        pull_result_msg=$(docker image pull "${base_image_name}"||true)

        if [[ ! -z "${pull_result_msg}" ]]; then
            log "Image pull succeeded. OK."
        else
            log "Because image was not found in registry, start building."
            docker image build -t
        fi
    fi
}

# base_docker_image_build "shinbero/hello-world:not_existing_tag"
# base_docker_image_build daianatest.azurecr.io/shinbero/hello-world:2021-09-30_12-13-22-UTC-96de0444c208c9b05f87fb6dbb3e155f28472970
# base_docker_image_build alpine:3.13333

# a=hoge/
# b=fuga
# a=${a%/}
# b=${b%/}

# echo $a
# echo $b

# echo $(dirname $a)
# echo $(dirname $b)

# RESULT_DOCKER_REGISTRY=aasdfas.io
# RESULT_IMAGE_REPOSITRY=daiana/python
# profile_RESULT_IMAGE_TAG=1.10

# RESULT_IMAGE=$(
#     printf '%s/%s:%s' \
#     "${RESULT_DOCKER_REGISTRY}" \
#     "${RESULT_IMAGE_REPOSITRY}" \
#     "${profile_RESULT_IMAGE_TAG}"
# )
# echo $RESULT_IMAGE

