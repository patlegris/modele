# Please, Do not use this repositories for production
Actually DO NOT USE "master" branch, you could see the working advance on "Dev. Modele" Branch.
Thank you.

## What is "modele"
"modele" is based on Vagrant/Linux_Ubuntu_Server_ 64 v14+/Apache2/PHPV v5.6+/MySQL /PHPMyAdmin/ElasticSearch For Wordpress/WP-CLI/Git v1.9.1+/Node v0.10.38... and a lot of others nice things for local development on Windows 8.1.

This local development will be construct to install environment system and network, database, dependencies, repositories, wordpress and front/back modules depends of your choices (bootstrap, Sass, gulp...) and finally offer to deploy with a maximum of facilities and great compatibilities with the actuals standards of web LAMP X64 machines.

### LAMP for Wordpress (first)
This project is to create a production Web Development environment Vagrant Based and Linux 64 server with dependencies and web provisions, ready for development of Profesional WebSites with Wordpress CMS (in first time, Laravel and/or Symfony_v2/3 later if i've got any time to do it...).

# Overview
This vagrant use [ubuntu/trusty64](https://atlas.hashicorp.com/ubuntu/boxes/trusty64) from [Atlas Vagrant Box](https://atlas.hashicorp.com/boxes/search?utm_source=vagrantcloud.com&vagrantcloud=1).
  On your 'vagrant up' command, this vagrantfile will automatically download the box. Vagrant folder here contain a `bootstrap.sh` file which provision the vagrant box.

  You need to place your projects in `projects` directory. This directory is synced with `/var/www/html` directory in the virtual machine.
  This project folder also contain a `config` folder which is used during the provisioning.

This vagrant box is configured to use '2048mb' of RAM and 1 Cpu. You can change ths configuration from Vagrantfile.

## Included packages

- Ubuntu Trusty64 (64-Bit)
- Apache 2
- PHP _v5.6.7_ with mysql, mcrypt, memcached, memcache, sqlite, xmlrpc, geoip gd, xdebug, php5-fpm, php5-common
- MySQL _v5.5.41_
- Git _v1.9.1_
- Node _v0.10.38_
- Composer _v1.0.0-alpha9_
- NPM _v1.4.28_
- Bower _v1.3.12_
- PHPMyAdmin
- Javascript component
- ElasticSearch
- WP-Cli

### Included Dependencies
The following dependencies are installed using apt-get as they are required to install and build other modules:

- cURL
- python-software-properties
- build-essential
- libev-dev

============================================================================

# Installation

### Requirements
This installation is only tested on Windows 8.1 64
* You must have [Vagrant](http://vagrantup.com) and [VirtualBox](https://www.virtualbox.org) installed in your pc.
* So the vagrant script install use the Trusty64 v20160206.0.0 repo of ubuntu 14  64 server that could find at : https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20160206.0.0

### Install via Git
To use Modele vagrant, clone this github repo

    $ git clone https://github.com/patlegris/modele
to your mac/pc/linux.  When clone is complete, go to the `modele` and now you are ready to use your Virtual Machine.

### Use
Start the VM

    $ cd /modele
    $ vagrant up
    $ vagrant provision

If your vagrant is UP (look at your virtualbox), you could now etablish a direct connect FROM YOUR CLI to your server. Thanks Vagrant !

    $ vagrant ssh

First time of your 'vagrant up' will provision the vagrant. You can see the status of your VM from [http://192.168.33.10](http://192.168.33.10).
You can check the `phpinfo` from  [http://192.168.33.10/phpinfo.php](http://192.168.33.10/phpinfo.php)

So, you could try to use and give a password to phpMyAdmin from [http://192.168.33.10:phpmyadmin](http://192.168.33.10:phpmyadmin)

# Default Credentials
These are credentials setup by default.

##Host Address:
- Hose: 192.168.33.10 (Change in Vagrantfile if you like)

## SSH
- Username: vagrant
- Password: vagrant
- Port: 22

## MySQL (or Maria_DB) Credentials
- Username: root
- Password: root
- Host: localhost
- Port: 3306

## ElasticSearch
- Port: 9200

#Thanks to :
###github.com/arifulhb/devspace
DevSpace Vagrant is a Ubuntu Trusty64__ vagrant configuration for LAMP stack developers which also includes many related modern development tools.
The original version of devspace is only tested on Mac, this one is modified to run on Windows 8.1 environment.

###github.com/digitalocean/do_user_scripts
Install script for phpMyAdmin an some others little things...
[https://github.com/digitalocean/do_user_scripts/tree/master/Ubuntu-14.04/web-servers] (https://github.com/digitalocean/do_user_scripts/tree/master/Ubuntu-14.04/web-servers)

###https://gist.github.com/rrosiek/8190550
Vagrant provision script for php, Apache, MySQL, [phpMyAdmin], Laravel, and javascript helpers. Outputs nearly everything to /dev/null since "quiet" on most commands is still noisy.

#Feedback
This project is an experiment, and it won't be successful without your feedback.
Let us know what you think by [opening an issue here on GitHub](https://github.com/patlegris/modele/issues).

#Disclaimer
Nobody, and not me, could be responsable in accuracy of using this repositories in case of troubleshouting, lost datas, lost softwares, lost money, lost brain or/and in any others case.
This deployement is for PERSONNAL TESTS ONLY.

C'est dit !
Salutations.