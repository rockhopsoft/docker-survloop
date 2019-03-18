#!/bin/bash
echo Running SurvLoop Intaller!

ubuntuVersion=bionic
dockerComposeVersion=1.23.2

sudo apt update
sudo apt-get upgrade

git clone https://github.com/laravel/laravel.git ~/survloop
cd ~/survloop
cp -rf /tmp/docker-survloop/{Dockerfile,docker-compose.yml,php,nginx} ./

# Installing Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $ubuntuVersion stable"
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker ${USER}
su - ${USER}
sudo curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker run --rm -v $(pwd):/app composer install
sudo chown -R $USER:$USER ~/survloop
cd ~/survloop
cp .env.example .env
mkdir /var/www/app/Models

