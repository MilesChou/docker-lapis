FROM alpine:3.4

# Install depandency packages
RUN apk add --no-cache \
        ca-certificates \
        gcc \
        g++ \
        make \
        openssl-dev \
        pcre-dev \
        perl \
        wget \
        unzip \
        zlib-dev \
    && \
        update-ca-certificates

# Set environment
ENV OPENRESTY_VERSION=1.9.15.1 \
    OPENRESTY_PREFIX=/usr/local/openresty \
    LUAROCKS_VERSION=2.3.0 \
    LAPIS_VERSION=1.5.1

# Install OpenResty
RUN set -xe && \
        wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
        tar xf openresty-${OPENRESTY_VERSION}.tar.gz && \
        cd openresty-${OPENRESTY_VERSION} && \
        ./configure \
            --prefix=$OPENRESTY_PREFIX \
            --with-luajit \
            --with-http_realip_module \
            --with-http_stub_status_module \
        && make && make install && \
        cd .. && rm -rf openresty-${OPENRESTY_VERSION}.tar.gz openresty-${OPENRESTY_VERSION}

# LuaRocks
RUN set -xe && \
        wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
        tar xf luarocks-${LUAROCKS_VERSION}.tar.gz && \
        cd luarocks-${LUAROCKS_VERSION} && \
        ./configure \
            --prefix=${OPENRESTY_PREFIX}/luajit \
            --with-lua=${OPENRESTY_PREFIX}/luajit/ \
            --lua-suffix=jit-2.1.0-beta2 \
            --with-lua-include=${OPENRESTY_PREFIX}/luajit/include/luajit-2.1 \
        && make build && make install && \
        cd .. && rm -rf luarocks-${LUAROCKS_VERSION}.tar.gz luarocks-${LUAROCKS_VERSION}

# Install Lapis
# RUN luarocks install lapis $LAPIS_VERSION && luarocks install moonscript

# Set work directory
WORKDIR $OPENRESTY_PREFIX/nginx/conf

ENV LAPIS_OPENRESTY=${OPENRESTY_PREFIX}/nginx/sbin/nginx \
    PATH=${OPENRESTY_PREFIX}/bin:${OPENRESTY_PREFIX}/luajit/bin:${OPENRESTY_PREFIX}/nginx/sbin:${PATH}

EXPOSE 8080
EXPOSE 80

# Setup lapis project.
# RUN mv nginx.conf nginx.conf.bk && lapis new && moonc *.moon

CMD ["lapis", "server", "production"]
