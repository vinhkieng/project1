FROM php:8.2-apache

# 1. Cài đặt các thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git \
    && docker-php-ext-install pdo pdo_mysql zip

# 2. Bật mod_rewrite cho Laravel (để URL đẹp)
RUN a2enmod rewrite

# 3. Copy file cấu hình Apache
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# 4. Copy toàn bộ code vào container
COPY . /var/www/html

# 5. Thiết lập thư mục làm việc
WORKDIR /var/www/html

# 6. Cài đặt Composer và các gói thư viện (vendor)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7. CẤP QUYỀN GHI CHO DATABASE (Rất quan trọng với SQLite)
# Nếu không có dòng này, Laravel sẽ không thể ghi vào file database.sqlite
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# 8. Mở cổng 80
EXPOSE 80

# 9. LỆNH KHỞI ĐỘNG (Đã thêm tự động Migrate)
# Chạy migrate --force để tạo bảng trước, sau đó mới bật Apache
CMD ["sh", "-c", "touch /var/www/html/database/database.sqlite && php artisan migrate --force && apache2-foreground"]git add .