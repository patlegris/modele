#!/bin/bash

echo "Provisioning virtual machine..."
echo "=========================================="
echo "Updating Ubuntu"
sudo apt-get update > /dev/null
sudo apt-get upgrade > /dev/null



# Git
#echo "Installing Git"
#sudo apt-get install git -y > /dev/null

# Apache
echo "Installing Apache"
sudo apt-get install apache2 -y > /dev/null

# PHP
echo "Updating PHP repository"
sudo apt-get install python-software-properties -y > /dev/null
sudo add-apt-repository ppa:ondrej/php5-oldstable -y > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y php5 > /dev/null

#echo "Installing PHP"
sudo apt-get install php5-common php5-dev php5-cli php5-fpm -y > /dev/null

#echo "Installing PHP extensions"
sudo apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql php5-xdebug php5-memcached php5-memcache php5-sqlite php5-json php5-xmlrpc php5-geoip -y > /dev/null

echo "Creating xdebug log directory: /var/log/xdebug"
sudo mkdir /var/log/xdebug > /dev/null
echo "Changing xdebug log directory owner to www-data"
sudo chown www-data:www-data /var/log/xdebug > /dev/null

echo "Installing xdebug"
sudo pecl install xdebug > /dev/null
echo "Configuring xdebug"
sudo cp /var/www/html/config/php.ini /etc/php5/apache2/php.ini > /dev/null
sudo service apache2 restart > /dev/null
echo "Xdebug installation completeted"


# MySQL
echo "Preparing MySQL"
sudo apt-get install debconf-utils -y > /dev/null
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "Installing MySQL"
sudo apt-get install mysql-server-5.5 -y phpmyadmin > /dev/null 2>&1
sudo apt-get install mysql-server -y -f > /dev/null
sudo apt-get install -y mysql-client > /dev/null

# Apache Configuration
echo "Configuring Apache"
sudo php5enmod mcrypt
sudo sed -ie "s/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/" /etc/apache2/mods-enabled/dir.conf
cp /var/www/html/config/servername.conf /etc/apache2/conf-available/servername.conf > /dev/null
sudo a2enconf servername > /dev/null
cp /var/www/html/config/dir.conf /etc/apache2/mods-enabled/dir.conf > /dev/null
sudo service apache2 restart > /dev/null
sudo php5enmod mcrypt > /dev/null

#echo "Installing phpMyAdmin"
echo "Installing phpMyAdmin"
sudo apt-get install phpmyadmin -y > /dev/null
sudo /usr/sbin/pma-configure > /dev/null
sudo php5enmod mcrypt > /dev/null
#sudo ln -s /usr/share/phpmyadmin /var/www/phpmyadmin > /dev/null
#sudo apt-get update > /dev/null
#sudo htpasswd /etc/phpmyadmin/htpasswd.setup root > /dev/null
sudo service apache2 restart > /dev/null

# Install Git
echo "Installing Git"
sudo apt-get install git -y > /dev/null

# Installing Composer
echo "Installing Composer"
sudo curl -sS https://getcomposer.org/installer | php > /dev/null
sudo mv composer.phar /usr/local/bin/composer > /dev/null

# Installing Node
echo "Installing Node"
sudo curl -sL https://deb.nodesource.com/setup | sudo bash - > /dev/null
sudo sudo apt-get install -y nodejs > /dev/null
sudo -H npm install npm -g

echo "Installing last version of lodash"
sudo npm install lodash -g > /dev/null

echo "Installing Grunt"
sudo npm install grunt -g > /dev/null
sudo npm install grunt-cli -g > /dev/null

echo "Installing Bower"
sudo npm install bower -g > /dev/null

echo "Installing Gulp"
sudo npm install gulp -g > /dev/null


echo "Finished provisioning."