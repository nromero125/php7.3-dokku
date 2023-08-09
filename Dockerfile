FROM ubuntu:focal


# Install Dependencies
RUN apt-get update && \
    apt-get install -y language-pack-en-base && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update

RUN apt-get -y install curl 
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y install nginx zip supervisor git php7.4 php7.4-mysql php7.4-sqlite3 php7.4-pgsql php7.4-zip php7.4-imap php7.4-bcmath php7.4-memcached php7.4-fpm php7.4-mbstring php7.4-xml php7.4-curl php7.4-intl php7.4-readline php7.4-cli php7.4-dev php7.4-gd php7.4-soap nodejs



# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer


# Install Node/NPM
RUN npm install -g webpack


# Configurations
RUN mkdir /run/php
COPY nginx/default /etc/nginx/sites-available
COPY supervisord /etc/supervisor/conf.d
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/cli/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/max_execution_time = .*/max_execution_time = 30000/" /etc/php/7.4/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini


# Add our init script
ADD run.sh /run.sh
RUN chmod 755 /run.sh


RUN mkdir /app
WORKDIR /app

EXPOSE 80

CMD ["/run.sh"]
