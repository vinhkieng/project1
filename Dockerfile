FROM php:8.2-apache

# Enable Apache modules
RUN a2enmod rewrite

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Copy Apache config
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Copy project files
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install vendor
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["apache2-foreground"]
