#!/bin/bash

set -euo pipefail # Bash options to stop script on error (See set manpage).
shopt -s extglob # Korn shell globbing.

house='/home/estudiante' # User home.

clean(){
	bleachbit --clean firefox.* google_chrome.* \
		libreoffice.* system.cache system.clipboard \
		system.recent_documents system.tmp system.trash \
		&>/dev/null
	cd $house && rm -rf !(Clases|.config|.local) &>/dev/null
	xdg-user-dirs-update &>/dev/null ; xdg-user-dirs-update --force  &>/dev/null
	[ -d $house/Clases ] || mkdir -p $house/Clases && tar -C $house/Clases -xf $house/.config/clases.tar.gz &>/dev/null
	[ -z "(ls $house/Clases)" ] && [ -f $house/.config/clases.tar.gz ] && \
		tar -C $house/Clases -xf $house/.config/clases.tar.gz &>/dev/null
	[ -f $house/Clases/.wall.png ] || wget -O $house/Clases/.wall.png "https://github.com/developerelianaav/scripts/blob/main/wall.png?raw=true" &>/dev/null
	gsettings set org.gnome.desktop.background picture-uri file:///$house/Clases/.wall.png
	[ -d $house/Clases ] && [ ! -z "(ls -A $house/Clases)" ] && tar -C $house/Clases -czf $house/.config/clases.tar.gz ./
}


install-prerequisites(){
	cp $0 /usr/local/bin/umfs.sh # Copy this script.
	chmod 755 /usr/local/bin/umfs.sh # The Script can't be read by the User, and can't be modified inside the system.
	echo "/usr/local/bin/umfs.sh -c" >> $house/.profile # Add script to login.
	sudo chown -R estudiante $house/.profile ; sudo chattr +i $house/.profile
	sudo chown -R estudiante $house/.bashrc ; sudo chattr +i $house/.bashrc
	[ -d $house/Clases ] || mkdir -p $house/Clases ; sudo chown -R estudiante $house/Clases
	[ -d $house/Clases ] || wget -O $house/Clases/.wall.png "https://github.com/developerelianaav/scripts/blob/main/wall.png?raw=true"
	sudo apt install -y bleachbit xdg-user-dirs \
		cron libreoffice build-essential jq 
	echo -e "\033[0;32mDone\033[0m"
}


protect(){
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(estudiante\|,estudiante\|estudiante,\)//g}' /etc/group /etc/gshadow
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' /etc/pam.d/su
	echo -e "\033[0;32mDone\033[0m"	
}

shelp() {
	echo "umfs - UNLA's Multi Function Script"
	echo "-c"
	echo "    Cleans the User (Student) directory"
	echo "    Requires bleachbit to be installed."
	echo "-i"
	echo "    Install needed programs for this script"
	echo "    to function properly."
	echo "-h"
	echo "    Prints this help message."
	echo "-v"
	echo "    Prints the version of this script"
}

update() {
	echo "Checking for updates"
}

version() {
	echo "umfs - UNLA's Multi Function Script"
	echo "    Version 0.6"
	echo "    Brougth to you by"
	echo "    Unpayed Undergrads at UNLA"
	echo "    License"
	echo "    GPL-3.0-only or GPL-3.0-or-later"
}

while getopts "cihpv" option; do
	case $option in
		c)
			clean # This option is meant to be used as a cronjob, Group 1 function.
			;;
		i)
			install-prerequisites # One time only, Group 1 function.
			;;
		h)
			shelp
			;;
		p)
			protect # One time only. Group 2 function.
			;;
		v)
			version
			;;
		*)
			echo "Wrong/Non-existent option"
			shelp
	esac
done
