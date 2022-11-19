#!/bin/bash

pkg update && pkg upgrade -y

pkg update

pkg upgrade

pkg update

pkg upgrade

pkg install root-repo

pkg install unstable-repo

pkg install x11-repo

pkg install git

sudo apt-get remove -y ruby

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable --ruby

source ~/.rvm/scripts/rvm

# Install PHP7.0

sudo apt-get install -y software-properties-common

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get update

sudo apt-get install -y php7.0-fpm php7.0-mysql php7.0-curl php7.0-gd php7.0-json php7.0-mcrypt php7.0-opcache php7.0-xml php7.0-zip

# Install Apache2

sudo apt-get install -y apache2-mpm-event libapache2-mod-fastcgi

sudo a2enmod rewrite headers alias actions fastcgi

# Set the default welcome site to phpinfo

sudo rm /var/www/html/index.html

echo "<h1>Welcome to your WEBDEV machine</h1><?php phpinfo();" | sudo tee /var/www/html/index.php

# Add FastCGI Settings

TEXT=$(cat <<'EOT'

<IfModule mod_fastcgi.c>\n

\tAddHandler php7-fcgi-www .php\n

\tAction php7-fcgi-www /php7-fcgi-www\n

\tAlias /php7-fcgi-www /usr/lib/cgi-bin/php7-fcgi-www\n

\tFastCgiExternalServer /usr/lib/cgi-bin/php7-fcgi-www -socket /run/php/php7.0-fpm.sock -pass-header Authorization\n

\n

\t<Directory "/usr/lib/cgi-bin">\n

\t\tRequire all granted\n

\t</Directory>\n

</IfModule>\n

\n

EOT

)

cd ~

echo $TEXT > tmp

cat tmp /etc/apache2/sites-enabled/000-default.conf > tmp2

sudo mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.bk_conf

sudo mv tmp2 /etc/apache2/sites-enabled/000-default.conf

rm tmp

sudo service apache2 restart

# Install MariaDB

export DEBIAN_FRONTEND=noninteractive

sudo -E apt-get -q -y install mariadb-server

# Install NodeJS with NVM

sudo apt-get install -y build-essential libssl-dev

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash

export NVM_DIR="/home/anthony/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install stable

# Install Composer

php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php

php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

php composer-setup.php

php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

echo '\nPATH=~/.composer/vendor/bin:$PATH' >> ~/.zshrc

echo '\nPATH=~/.composer/vendor/bin:$PATH' >> ~/.profile

PATH=~/.composer/vendor/bin:$PATH

# Install Laravel installer

composer global require "laravel/installer"

# Install Bower & Gulp packages

npm install -g bower gulp

echo "Close and restart your terminal"

