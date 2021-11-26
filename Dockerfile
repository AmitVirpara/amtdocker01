FROM php:7.4-fpm

ENV APP_HOME /var/www/html
ENV USERNAME www-data

RUN chown www-data:www-data /var/www/html

WORKDIR $APP_HOME

# COPY ./ $APP_HOME/
COPY ./docker/general/nginx-defail.conf /etc/nginx/conf.d/default.conf

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql sockets

# Clone the conf files into the docker container
RUN git clone https://github.com/lalitvjy/scraper.git /var/www/html

RUN apt-get update \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

    # && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
    # && apt-get install -y nodejs \
    # && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    # && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list


# Add user for laravel application
# RUN groupadd -g 1000 www-data
# RUN useradd -u 1000 -ms /bin/bash -g www-data www-data

# Copy existing application directory contents
# COPY . /var/www/html

# Copy existing application directory permissions
# COPY --chown=www-data:www-data . /var/www/html

# Change current user to www
USER root

EXPOSE 9000
CMD [ "php-fpm" ]

CMD /var/www/html composer install
# CMD /var/www/html php artisan migrate
