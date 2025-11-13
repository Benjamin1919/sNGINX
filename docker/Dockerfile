FROM debian:trixie AS builder

ARG LIBXML2_VERSION
ARG LIBXSLT_VERSION
ARG LIBGD_VERSION
ARG OPENSSL_VERSION
ARG ZLIB_VERSION
ARG PCRE2_VERSION
ARG NGINX_VERSION

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
WORKDIR /usr/local/src

RUN apt update && apt install --no-install-recommends --no-install-suggests -y ca-certificates wget

RUN (wget -q "https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${LIBXML2_VERSION}/libxml2-v${LIBXML2_VERSION}.tar.gz" || { echo "❌ Failed to fetch libxml2 from GitLab"; exit 1; }) \
    && tar -zxf libxml2-v${LIBXML2_VERSION}.tar.gz
RUN (wget -q "https://gitlab.gnome.org/GNOME/libxslt/-/archive/v${LIBXSLT_VERSION}/libxslt-v${LIBXSLT_VERSION}.tar.gz" || { echo "❌ Failed to fetch libxslt from GitLab"; exit 1; }) \
    && tar -zxf libxslt-v${LIBXSLT_VERSION}.tar.gz
RUN (wget -q "https://github.com/libgd/libgd/releases/download/gd-${LIBGD_VERSION}/libgd-${LIBGD_VERSION}.tar.gz" || { echo "❌ Failed to fetch libgd from GitHub"; exit 1; }) \
    && tar -zxf libgd-${LIBGD_VERSION}.tar.gz
RUN (wget -q "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.12/GeoIP-1.6.12.tar.gz" || { echo "❌ Failed to fetch GeoIP from GitHub"; exit 1; }) \
    && tar -zxf GeoIP-1.6.12.tar.gz
RUN (wget -q "https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz" || { echo "❌ Failed to fetch OpenSSL from GitHub"; exit 1; }) \
    && tar -zxf openssl-${OPENSSL_VERSION}.tar.gz
RUN (wget -q "https://github.com/madler/zlib/releases/download/v${ZLIB_VERSION}/zlib-${ZLIB_VERSION}.tar.gz" || { echo "❌ Failed to fetch zlib from GitHub"; exit 1; }) \
    && tar -zxf zlib-${ZLIB_VERSION}.tar.gz
RUN (wget -q "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${PCRE2_VERSION}/pcre2-${PCRE2_VERSION}.tar.gz" || { echo "❌ Failed to fetch PCRE2 from GitHub"; exit 1; }) \
    && tar -zxf pcre2-${PCRE2_VERSION}.tar.gz
RUN (wget -q "https://github.com/nginx/nginx/releases/download/release-${NGINX_VERSION}/nginx-${NGINX_VERSION}.tar.gz" || { echo "❌ Failed to fetch Nginx from GitHub"; exit 1; }) \
    && tar -zxf nginx-${NGINX_VERSION}.tar.gz

RUN apt install --no-install-recommends --no-install-suggests -y \
    build-essential pkg-config autoconf automake libtool python3-dev nasm

RUN cd libxml2-v${LIBXML2_VERSION} \
    && ./autogen.sh --prefix=/usr/local --enable-static --disable-shared \
    && make -j$(nproc) \
    && make install

RUN cd libxslt-v${LIBXSLT_VERSION} \
    && ./autogen.sh --prefix=/usr/local --enable-static --disable-shared \
    && make -j$(nproc) \
    && make install

RUN apt install --no-install-recommends --no-install-suggests -y \
    zlib1g-dev libbrotli-dev libbz2-dev libpng-dev libfreetype-dev \
    libexpat1-dev uuid-dev libfontconfig-dev libsharpyuv-dev \
    libimagequant-dev libjpeg62-turbo-dev libdeflate-dev libjbig-dev \
    liblerc-dev liblzma-dev libwebp-dev libzstd-dev libtiff-dev \
    libvpx-dev x11proto-dev libxau-dev libxdmcp-dev libxcb1-dev \
    xtrans-dev libx11-dev libxpm-dev

