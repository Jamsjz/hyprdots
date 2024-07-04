#!/bin/bash

# Installs the dotfiles
# Author: Bhashkar Paudyal
# License: MIT
# Date: 2020-08-01
# Version: 0.0.1
# Requirements: Inside of req.txt
#
# This script is meant to be run from pwd -> /home/$USER/dots
#
# This script will install the packages in the file req.txt.
# If user wants to install a package, he/she can add it to userpackages.txt
# After installing the packages, the script will install the dotfiles using stow.

# Function to install a package from pacman if the package is not installed; if not found, install from yay
function install_package {
	if pacman -Q "$1" &>/dev/null; then
		echo "Package $1 is already installed :)"
		return
	fi
	if pacman -Qs "$1" &>/dev/null; then # if pacman has the package
		sudo pacman -S --noconfirm "$1"
	else
		yay --answerclean None --answerdiff None --removemake -S "$1"
	fi
}

function install_packages_from_file {
	if [ -f "$1" ]; then
		while read -r line; do
			if [ -z "$line" ]; then
				continue
			fi
			echo "Installing $line"
			install_package "$line"
		done <"$1"
	fi
}

# Ask the user if they want to install the packages
function ask_user {
	read -p "Do you want to install the packages? [Y/n] " -r choice
	case "$choice" in
	y | Y | yes | Yes | YES) install_packages_from_file "$1" ;;
	n | N | no | No | NO) echo "Okay, no packages will be installed" ;;
	*) install_packages_from_file "$1" ;;
	esac
}

# Verify the script is run from the correct directory
if [ "$(pwd)" != "$HOME/dots" ]; then
	echo "Script not run from /home/$USER/dots"
	echo "Current working directory: $(pwd)"
	exit 1
fi

# Ensure the package list file exists
if [ ! -f "req.txt" ]; then
	echo "req.txt not found!"
	exit 1
fi

# Ask the user if they want to install the packages
ask_user "req.txt"

# Install the dotfiles using stow
# Stow is a tool to manage dotfiles
echo "Stowing the dotfiles..."
stow */
