ARG base_image
FROM $base_image
ENV APP_ROOT_DIR /app

COPY ./docker-entrypoint.sh /
COPY src ${APP_ROOT_DIR}/src
COPY exec_unittests.sh exec_code_review.sh ${APP_ROOT_DIR}/

ENTRYPOINT ["/docker-entrypoint.sh"]

# TODO:
# CMDでk8s の cronjobで実行させたいコマンドを実行させる。
