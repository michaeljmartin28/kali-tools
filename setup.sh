#!/bin/bash

if [ "$EUID" -ne 0 ]
then
	echo "Please run as root."
	echo "sudo bash $0"
	exit
fi

# Set up home directory
echo -e "Setting up home user configuration files for vim, tmux, and zsh. Changes will be reflected in a new terminal."

echo -e "User: $SUDO_USER\n"

cp home/.* /home/$SUDO_USER/
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.*

cp history/.zsh_history /home/$SUDO_USER/.zsh_history


# Installing programs
apt-get update && \

# install flameshot for screenshots
apt-get install -y flameshot

# Install VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
install -y -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings && \
sh -c 'echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
rm -f packages.microsoft.gpg && \
apt install -y apt-transport-https && \
apt update && \
apt install -y code

# Install rlwrap
apt install -y rlwrap 

# Install GoBuster
apt install -y gobuster

# Install Seclists
apt install -y seclists



# Creating wordlists directory
mkdir /home/$SUDO_USER/wordlists
gzip -k -d /usr/share/wordlists/rockyou.txt.gz && \
mv /usr/share/wordlists/rockyou.txt /home/$SUDO_USER/wordlists

# Pull down useful git repos

if [ ! -d "/opt/nishang" ] 
then
    git clone https://github.com/samratashok/nishang.git /opt/nishang
fi
