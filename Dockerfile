FROM php:8.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    gnupg

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Ngrok
RUN curl -sO https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin && \
    rm ngrok-stable-linux-amd64.zip

# Set working directory
WORKDIR /var/www/html

# Copy Laravel files
COPY . .

# Install Laravel dependencies
RUN composer install

# Generate Laravel application key
RUN php artisan key:generate

# Ngrok authentication
RUN ngrok authtoken 1wV4b9ZH1b9xROsGgNRIDRW2b9O_31XFQNuqasUAGbfvsCjtj

# Start Laravel server and Ngrok
RUN php artisan serve --host=0.0.0.0 & ngrok http 8000
