#!/bin/bash

# Оновлення пакетів та встановлення apache2
apt-get update -y
apt-get install apache2 -y
systemctl start apache2
systemctl enable apache2

# Генерація самопідписаного SSL сертифікату за допомогою openssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=US/ST=Ohio/L=Cleveland/O=My company/OU=My company unit/CN=www.hometask8.com/emailAddress=my-email@example.com"

# Активація модуля SSL
a2enmod ssl

# Створення конфігураційного файлу для Apache з SSL
cat <<EOF > /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
    </VirtualHost>
</IfModule>
EOF

# Активація сайту з SSL та перезавантаження Apache
a2ensite default-ssl
systemctl restart apache2

# Створення стартової веб-сторінки
echo "<html><body><h1>Hello World!</h1></body></html>" > /var/www/html/index.html
