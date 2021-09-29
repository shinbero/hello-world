FROM python:3.9.7-alpine3.14

RUN pip install --upgrade pip \
    && pip install \
        flake8 \
        flake8-docstrings \
        pep8-naming \
        flake8-todo \
        autopep8 \
        radon

COPY ./ /app
