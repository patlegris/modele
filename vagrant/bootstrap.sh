#!/bin/bash

# Variables
APPENV=local
DBHOST=localhost
DBNAME=test
DBUSER=root
DBPASSWD=root

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
echo -e "\n--- Install base packages ---\n"
apt-get -y install vim curl build-essential python-software-properties git > /dev/null 2>&1

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


## MySQL
#echo "Preparing MySQL"
#sudo apt-get install debconf-utils -y > /dev/null
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
#
#echo "Installing MySQL"
#sudo apt-get install mysql-server-5.5 -y phpmyadmin > /dev/null 2>&1
#sudo apt-get install mysql-server -y -f > /dev/null
#sudo apt-get install -y mysql-client > /dev/null

## MySQL
echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Install MySQL specific packages and settings ---\n"
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mysql-server-5.5 phpmyadmin > /dev/null 2>&1

## MySQL Settings
echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

# Apache Configuration
echo "Configuring Apache"
sudo php5enmod mcrypt
sudo sed -ie "s/index.html index.cgi index.pl index.php/index.php index.html index.cgi index.pl/" /etc/apache2/mods-enabled/dir.conf
cp /var/www/html/config/servername.conf /etc/apache2/conf-available/servername.conf > /dev/null
sudo a2enconf servername > /dev/null
cp /var/www/html/config/dir.conf /etc/apache2/mods-enabled/dir.conf > /dev/null
sudo service apache2 restart > /dev/null
sudo php5enmod mcrypt > /dev/null

echo -e "\n--- Enabling mod-rewrite ---\n"
a2enmod rewrite > /dev/null 2>&1

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- Setting document root to public directory ---\n"
rm -rf /var/www
ln -fs /vagrant/public /var/www

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo -e "\n--- Turn off disabled pcntl functions so we can use Boris ---\n"
sed -i "s/disable_functions = .*//" /etc/php5/cli/php.ini

echo -e "\n--- Configure Apache to use phpmyadmin ---\n"
echo -e "\n\nListen 81\n" >> /etc/apache2/ports.conf
cat > /etc/apache2/conf-available/phpmyadmin.conf << "EOF"
<VirtualHost *:81>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/share/phpmyadmin
    DirectoryIndex index.php
    ErrorLog ${APACHE_LOG_DIR}/phpmyadmin-error.log
    CustomLog ${APACHE_LOG_DIR}/phpmyadmin-access.log combined
</VirtualHost>
EOF
a2enconf phpmyadmin > /dev/null 2>&1

echo -e "\n--- Add environment variables to Apache ---\n"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    SetEnv APP_ENV $APPENV
    SetEnv DB_HOST $DBHOST
    SetEnv DB_NAME $DBNAME
    SetEnv DB_USER $DBUSER
    SetEnv DB_PASS $DBPASSWD
</VirtualHost>
EOF

echo -e "\n--- Restarting Apache ---\n"
service apache2 restart > /dev/null 2>&1

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

echo -e "\n--- Installing javascript components ---\n"
npm install -g gulp bower > /dev/null 2>&1

#echo "Installing last version of lodash"
#sudo npm install lodash -g > /dev/null

echo "Installing Grunt"
sudo npm install grunt -g > /dev/null
sudo npm install grunt-cli -g > /dev/null

#echo "Installing Bower"
#sudo npm install bower -g > /dev/null
#
#echo "Installing Gulp"
#sudo npm install gulp -g > /dev/null

echo -e "\n--- Updating project components and pulling latest versions ---\n"
cd /vagrant
sudo -u vagrant -H sh -c "composer install" > /dev/null 2>&1
cd /vagrant/client
sudo -u vagrant -H sh -c "npm install" > /dev/null 2>&1
sudo -u vagrant -H sh -c "bower install -s" > /dev/null 2>&1
sudo -u vagrant -H sh -c "gulp" > /dev/null 2>&1

echo -e "\n--- Creating a symlink for future phpunit use ---\n"
ln -fs /vagrant/vendor/bin/phpunit /usr/local/bin/phpunit

echo -e "\n--- Add environment variables locally for artisan ---\n"
cat >> /home/vagrant/.bashrc <<EOF
# Set envvars
export APP_ENV=$APPENV
export DB_HOST=$DBHOST
export DB_NAME=$DBNAME
export DB_USER=$DBUSER
export DB_PASS=$DBPASSWD
EOF

echo "Finished provisioning."