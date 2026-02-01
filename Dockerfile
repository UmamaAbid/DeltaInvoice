FROM php:8.2-cli

# System deps + PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip zip curl \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql gd exif zip

# Install Node.js (npm included)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Laravel setup
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

EXPOSE 8080
CMD php artisan serve --host=0.0.0.0 --port=8080
