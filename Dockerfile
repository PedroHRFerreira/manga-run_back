# Use a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instale extensões necessárias do PHP
RUN docker-php-ext-install pdo pdo_mysql

# Instale o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Defina o diretório de trabalho
WORKDIR /var/www/html

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do Composer
RUN composer install

# Defina as permissões corretas
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite
