FROM phpswoole/swoole:5.1-php8.3

RUN docker-php-ext-install pcntl pdo_pgsql

ENV COMPOSER_ALLOW_SUPERUSER=1

COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install

RUN chgrp -R www-data storage bootstrap/cache

RUN chmod -R ug+rwx storage bootstrap/cache

RUN apt-get update && apt-get install -y nginx

COPY ./nginx.conf /etc/nginx/sites-available/default

RUN apt-get update && apt-get install -y supervisor

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN php artisan octane:install --server=swoole

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
