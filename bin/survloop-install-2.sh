#!/bin/bash
set -x

echo Running SurvLoop Intaller!.. Act 2

codename=bionic
dockerComposeVersion=1.23.2

sudo apt update
sudo apt-get upgrade

git clone https://github.com/laravel/laravel.git ~/survloop
cd ~/survloop
cp -rf /usr/local/lib/docker-survloop/{Dockerfile,docker-compose.yml,.env,php,nginx} ./

sudo chown -R $USER:$USER ~/survloop
cp /usr/local/lib/docker-survloop/.env ~/survloop/.env
sudo mkdir ~/survloop/app/Models
sudo chmod -R gu+w www-data:33 ~/survloop/app/Models
sudo chmod -R gu+w www-data:33 ~/survloop/app/User.php
sudo chmod -R gu+w www-data:33 ~/survloop/database
sudo chmod -R gu+w www-data:33 ~/survloop/storage/app

# Installing Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $codename stable"
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
sudo curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Login again to apply docker group permissions
su - ${USER}
