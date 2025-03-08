FROM nginx:1.27

SHELL ["/bin/bash", "-l", "-c"]

COPY ./nginx.conf /etc/nginx/conf.d/
COPY ./test.sh /test.sh

ENTRYPOINT . /test.sh