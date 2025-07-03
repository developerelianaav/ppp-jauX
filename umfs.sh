#!/bin/bash

set -euo pipefail # Opción de Bash - Para el script apenas hay un error.
shopt -s extglob # Englobamiento extendido de Ksh

house='/home/estudiante' # El directorio base del usuario común.

clean(){
	# Se limpia con bleachbit los directorios/espacios comunes con archivos basura
	bleachbit --clean firefox.* google_chrome.* \
		libreoffice.* system.cache system.clipboard \
		system.recent_documents system.tmp system.trash \
		&>/dev/null
	# Se elimina con rm todo excepto las tres carpetas
	cd ${house} && rm -rf !(Clases|.config|.local) &>/dev/null
	# Se recrean los directorios básicos del usuario
	xdg-user-dirs-update &>/dev/null ; xdg-user-dirs-update --force  &>/dev/null
	# Se verifíca si el usuario eliminó el directorio Clases,
	# En dado caso que si, se recrea.
	[ -d ${house}/Clases ] || mkdir -p ${house}/Clases &>/dev/null
	# Se verifica si existe el fondo de escritorio, en dado caso que no,
	# Se descarga y se pone en la carpeta Clases.
	[ -f ${house}/Clases/.wall.png ] || wget -O ${house}/Clases/.wall.png "https://github.com/developerelianaav/scripts/blob/main/wall.png?raw=true" &>/dev/null
	# Se establece el fondo de escritorio.
	gsettings set org.gnome.desktop.background picture-uri file:///${house}/Clases/.wall.png
}


install-prerequisites(){
	# Copia el script, basicamente lo instala.
	cp "${0}" /usr/local/bin/umfs.sh
	# Cambia los permisos del script.
	chmod 755 /usr/local/bin/umfs.sh
	# Añade la siguiente línea a .profile, haciendo que la rutina de limpieza se ejecute al iniciar sesión.
	echo "/usr/local/bin/umfs.sh -c" >> ${house}/.profile
	# Se vuelve inmutable .profile y .bashrc
	sudo chown -R estudiante ${house}/.profile ; sudo chattr +i ${house}/.profile
	sudo chown -R estudiante ${house}/.bashrc ; sudo chattr +i ${house}/.bashrc
	# Se crea la carpeta Clases.
	[ -d ${house}/Clases ] || mkdir -p ${house}/Clases ; sudo chown -R estudiante ${house}/Clases
	# Se descarga el fondo de pantalla.
	[ -d ${house}/Clases ] || wget -O ${house}/Clases/.wall.png "https://github.com/developerelianaav/scripts/blob/main/wall.png?raw=true"
	# Se actualizan los programas
	sudo apt update && sudo apt upgrade -y
	# Se instalan los programas (incompleto por ahora).
	sudo apt install -y bleachbit xdg-user-dirs \
		cron libreoffice build-essential jq neovim \
		vim xterm git nodejs npm swi-prolog \
		mysql-server dia mongodb curl
	echo -e "\033[0;32mDone\033[0m"
}

update(){
	# Vuelve ejecutable este script
	sudo chmod +x "${0}"
	# Elimina la versión anterior
	sudo rm -rf /usr/local/bin/umfs.sh
	# Vuelve estos archivos mutables
	sudo chattr -i $house/.profile $house/.bashrc
	# Elimina esta línea para evitar que se repita.
	sudo sed -i -e 's/\/usr\/local\/bin\/umfs.sh -c//g' $house/.profile
	# Vuelve a instalar
	install-prerequisites
}

protect(){
	# Se elimina al estudiante de los grupos peligrosos.
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(estudiante\|,estudiante\|estudiante,\)//g}' /etc/group /etc/gshadow
	# Se le prohibe al usuario utilizar su.
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' /etc/pam.d/su
	# Se le prohibe al usuario utilizar polkit, excepto para usb.
	sudo echo 'polkit.addRule(function(action, subject) { if (subject.user("estudiante")) { if (action.id == "org.freedesktop.udisks2.filesystem-mount" || action.id == "org.freedesktop.udisks.filesystem-mount" || action.id == "org.gnome.settings-daemon.plugins.power.mount-removable-media") { return polkit.Result.YES; } return polkit.Result.NO; } });' | sudo tee /etc/polkit-1/rules.d/90-strict-estudiante-rules.rules &> /dev/null
	sudo systemctl restart polkit.service
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

version() {
	echo "umfs - UNLA's Multi Function Script"
	echo "    Version 0.9"
	echo "    Brougth to you by"
	echo "    Undergrads at UNLA"
}

while getopts "ciuhpv" option; do
	case $option in
		c)
			clean # Grupo 2
			;;
		i)
			install-prerequisites # Grupo 1
			;;
		u)
			update
			;;
		h)
			shelp
			;;
		p)
			protect # Grupo 2
			;;
		v)
			version
			;;
		*)
			echo "Wrong/Non-existent option"
			shelp
	esac
done
