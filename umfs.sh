#!/bin/bash

set -euo pipefail # Bash options to stop script on error (See set manpage).
shopt -s extglob # Korn shell globbing.

casa='/home/visita8Jau' # User home.

clean(){
	echo "Phase One - Bleachbit"
	notify-send "Phase One" "Bleachbit"
	bleachbit --clean brave.* chromium.* \
		firefox.* google_chrome.* java.* \
		libreoffice.* opera.* palemoon.* \
		seamonkey.* system.cache system.clipboard \
		system.recent_documents system.tmp system.trash \
		vlc.* zoom.*
	echo "Phase Two - rm"
	notify-send "Phase Two" "rm"
	rm -rf !($casa/.*)
	echo "Phase Three - Recreate common User directories"
	notify-send "Phase Three" "Recreate common User directories"
	xdg-user-dirs-update
	echo "Completed"
	notify-send "Completed" "Cleaning routine has ended"
}


install-prerequisites(){
	cp $0 /usr/local/bin/umfs.sh # Copy this script.
	chmod 755 /usr/local/bin/umfs.sh # The Script can't be read by the User, and can't be modified inside the system.
	apt install -y bleachbit xdg-user-dir libreoffice # Put other Group one programs here.
	echo "@reboot        visita8Jau /usr/local/bin/umfs.sh -c" >> /etc/crontab # Add script to crontab.
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

}

version() {
	echo "umfs - UNLA's Multi Function Script"
	echo "    Version 0.3"
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
