# 1) Sử dụng PHP + Apache
FROM php:8.2-apache

# 2) Cài extension Laravel cần
RUN docker-php-ext-install pdo pdo_mysql

# 3) Bật rewrite cho Laravel route
RUN a2enmod rewrite

# 4) Copy source vào container
COPY . /var/www/html

# 5) Copy file cấu hình apache đặc biệt cho Laravel
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 6) Cài Composer trong container
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 7) Cài vendor
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 8) Set quyền
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9) Expose port 80
EXPOSE 80

# 10) Start Apache
CMD ["apache2-foreground"]
