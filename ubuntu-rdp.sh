#!/bin/bash
#
# ubuntu14-rdp
#
#set this to the username of the rdp user you wish
rdpuser="rdpuser"

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

# Create the remote desktop user
sudo adduser $rdpuser --disabled-login --gecos ""
sudo usermod -aG sudo $rdpuser

motdcontents=$(cat <<EOT
#!/bin/bash

echo ""
echo "Set the password of $rdpuser using sudo passwd $rdpuser"
echo "To fix Tab-completion in XFCE go to Applications->Settings->Window Manager"
echo "   Go to Keyboard tab"
echo "   Clear option for Switch window for same application"
echo "Delete this reminder using sudo rm /etc/update-motd.d/80-xfce-remind"
EOT
)
echo "$motdcontents" | sudo tee /etc/update-motd.d/80-xfce-remind
sudo chmod a+x /etc/update-motd.d/80-xfce-remind

# Upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Install packages.
sudo apt-get install -y xrdp xfce4 xfce4-terminal

# set X to use xfce
echo "xfce4-session" | sudo tee /home/$rdpuser/.xsession
sudo chown $rdpuser:$rdpuser /home/$rdpuser/.xsession

sudo service xrdp restart
