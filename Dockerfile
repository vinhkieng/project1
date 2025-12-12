FROM php:8.2-apache

# 1) Cài extension cần thiết
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# 2) Bật mod_rewrite cho Laravel
RUN a2enmod rewrite

# 3) Copy toàn bộ code vào container
COPY . /var/www/html

# 4) Copy file cấu hình apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 5) Copy composer vào container
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 6) Cài vendor
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7) Set quyền cho Laravel (storage + bootstrap)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 8) Expose port 80 để Render nhận
EXPOSE 80

# 9) Chạy apache
CMD ["apache2-foreground"]
