FROM mileschou/lua:jit-2.1-alpine
LABEL maintainer="MilesChou <github.com/MilesChou>"

# Set environment
ENV OPENRESTY_VERSION=1.15.8.1 \
    OPENRESTY_PREFIX=/usr/local/openresty \
    LAPIS_VERSION=1.7.0
ENV LAPIS_OPENRESTY=${OPENRESTY_PREFIX}/nginx/sbin/nginx \
    PATH=${OPENRESTY_PREFIX}/bin:${OPENRESTY_PREFIX}/luajit/bin:${OPENRESTY_PREFIX}/nginx/sbin:${PATH}

# Set Build Deps
ENV BUILD_DEPS \
        gcc \
        g++ \
        git \
        make \
        openssl-dev \
        pcre-dev \
        perl \
        zlib-dev

# Set Persistent Deps
ENV PERSISTENT_DEPS \
        ca-certificates \
        pcre

RUN set -xe && \
        apk add --no-cache --virtual .build-deps ${BUILD_DEPS} && \
        apk add --no-cache ${PERSISTENT_DEPS} && \
        update-ca-certificates && \
        # Install OpenResty
        wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
        tar xf openresty-${OPENRESTY_VERSION}.tar.gz && rm -f openresty-${OPENRESTY_VERSION}.tar.gz && \
        cd openresty-${OPENRESTY_VERSION} && \
        ./configure \
            --with-luajit=/usr/local \
        && \
        make -j $(getconf _NPROCESSORS_ONLN) && make install && \
        cd / && rm -rf openresty-${OPENRESTY_VERSION} && \
        # Install Lapis
        docker-luarocks-install lapis ${LAPIS_VERSION} && \
        docker-luarocks-install moonscript && \
        lapis -v && \
        # Initial project
        cd ${OPENRESTY_PREFIX}/nginx/conf && mv nginx.conf nginx.conf.bk && lapis new && moonc *.moon && \
        apk del .build-deps

# Set work directory
WORKDIR ${OPENRESTY_PREFIX}/nginx/conf

EXPOSE 8080

CMD ["lapis", "server", "production"]
