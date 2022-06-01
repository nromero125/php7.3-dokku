FROM ubuntu:xenial


# Install Dependencies
RUN apt-get update && \
    apt-get install -y language-pack-en-base && \
    export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update

RUN apt-get install curl 
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y install nginx zip supervisor git php8.0 php8.0-mysql php8.0-sqlite3 php8.0-pgsql php8.0-zip php8.0-imap php8.0-bcmath php8.0-memcached php8.0-fpm php8.0-mbstring php8.0-xml php8.0-curl php8.0-intl php8.0-readline php8.0-cli php8.0-dev php8.0-gd php8.0-soap nodejs



# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer


# Install Node/NPM
RUN npm install -g webpack


# Configurations
RUN mkdir /run/php
COPY nginx/default /etc/nginx/sites-available
COPY supervisord /etc/supervisor/conf.d
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/cli/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/cli/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/max_execution_time = .*/max_execution_time = 30000/" /etc/php/8.0/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/fpm/php.ini


# Add our init script
ADD run.sh /run.sh
RUN chmod 755 /run.sh


RUN mkdir /app
WORKDIR /app

EXPOSE 80

CMD ["/run.sh"]
