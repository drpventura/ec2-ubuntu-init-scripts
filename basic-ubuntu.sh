#!/bin/bash
#
# basic ubuntu14
#

set -e
set -x

# Skip prompts
export DEBIAN_FRONTEND=noninteractive

# Set timezone
sudo timedatectl set-timezone America/New_York

# Upgrade
sudo apt-get update
sudo apt-get upgrade -y
