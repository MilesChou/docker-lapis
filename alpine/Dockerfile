FROM mileschou/lua:jit-2.1-alpine
LABEL maintainer="MilesChou <github.com/MilesChou>"

# Ref https://github.com/openresty/docker-openresty/blob/master/alpine/Dockerfile
ARG OPENRESTY_CONFIG_OPTIONS="\
    --with-http_auth_request_module \
    --with-http_gunzip_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_v2_module \
    --with-ipv6 \
    --with-pcre-jit \
    --with-sha1-asm \
    --with-stream \
    --with-stream_ssl_module \
    --with-threads \
    "

# Set environment
ENV OPENRESTY_VERSION=1.15.8.1 \
    OPENRESTY_PREFIX=/usr/local/openresty \
    LAPIS_VERSION=1.7.0
ENV PATH=${OPENRESTY_PREFIX}/bin:${OPENRESTY_PREFIX}/nginx/sbin:${PATH}

RUN set -xe && \
        # Install build deps
        apk add --no-cache --virtual .build-deps \
            gcc \
            g++ \
            git \
            make \
            openssl-dev \
            pcre-dev \
            perl \
            zlib-dev \
        && \
        # Install persistent deps
        apk add --no-cache \
            ca-certificates \
            pcre \
        && \
        update-ca-certificates && \
        # Install OpenResty
        wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
        tar xf openresty-${OPENRESTY_VERSION}.tar.gz && rm -f openresty-${OPENRESTY_VERSION}.tar.gz && \
        cd openresty-${OPENRESTY_VERSION} && \
        ./configure \
            --with-luajit=/usr/local \
            ${OPENRESTY_CONFIG_OPTIONS} \
        && \
        make -j $(getconf _NPROCESSORS_ONLN) && make install && \
        cd / && rm -rf openresty-${OPENRESTY_VERSION} && \
        # Install Lapis
        docker-luarocks-install lapis ${LAPIS_VERSION} && \
        docker-luarocks-install moonscript && \
        # Remove build deps
        apk del .build-deps && \
        # Test
        lapis -v

CMD ["lapis", "-v"]
