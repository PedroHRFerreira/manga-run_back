# Use a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instale dependências do sistema necessárias para o Laravel (GD, zip, etc.)
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Instale o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do Composer
RUN composer install --no-interaction --optimize-autoloader

# Defina as permissões corretas para o diretório de armazenamento e cache do Laravel
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Habilite o módulo rewrite do Apache
RUN a2enmod rewrite

RUN echo 'LogLevel debug' >> /etc/apache2/apache2.conf

EXPOSE 80
