FROM openswoole/swoole:4.12.1-php8.2

RUN docker-php-ext-install pcntl

ENV COMPOSER_ALLOW_SUPERUSER=1

COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install

RUN chgrp -R www-data storage bootstrap/cache

RUN chmod -R ug+rwx storage bootstrap/cache

RUN apt-get update && apt-get install -y nginx

COPY ./nginx.conf /etc/nginx/sites-available/default

RUN apt-get update && apt-get install -y supervisor

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
