#!/bin/bash
#
# basic ubuntu15
#

set -e
set -x

# Forces output to be sent to syslog
# Taken from https://alestic.com/2010/12/ec2-user-data-output/,
# last access, Feb 7, 2022
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "BEGIN USER DATA"

# Skip prompts
export DEBIAN_FRONTEND=noninteractive

# Set timezone
sudo timedatectl set-timezone America/New_York

# fix color of directory, which in PuTTy ends up as dark blue on 
# black background
bashrc_append=$(cat <<'EOT'
d=.dircolors
test -r $d && eval "$(dircolors $d)"
EOT
)

echo "$bashrc_append" >> /home/ubuntu/.bashrc
dircolors -p > /home/ubuntu/.dircolors
sed -i -e 's/DIR 01;.*/DIR 01;36 # directory/' /home/ubuntu/.dircolors
sudo chown ubuntu:ubuntu /home/ubuntu/.dircolors

# Upgrade
sudo apt-get update
sudo apt-get upgrade -y

echo "END USER DATA"
