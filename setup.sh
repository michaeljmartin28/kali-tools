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

cp ./home/* /home/$SUDO_USER/


# Pull down useful git repos

git clone https://github.com/samratashok/nishang.git /opt/nishang
