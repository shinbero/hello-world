#!/bin/bash

# Check base image existence and if not exists, build it.

# # The directory where this script is placed.
# BASE_DIR="$(dirname "$0")"
# COMMON_SETUP_SCRIPT=${BASE_DIR}/../common_setup.sh

# if [ "$#" -ne 1 ]; then
#     log "Usage: build_image.sh <image directory name. ex) python>"
#     exit 1
# fi

# image_dir_name=$1


# function get_base_image_name(){
#     local base_dir="$(dirname "$0")"

#     local result_var_name=$1
#     local result_image_repository=$2

#     local image_base_dir="${base_dir}/${result_image_repository}"
#     local image_profile_file=${image_base_dir}/image_profile
#     . ${image_profile_file}

#     local base_image=$(
#         printf '%s:%s' \
#         "${profile_BASE_IMAGE_REPOSITORY}" \
#         "${profile_BASE_IMAGE_TAG}"
#     )

#     declare -g $result_var_name=$base_image
# }


# function get_result_image_name(){
#     local result_var_name=$1
#     local result_image_repository=$2

#     local image_base_dir="${BASE_DIR}/${result_image_repository}"
#     local image_profile_file=${image_base_dir}/image_profile
#     . ${image_profile_file}

#     local result_image=$(
#         printf '%s/%s/%s:%s' \
#         "${RESULT_IMAGE_REGISTRY}" \
#         "${RESULT_IMAGE_REPOSITORY_OWNER}" \
#         "${result_image_repository}" \
#         "${profile_RESULT_IMAGE_TAG}"
#     )

#     declare -g $result_var_name=$result_image
# }

# echo "$(dirname "$0")"

# get_base_image_name

# cd "$(dirname "$0")"

# function f(){
#     . python/image_profile
# }

# echo profile_BASE_IMAGE_TAG=$profile_BASE_IMAGE_TAG

# f
# echo After f...
# echo profile_BASE_IMAGE_TAG=$profile_BASE_IMAGE_TAG

# . python/image_profile
# echo profile_BASE_IMAGE_TAG=$profile_BASE_IMAGE_TAG


function check_image_existence_in_registry(){
    std_err=$(docker manifest inspect alpine:3.1444444 > /dev/null || true)
    echo std_err=${std_err}

    if [[ -z "${std_err}" ]]; then
        echo true
    else
        echo false
    fi
}

# manifestが見つかれば、返り値は空文字.
image_exists=$(docker manifest inspect alpine:3.14 > /dev/null 2>&1 && echo "1" || echo "0")



# if [[ $(check_image_existence_in_registry) -eq "true" ]]; then
if [[ $image_exists -eq "1" ]]; then
    echo "YESSSS"
else
    echo "NOOOO"
fi


pull_result_msg=$(docker image pull "${base_image}"||true)

        if [[ ! -z "${pull_result_msg}" ]]; then
            log "Image pull succeeded. OK."
        else
            log "Because image was not found in registry, start building."
            docker image build -t
        fi