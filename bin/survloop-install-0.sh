#!/bin/bash
echo Running SurvLoop Intaller Root!

# Expand available package channels
sed 's+deb http://security.ubuntu.com/ubuntu bionic main restricted+deb http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe+g' /etc/apt/sources.list > /etc/apt/sources.list
sed 's+deb http://security.ubuntu.com/ubuntu bionic-security main restricted+deb http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe+g' /etc/apt/sources.list > /etc/apt/sources.list
sed 's+deb http://security.ubuntu.com/ubuntu bionic-updates main restricted+deb http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe+g' /etc/apt/sources.list > /etc/apt/sources.list

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
