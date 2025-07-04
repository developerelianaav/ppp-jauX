#!/bin/bash

set -euo pipefail
shopt -s extglob

est='/home/estudiante'
wall="https://github.com/developerelianaav/ppp-jauX/blob/main/archivos/wall.png?raw=true"
pol="https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/archivos/10-estudiante-policy.pkla"

clean(){
	bleachbit --clean firefox.* google_chrome.* \
		libreoffice.* system.cache system.clipboard \
		system.recent_documents system.tmp system.trash \
		&>/dev/null
	cd ${est} && rm -rf !(Clases|.config|.local) &>/dev/null
	xdg-user-dirs-update &>/dev/null ; xdg-user-dirs-update --force  &>/dev/null
	[ -d ${est}/Clases ] || mkdir -p ${est}/Clases &>/dev/null
	[ -f ${est}/Clases/.wall.png ] || wget -O ${est}/Clases/.wall.png "${wall}" &>/dev/null
	gsettings set org.gnome.desktop.background picture-uri file:///${est}/Clases/.wall.png
}

installp(){
	[ -f /usr/local/bin/umfs.sh ] && rm -rf /usr/local/bin/umfs.sh
	chmod 755 "${0}" ; cp "${0}" /usr/local/bin/umfs.sh
	chattr -i $est/.profile $est/.bashrc
	sed -i -e 's/\/usr\/local\/bin\/umfs.sh -c//g' $est/.profile
	echo "/usr/local/bin/umfs.sh -c" >> ${est}/.profile
	chown -R estudiante ${est}/.profile ${est}/.bashrc
	chattr +i ${est}/.profile ${est}/.bashrc
	[ -d ${est}/Clases ] || mkdir -p ${est}/Clases ; chown -R estudiante ${est}/Clases
	[ -f ${est}/Clases/.wall.png ] || wget -O ${est}/Clases/.wall.png "${wall}" &>/dev/null 
	apt update && apt upgrade -y
	apt install -y bleachbit xdg-user-dirs \
		cron libreoffice build-essential jq neovim-qt \
		vim-gtk3 xterm git nodejs npm swi-prolog \
		mysql-server dia mongodb curl emacs
	echo -e "\033[0;32mDone\033[0m"
}

protect(){
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(estudiante\|,estudiante\|estudiante,\)//g}' /etc/group /etc/gshadow
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' /etc/pam.d/su
	wget -O /etc/polkit-1/localauthority/50-local.d/10-estudiante-policy.pkla "${pol}" &>/dev/null
	sudo systemctl restart polkit.service
	echo -e "\033[0;32mDone\033[0m"	
}

shelp() {
	echo "umfs - UNLa's Multi Function Script"
	echo "-c"
	echo "    Reinicia el directorio del usuario"
	echo "-i"
	echo "    Instala/Actualiza el programa y"
	echo "    sus requerimientos"
	echo "-p"
	echo "    Restringe al usuario común"
	echo "-h"
	echo "    Muestra este mensaje"
	echo "-v"
	echo "    Muestra la versión de este script"
}

version() {
	echo "umfs - UNLa's multi function script"
	echo "    Versión 1.1.3.4"
	echo "    Creado por"
	echo "    Estudiantes de la UNLA" 
}

while getopts "ciphv" option; do
	case $option in
		c)
			clean
			;;
		i)
			installp
			;;
		p)
			protect
			;;
		h)
			shelp
			;;
		v)
			version
			;;
		*)
			echo "Opción errónea"
			shelp	
	esac
done
