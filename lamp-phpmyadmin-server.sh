#!/bin/bash
#
# install-lamp-server ubuntu15
#

set -e
set -x

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

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

sudo debconf-set-selections <<EOF
 phpmyadmin      phpmyadmin/setup-password       password
 phpmyadmin      phpmyadmin/password-confirm     password
 phpmyadmin      phpmyadmin/app-password-confirm password
 phpmyadmin      phpmyadmin/mysql/app-pass       password
 phpmyadmin      phpmyadmin/mysql/admin-pass     password
 phpmyadmin	phpmyadmin/dbconfig-install	boolean	true
 phpmyadmin	phpmyadmin/reconfigure-webserver	multiselect	apache2
EOF

# Install packages.
tasksel install lamp-server

sudo apt-get -q -y install phpmyadmin libgd-tools javascript-common libmcrypt-dev mcrypt php5-imagick

sudo chown -R ubuntu:ubuntu /var/www

