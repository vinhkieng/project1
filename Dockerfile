FROM php:8.2-apache

# Cài extensions
RUN docker-php-ext-install pdo pdo_mysql

# Bật rewrite cho Laravel
RUN a2enmod rewrite

# Copy toàn bộ source vào container
COPY . /var/www/html

# Set thư mục làm việc
WORKDIR /var/www/html

# Copy cấu hình Apache để trỏ đúng public/
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf

# Cấp quyền
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

