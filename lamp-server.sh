#!/bin/bash
#
# install-lamp-server ubuntu15
#

set -e
set -x

# Skip prompt for the MySQL root password
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

# Sets up MOTD
motdcontents=$(cat <<'EOT'
#!/bin/bash

# check to see if mysql is installed
if [ -e /usr/bin/mysql ]; then
   # check to see if root password is set
	/usr/bin/mysql --no-beep -u root -e "quit" 2>/dev/null
   if [ $? -eq "0" ]; then
	   echo ""
      echo "MySQL root password NOT set, change it with mysqladmin -u root password"
   fi
else
   echo ""
   echo "MySQL not finished installing, once it is remember to change root password with mysqladmin -u root password"
fi
EOT
)

sudo echo "$motdcontents" >/etc/update-motd.d/80-mysql-remind
sudo chmod a+x /etc/update-motd.d/80-mysql-remind

# Upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Install packages.
tasksel install lamp-server

sudo chown -R ubuntu:ubuntu /var/www

