# Dockerfile - alpine
# https://github.com/openresty/docker-openresty

ARG RESTY_IMAGE_BASE="dickzh/fastdfs-noconf"
ARG RESTY_IMAGE_TAG="1.0.0"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="dickzh <dongkai.zhang@gmail.com>"

# Copy nginx configuration files
#ADD conf/fdfs/client.conf /etc/fdfs/
#ADD conf/fdfs/http.conf /etc/fdfs/
#ADD conf/fdfs/mime.types /etc/fdfs/
#ADD conf/fdfs/storage.conf /etc/fdfs/
#ADD conf/fdfs/tracker.conf /etc/fdfs/
#ADD conf/fdfs/mod_fastdfs.conf /etc/fdfs/

ADD conf/fdfs/ /etc/fdfs/

ADD images/anti-steal.jpg /var/lib/fdfs/images/

#ADD conf/nginx/conf.d/default.conf /etc/nginx/conf.d/
#ADD conf/nginx/conf.d/fastdfs.conf /etc/nginx/conf.d/

ADD conf/nginx/conf.d/ /etc/nginx/conf.d/

COPY conf/nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD script/fastdfs.sh /var/lib/fdfs/

ARG RESTY_PACKAGE_RUNDEPS=""


RUN set -x \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        ${RESTY_PACKAGE_RUNDEPS} \
    && ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log

# Add additional binaries into PATH for convenience
ENV PATH=$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin:/var/lib/fdfs

#CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

VOLUME /etc/fdfs
VOLUME /etc/nginx
VOLUME /usr/local/openresty/nginx/conf
VOLUME /var/lib/fdfs
VOLUME /usr/local/openresty/nginx/logs

EXPOSE 22122 23000 8888 80
CMD ["/var/lib/fdfs/fastdfs.sh"]

# Use SIGQUIT instead of default SIGTERM to cleanly drain requests
# See https://github.com/openresty/docker-openresty/blob/master/README.md#tips--pitfalls
STOPSIGNAL SIGQUIT
