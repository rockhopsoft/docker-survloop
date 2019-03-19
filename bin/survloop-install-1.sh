#!/bin/bash
set -x

echo Running SurvLoop Intaller!.. Act 1

# Create swap file, important for servers with little memory
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Create non-root user
adduser $1
usermod -aG sudo $1
ufw allow OpenSSH
ufw enable
rsync --archive --chown=$1:$1 ~/.ssh /home/$1
#chmod +x $1:$1 /usr/local/lib/docker-survloop/bin/*.sh

#cp /usr/local/lib/docker-survloop/etc/apt/sources.list /home/mo/survloop/
