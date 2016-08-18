FROM debian:jessie

# Install depandency packages
RUN apt-get update -y && apt-get install -y --no-install-recommends --no-install-suggests \
        build-essential \
        ca-certificates \
        git-core \
        libpcre3-dev \
        libssl-dev \
        luarocks \
        unzip \
    && rm -r /var/lib/apt/lists/*

# Set environment
ENV OPENRESTY_VERSION=1.9.15.1 \
    OPENRESTY_PREFIX=/opt/openresty \
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

# Install Lapis
RUN luarocks install lapis $LAPIS_VERSION && luarocks install moonscript

# Set work directory
WORKDIR $OPENRESTY_PREFIX/nginx/conf

ENV LAPIS_OPENRESTY=${OPENRESTY_PREFIX}/nginx/sbin/nginx

EXPOSE 8080
EXPOSE 80

# Setup lapis project.
RUN mv nginx.conf nginx.conf.bk && lapis new && moonc *.moon

CMD ["lapis", "server", "production"]
