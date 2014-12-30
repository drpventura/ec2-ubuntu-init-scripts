#!/bin/bash
#
# install-lamp-server
#

set -e
set -x

# Skip prompt for the MySQL root password
export DEBIAN_FRONTEND=noninteractive

# Set timezone
sudo timedatectl set-timezone America/New_York

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