RUN cd libgd-${LIBGD_VERSION} \
    && ./configure --prefix=/usr/local --enable-static --disable-shared \
        --disable-gd-formats --with-zlib --with-png --with-freetype \
        --with-fontconfig --with-jpeg --with-liq --with-xpm --with-tiff --with-webp \
        --without-heif --without-avif --without-raqm \
    && make -j$(nproc) \
    && make install

RUN cd GeoIP-1.6.12 \
    && ./configure --prefix=/usr/local --enable-static --disable-shared \
    && make -j$(nproc) \
    && make install

RUN echo "nginx:x:101:" >> /etc/group \
    && echo "nginx:x:101:101:nginx:/nonexistent:/sbin/nologin" >> /etc/passwd \
    && mkdir -p /etc/nginx/conf.d \
    && mkdir -p /etc/nginx/ssl \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/tmp/nginx_tmp/{client_body_temp,proxy_temp,fastcgi_temp,uwsgi_temp,scgi_temp} \
    && chown -R nginx:nginx /var/log/nginx \
    && chown -R nginx:nginx /var/tmp/nginx_tmp

RUN cd nginx-${NGINX_VERSION} \
    && cp -r ./html /usr/local/share/ \
    && export NGX_CFLAG="$(pkg-config --cflags libexslt gdlib geoip)" \
    && export NGX_LFLAG="$(pkg-config --static --libs libexslt gdlib geoip)" \
    && ./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/tmp/nginx_tmp/client_body_temp \
        --http-proxy-temp-path=/var/tmp/nginx_tmp/proxy_temp \
        --http-fastcgi-temp-path=/var/tmp/nginx_tmp/fastcgi_temp \
        --http-uwsgi-temp-path=/var/tmp/nginx_tmp/uwsgi_temp \
        --http-scgi-temp-path=/var/tmp/nginx_tmp/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_v3_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_xslt_module \
        --with-http_image_filter_module \
        --with-http_geoip_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_degradation_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_geoip_module \
        --with-stream_ssl_preread_module \
        --with-openssl=../openssl-${OPENSSL_VERSION} \
        --with-zlib=../zlib-${ZLIB_VERSION} \
        --with-pcre=../pcre2-${PCRE2_VERSION} \
        --with-pcre-jit \
        --with-cc-opt="-static -O3 -pipe -pthread -fopenmp -fstack-protector-strong -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2 --param=ssp-buffer-size=4 -mtune=generic ${NGX_CFLAG}" \
        --with-ld-opt="-static -Wl,-O1 ${NGX_LFLAG}" \
    && make -j$(nproc) \
    && make install

RUN strip /usr/local/sbin/nginx \
    && rm -f /etc/nginx/*.default


FROM gcr.io/distroless/static-debian13:latest

WORKDIR /

COPY --chown=root:root --chmod=644 distroless/etc/group         /etc/
COPY --chown=root:root --chmod=644 distroless/etc/passwd        /etc/
COPY --chown=root:root --chmod=644 distroless/etc/nsswitch.conf /etc/

COPY --from=builder --chown=nginx:nginx --chmod=644 /var/log/nginx/        /var/log/nginx/
COPY --from=builder --chown=nginx:nginx --chmod=644 /var/tmp/nginx_tmp/    /var/tmp/nginx_tmp/
COPY --from=builder --chown=root:root   --chmod=644 /etc/nginx/            /etc/nginx/
COPY --from=builder --chown=root:root   --chmod=555 /usr/local/sbin/nginx  /usr/local/sbin/
COPY --from=builder --chown=root:root   --chmod=644 /usr/local/share/html/ /usr/local/share/html/

COPY --chown=root:root --chmod=644 conf/nginx.conf /etc/nginx/

VOLUME /var/log/nginx
VOLUME /var/tmp/nginx_tmp

STOPSIGNAL SIGQUIT

CMD ["/usr/local/sbin/nginx", "-g", "daemon off;"]
