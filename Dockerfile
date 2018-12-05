ARG HTTPD_CRT=server.crt
ARG HTTPD_KEY=server.key
ARG HTTPD_DOCS_PATH=./src
ARG HTTPD_APACHE_VERSION=2.4

FROM httpd:${HTTPD_APACHE_VERSION}

ARG HTTPD_CRT
ARG HTTPD_KEY
ARG HTTPD_DOCS_PATH

# задействовать SSL
RUN sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
        conf/httpd.conf
COPY $HTTPD_CRT /usr/local/apache2/conf/server.crt
COPY $HTTPD_KEY /usr/local/apache2/conf/server.key

COPY $HTTPD_DOCS_PATH /usr/local/apache2/htdocs/
