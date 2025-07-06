#!/bin/bash

set -euo pipefail
shopt -s extglob

est='/home/estudiante'
wall="https://github.com/developerelianaav/ppp-jauX/blob/main/archivos/wall.png?raw=true"
pol="https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/archivos/60-estudiante.conf"
pkg="https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/archivos/pkg.list"
pse="http://prdownloads.sourceforge.net/pseint/pseint-l64-20250314.tgz?download"

basic-install(){
	printf -- "\033[0;33m ¡Comenzando instalación! \033[0m\n"
	chmod 755 "${0}" ; cp "${0}" /usr/local/bin/umfs.sh
	printf -- "/usr/local/bin/umfs.sh -c\n" >> ${est}/.profile
	chown -R estudiante ${est}/.profile ${est}/.bashrc
	chattr +i ${est}/.profile ${est}/.bashrc
	[ -d ${est}/Clases ] || mkdir -p ${est}/Clases
       	chown -R estudiante ${est}/Clases
	[ -f ${est}/Clases/.wall.png ] || \
		wget -O ${est}/Clases/.wall.png "${wall}" &>/dev/null
	printf -- "code code/add-microsoft-repo boolean true\n" | \
		sudo debconf-set-selections
	add-apt-repository ppa:maarten-fonville/android-studio
	add-apt-repository ppa:x-psoud/cbreleases
	apt-add-repository ppa:swi-prolog/stable
	apt update -q && apt upgrade -qy
	wget -O /tmp/pkg.list "${pkg}" &>/dev/null
	apt install -mqy $(awk '{print $1}' /tmp/pkg.list)
	wget -O /tmp/pseint.tgz "${pse}" ; tar -xvf /tmp/pseint.tgz
	mv /tmp/pseint /opt/ ; chmod +x /opt/pseint/pseint
	ln -s /opt/pseint/pseint /usr/local/bin/pseint
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

protect() {
	printf -- "\033[0;33m ¡Restringiendo al Estudiante! \033[0m\n"
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(estudiante\|,estudiante\|estudiante,\)//g}' \
	       	/etc/group /etc/gshadow
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' \
		/etc/pam.d/su
	wget -O /etc/polkit-1/localauthority.conf.d/60-estudiante.conf "${pol}" &>/dev/null
 	chmod 755 /etc/polkit-1/localauthority.conf.d/60-estudiante.conf
	systemctl restart polkit.service
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

remove(){
	printf -- "\033[0;33m ¡Limpiando para actualizar! \033[0m\n"
	[ -f /usr/local/bin/umfs.sh ] && rm -rf /usr/local/bin/umfs.sh
	[ -f /etc/polkit-1/localauthority/50-local.d/10-estudiante-policy.pkla ] && \
		rm /etc/polkit-1/localauthority/50-local.d/10-estudiante-policy.pkla
  	[ -f /etc/polkit-1/rules.d/90-strict-estudiante-policy.rules ] && \
		rm /etc/polkit-1/rules.d/90-strict-estudiante-policy.rules
	[ -f /etc/polkit-1/localauthority.conf.d/60-estudiante-conf ] && \
		rm /etc/polkit-1/localauthority.conf.d/60-estudiante-conf
	sed -i -e 's/auth       required   pam_wheel.so/# auth       required   pam_wheel.so/g' \
		/etc/pam.d/su
	chattr -i ${est}/.profile ${est}/.bashrc
	sed -i -e 's/\/usr\/local\/bin\/umfs.sh -c//g' ${est}/.profile
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

sweep() {
	printf -- "\033[0;33m ¡Eliminando archivos innecesarios! \033[0m\n"
	find /home/"${SUDO_USER}"/ -name "umfs.sh" -type f -delete
	find /tmp/ -name "pkg.list" -type f -delete
	find /tmp/ -name "pseint.tgz" -type f -delete
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

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

show-help() {
	printf -- "umfs - UNLa's Multi Function Script\n"
	printf -- "-c\n"
	printf -- "\tReinicia el directorio del usuario\n"
	printf -- "-i\n"
	printf -- "\tInstala el programa,\n"
	printf -- "\tsus requerimientos y restringe al\n"
	printf -- "\tusuario común\n"
	printf -- "-u\n"
	printf -- "\tActualiza el programa,\n"
	printf -- "\tsus requerimientos y restringe al\n"
	printf -- "\tusuario común\n"
	printf -- "-h\n"
	printf -- "\tMuestra este mensaje\n"
	printf -- "-v\n"
	printf -- "\tMuestra la versión de este script\n"
}

version() {
	printf -- "umfs - UNLa's multi function script\n"
	printf -- "\tVersión 2.2.1.0\n"
	printf -- "Creado por\n"
	printf -- "\tEstudiantes de la UNLa - https://www.unla.edu.ar\n" 
	printf -- "Licencia\n"
	printf -- "\tThe Unlicense - https://unlicense.org \n" 
}

fresh-install(){
	printf -- "\033[0;33m ¡Comenzando una instalación nueva! \033[0m\n"
	basic-install
	protect
	version
	sweep
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

update(){
	printf -- "\033[0;33m ¡Actualizando a una nueva versión de umfs.sh! \033[0m\n"
	remove
	basic-install
	protect
	version
	sweep	
	printf -- "\033[0;32m ¡Terminado! \033[0m\n"
}

while getopts "ciuhv" option; do
	case $option in
		c)
			clean
			;;
		i)
			fresh-install
			;;
		u)
			update
			;;
		h)
			show-help 
			;;
		v)
			version
			;;
		*)
			printf -- "\033[0;31m ¡Opción errónea! \033[0m\n"
			show-help	
	esac
done
