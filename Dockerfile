FROM scratch
MAINTAINER 007 "waajueji@gmail.com"
ADD centos-7.4.1708-docker.tar.xz /
RUN yum -y install openssl openssl-devel pcre pcre-devel gcc gcc-c++ make libxml2 libxml2-devel libedit libedit-devel m4 autoconf

#INSTALL NGINX

ADD pkgs/nginx-1.13.5.tar.gz /tmp/
#RUN tar -xvf /tmp/nginx-1.13.5.tar.gz
RUN cd /tmp/nginx-1.13.5 && ./configure --prefix=/opt/nginx && make && make install
ADD conf/nginx.conf /opt/nginx/conf/nginx.conf

#INSTALL PHP

ADD pkgs/php-7.1.10.tar.bz2 /tmp/
#RUN tar -xvf php-7.1.10.tar.bz2
RUN cd /tmp/php-7.1.10 && ./configure   --build=x86_64-linux-musl   --with-config-file-path=/usr/local/etc/php   --with-config-file-scan-dir=/usr/local/etc/php/conf.d   --disable-cgi   --enable-ftp   --enable-mbstring   --enable-mysqlnd     --with-libedit   --with-openssl   --with-zlib   --enable-fpm   --with-fpm-user=www-data   --with-fpm-group=www-data   build_alias=x86_64-linux-musl && make && make install && mkdir -p /usr/local/etc/php
ADD conf/php.ini /usr/local/etc/php/php.ini
RUN cp /usr/local/etc/php-fpm.d/www.conf.default /usr/local/etc/php-fpm.d/www.conf
ADD conf/php-fpm.conf /usr/local/etc/php-fpm.conf
RUN useradd -M www-data

#INSTALL PHPREDIS

ADD pkgs/3.1.4.tar.gz /tmp/
#RUN tar -xvf 3.1.4.tar.gz
RUN cd /tmp/phpredis-3.1.4 &&  /usr/local/bin/phpize && ./configure --with-php-config=/usr/local/bin/php-config && make && make install 
RUN rm -rf /var/cache/yum
RUN yum clean all
RUN rm -rf /tmp/*
EXPOSE 80
LABEL name="CentOS Base Image" vendor="CentOS 7" license="GPLv2" build-date="20171024"
ENTRYPOINT ["/opt/nginx/sbin/nginx","-g","daemon off;"]
