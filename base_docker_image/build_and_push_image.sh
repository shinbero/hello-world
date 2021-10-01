#!/bin/bash

# The directory where this script is placed.
BASE_DIR="$(dirname "$0")"
COMMON_SETUP_SCRIPT=${BASE_DIR}/../common_setup.sh

. ${COMMON_SETUP_SCRIPT}

if [ "$#" -ne 1 ]; then
    log "Usage: build_image.sh <image directory name. ex) python>"
    exit 1
fi

image_dir_name=$1


function load_image_profile(){
    local image_base_dir=$1

    local image_profile_file=${image_base_dir}/image_profile
    . ${image_profile_file}
}

function get_base_image_name(){
    local base_image=$(
        printf '%s:%s' \
        "${profile_BASE_IMAGE_REPOSITORY}" \
        "${profile_BASE_IMAGE_TAG}"
    )

    echo "${base_image}"
}


function get_result_image_name(){
    local result_image_repo=$1

    local result_image=$(
        printf '%s/%s/%s:%s' \
        "${RESULT_IMAGE_REGISTRY}" \
        "${RESULT_IMAGE_REPO_OWNER}" \
        "${result_image_repo}" \
        "${profile_RESULT_IMAGE_TAG}"
    )

    echo "${result_image}"
}

function image_build(){
    # Localに同名のimageが既に存在していないかを確認し、buildする。

    local base_image=$1
    local result_image=$2
    local image_base_dir=$3

    cd "${image_base_dir}"

    if [[ -z $( \
            docker image ls --format "{{.Repository}}:{{.Tag }}" \
            | grep "${result_image}" \
            || true \
            ) ]]; then
        log "Start generating Dockerfile from template."

        local template_dockerfile=Dockerfile.template
        local generated_dockerfile=Dockerfile

        cat ${template_dockerfile} \
            | sed -e "s#%%__BASE_IMAGE__%%#${base_image}#g" \
            > ${generated_dockerfile}

        log "Start building image."
        docker image build -t ${result_image} -f ${generated_dockerfile} .
    else
        log "[WARNING] Docker image, '${result_image}' already exists!" \
            " Skip image build."
        log "[WARNING] If you really wanted to build new image with" \
            " new Dockerfile, please change profile_RESULT_IMAGE_TAG in" \
            " image_profile file."
    fi   
}

function image_push(){
    # This function requires docker login in advance.
    local image=$1

    # manifestが見つからない場合、'docker manifest inspect'は
    # non-zero exit codeを返す.
    image_exists=$(
        docker manifest inspect "${image}" > /dev/null 2>&1 \
        && echo "1" \
        || echo "0"
    )

    if [[ "${image_exists}" -eq "1" ]]; then
        log "Image already exists in remote registry. Skip pushing."
    else
        log "Image doesn't exist in remote registry yet. Start pushing." \
            " (This requires docker login to the registry in advance.)"
        docker image push "${image}"
    fi
}

# ---  Project config  --------------------------------------------------------
RESULT_IMAGE_REGISTRY=daianatest.azurecr.io
RESULT_IMAGE_REPO_OWNER=daiana
# -----------------------------------------------------------------------------

# Remove trailing slash.
IMAGE_DIR_NAME=$(echo ${image_dir_name} | sed 's:/*$::')
IMAGE_BASE_DIR="${BASE_DIR}/${IMAGE_DIR_NAME}"

# Build結果のImage repo名は、ディレクトリ名と同じにする.
RESULT_IMAGE_REPO=${IMAGE_DIR_NAME}

load_image_profile "${IMAGE_BASE_DIR}"

BASE_IMAGE=$(get_base_image_name)
RESULT_IMAGE=$(get_result_image_name "${RESULT_IMAGE_REPO}")

log "Will build image, '${RESULT_IMAGE}' from '${BASE_IMAGE}'."
image_build \
    "${BASE_IMAGE}" \
    "${RESULT_IMAGE}" \
    "${IMAGE_BASE_DIR}"

image_push \
    "${RESULT_IMAGE}"

log "Done"

