#!/bin/bash

set -euo pipefail # Bash options to stop script on error (See set manpage).
shopt -s extglob # Korn shell globbing.

casa='/home/estudiante' # User home.

clean(){
	notify-send "Phase One" "Bleachbit"
	bleachbit --clean firefox.* google_chrome.* \
		libreoffice.* system.cache system.clipboard \
		system.recent_documents system.tmp system.trash
	notify-send "Phase Two" "rm"
	mv $casa/Clases $casa/.Clases
	rm -rf !($casa/.*)
	notify-send "Phase Three" "Recreate common User directories"
	xdg-user-dirs-update
	xdg-user-dirs-update --force 
	mv $casa/.Clases $casa/Clases
	notify-send "Completed" "Cleaning routine has ended"
}


install-prerequisites(){
	cp $0 /usr/local/bin/umfs.sh # Copy this script.
	chmod 755 /usr/local/bin/umfs.sh # The Script can't be read by the User, and can't be modified inside the system.
	sudo apt install -y bleachbit xdg-user-dirs \
		cron libreoffice build-essential # Put other Group one programs here.
	echo "/usr/local/bin/umfs.sh -c" >> $casa/.profile # Add script to login.
	sudo chattr +i $casa/.profile # Make file undeletable for the normal user.
	mkdir $casa/Clases # Basic User folder
	# curl "https://example.com/wall.jpg" -o $casa/Clases/.wall.jpg # Forgot to copy the wallpaper
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

protect(){
	echo "Phase One - Harmful group removal"
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(visita8Jau\|,visita8Jau\|visita8Jau,\)//g}' /etc/group /etc/gshadow
	echo "Phase Two - Su blocking"
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' /etc/pam.d/su
}

version() {
	echo "umfs - UNLA's Multi Function Script"
	echo "    Version 0.4"
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
