set -u

# 事前にenv_IMAGE_REGISTRY環境変数をセットしてから呼び出すこと.
export BASE_IMAGE=${env_IMAGE_REGISTRY}/daiana/python:3.9.7-alpine3.14-1.0
