FROM uqlibrary/docker-base:5

RUN rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm

#Enable the ius testing and disable mirrors to ensure getting latest, not an out of date mirror
RUN sed -i "s/mirrorlist/#mirrorlist/" /etc/yum.repos.d/ius-testing.repo && \
  sed -i "s/#baseurl/baseurl/" /etc/yum.repos.d/ius-testing.repo

RUN yum update -y && \
 yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
  yum install -y \
    php70-php-common \
    php70-php-cli \
    php70-php-fpm \
    php70-php-gd \
    php70-php-imap \
    php70-php-ldap \
    php70-php-mcrypt \
    php70-php-mysqlnd \
    php70-php-pdo \
    php70-php-pecl-geoip \
    php70-php-pecl-memcached \
    php70-php-pecl-xdebug \
    php70-php-pgsql \
    php70-php-soap \
    php70-php-xmlrpc \
    php70-php-mbstring \
    php70-php-tidy \
    git \
    newrelic-php5 \
    newrelic-sysmond \
    which && \
  yum clean all

COPY etc/php-fpm.d/www.conf /etc/opt/remi/php70/php-fpm.d/www.conf
COPY etc/php.d/15-xdebug.ini /etc/opt/remi/php70/php.d/15-xdebug.ini

RUN rm -f /etc/opt/remi/php70/php.d/20-mssql.ini && \
    rm -f /etc/opt/remi/php70/php.d/30-pdo_dblib.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Australia\/Brisbane/" /etc/opt/remi/php70/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/opt/remi/php70/php.ini && \
    sed -i "s/display_errors =.*/display_errors = Off/" /etc/opt/remi/php70/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/opt/remi/php70/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/opt/remi/php70/php-fpm.conf && \
    sed -i "s/error_log =.*/;error_log/" /etc/opt/remi/php70/php-fpm.conf && \
    usermod -u 1000 nobody && \
    ln -s /opt/remi/php70/root/usr/sbin/php-fpm /usr/sbin/php-fpm && \
    ln -s /etc/opt/remi/php70/php.ini /etc/php.ini && \
    ln -s /opt/remi/php70/root/bin/php /usr/bin/php

EXPOSE 9000

ENV NSS_SDB_USE_CACHE YES

ENTRYPOINT ["/opt/remi/php70/root/usr/sbin/php-fpm", "--nodaemonize"]​
