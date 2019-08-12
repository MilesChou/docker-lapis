FROM mileschou/lua:jit-2.1
LABEL maintainer="MilesChou <github.com/MilesChou>"

# Set environment
ENV OPENRESTY_VERSION=1.15.8.1 \
    OPENRESTY_PREFIX=/usr/local/openresty \
    LAPIS_VERSION=1.7.0
ENV LAPIS_OPENRESTY=${OPENRESTY_PREFIX}/nginx/sbin/nginx \
    PATH=${OPENRESTY_PREFIX}/bin:${OPENRESTY_PREFIX}/luajit/bin:${OPENRESTY_PREFIX}/nginx/sbin:${PATH}

# Set Persistent Deps
ENV BUILD_DEPS \
        build-essential \
        git-core \
        unzip \
        wget

# Install depandency packages
RUN set -xe && \
        apt-get update -y && apt-get install -y --no-install-recommends --no-install-suggests \
            ${BUILD_DEPS} \
            ca-certificates \
            libpcre3-dev \
            libssl-dev \
            zlib1g-dev \
        && \
        # Install OpenResty
        wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
        tar xf openresty-${OPENRESTY_VERSION}.tar.gz && rm -f openresty-${OPENRESTY_VERSION}.tar.gz && \
        cd openresty-${OPENRESTY_VERSION} && \
        ./configure \
            --with-luajit=/usr/local \
            --with-http_realip_module \
            --with-http_stub_status_module \
        && \
        make -j $(getconf _NPROCESSORS_ONLN) && make install && \
        cd / && rm -rf openresty-${OPENRESTY_VERSION} && \
        # Install Lapis
        docker-luarocks-install lapis ${LAPIS_VERSION} && \
        docker-luarocks-install moonscript && \
        # Remove build deps
        apt-get remove --purge -y ${BUILD_DEPS} && apt-get autoremove --purge -y && rm -r /var/lib/apt/lists/* && \
        # Test
        lapis -v && \
        # Initial project
        cd ${OPENRESTY_PREFIX}/nginx/conf && mv nginx.conf nginx.conf.bk && lapis new && moonc *.moon

# Set work directory
WORKDIR ${OPENRESTY_PREFIX}/nginx/conf

EXPOSE 8080

CMD ["lapis", "server", "production"]