# Step 1: Use the official PHP image with Apache
FROM php:8.1-apache

# Step 2: Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Enable Apache mod_rewrite (for Laravel's routing)
RUN a2enmod rewrite

# Step 4: Install Composer (PHP package manager)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Step 5: Set the working directory to /var/www/html
WORKDIR /var/www/html

# Step 6: Copy your Laravel project into the container
COPY . .

# Step 7: Install PHP extensions needed for Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Step 8: Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Step 9: Set proper file permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Step 10: Expose port 80 (the default HTTP port)
EXPOSE 80

# Step 11: Start Apache server
CMD ["apache2-foreground"]
