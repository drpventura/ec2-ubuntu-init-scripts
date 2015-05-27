#!/bin/bash
#
# basic ubuntu15
#

set -e
set -x

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
