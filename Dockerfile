FROM php:8.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy Laravel files
COPY . .

# Install Laravel dependencies
RUN composer install

# Generate Laravel application key
RUN php artisan key:generate
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
          | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
          && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
          | sudo tee /etc/apt/sources.list.d/ngrok.list \
          && sudo apt update \
          && sudo apt install ngrok
          ngrok authtoken 1wV4b9ZH1b9xROsGgNRIDRW2b9O_31XFQNuqasUAGbfvsCjtj
RUN php artisan serve

