ARG base_image
FROM $base_image
ENV APP_ROOT_DIR /app

COPY ./docker-entrypoint.sh /
COPY src ${APP_ROOT_DIR}/src
COPY exec_unittests.sh exec_code_review.sh ${APP_ROOT_DIR}/

ENTRYPOINT ["/docker-entrypoint.sh"]

# For APP_ROOT_DIR expansion, use sh -c to call python.
CMD ["sh", "-c", "python ${APP_ROOT_DIR}/src/hi.py"]
