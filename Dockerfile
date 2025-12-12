FROM php:8.2-apache

# 1. Cài đặt thư viện hệ thống
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git \
    && docker-php-ext-install pdo pdo_mysql zip

# 2. Bật mod_rewrite
RUN a2enmod rewrite

# 3. Copy file cấu hình Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 4. Copy code
COPY . /var/www/html

# 5. Set thư mục làm việc
WORKDIR /var/www/html

# 6. Cài Composer & Dependencies
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7. Cấp quyền (QUAN TRỌNG)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# 8. Mở cổng
EXPOSE 80

# 9. LỆNH KHỞI ĐỘNG (Đã sửa lỗi cú pháp)
# Dùng cú pháp shell (không ngoặc vuông) để tránh lỗi "sh: not found"
CMD touch /var/www/html/database/database.sqlite && php artisan migrate --force && apache2-foreground