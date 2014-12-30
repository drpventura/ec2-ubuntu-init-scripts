#!/bin/bash
#
# MEAN server (ubuntu 14)
#

set -e
set -x

# Skip prompts
export DEBIAN_FRONTEND=noninteractive

# Set timezone
sudo timedatectl set-timezone America/New_York

# Add mongo repo and keys
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

# Update packages
sudo apt-get update

# Install node, npm, and mondo
sudo apt-get install -y npm mongodb-org
# Install n and express
sudo npm install -g n express
# Install latest stable version of node
sudo n stable

# Start mongo
sudo service mongod start

# Upgrade
sudo apt-get upgrade -y


