FROM uqlibrary/docker-base:3

# Disable new relic until their php7 agent comes out, see:
# https://discuss.newrelic.com/t/php-agent-and-php-7-0/27687/27
#RUN rpm -Uvh http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm

# The following don't have a php7 version yet
#    newrelic-php5 \
#    newrelic-sysmond \

RUN \
  yum install -y \
    php70u-common \
    php70u-fpm \
    php70u-gd \
    php70u-imap \
    php70u-ldap \
    php70u-mcrypt \
    php70u-mysqlnd \
    php70u-pdo \
    php70u-pecl-geoip \
    php70u-pecl-memcached \
    php70u-pecl-redis \
    php70u-pecl-xdebug \
    php70u-pgsql \
    php70u-sqlite \
    php70u-soap \
    php70u-xmlrpc \
    php70u-mbstring \
    php70u-tidy \
    git && \
  yum clean all

COPY etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf
COPY etc/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini

RUN rm -f /etc/php.d/20-mssql.ini && \
    rm -f /etc/php.d/30-pdo_dblib.ini && \
    sed -i "s/;date.timezone =.*/date.timezone = Australia\/Brisbane/" /etc/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php.ini && \
    sed -i "s/display_errors =.*/display_errors = Off/" /etc/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php-fpm.conf && \
    sed -i "s/error_log =.*/;error_log/" /etc/php-fpm.conf && \
    usermod -u 1000 nobody

EXPOSE 9000

ENV NSS_SDB_USE_CACHE YES

ENTRYPOINT ["/usr/sbin/php-fpm", "--nodaemonize"]​