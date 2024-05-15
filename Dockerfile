FROM php:8.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | apt-key add -
RUN echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list
RUN apt-get update && apt-get install -y ngrok-client

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
CMD php artisan serve & ngrok http 8000
