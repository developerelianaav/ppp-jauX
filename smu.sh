#! /usr/bin/env bash

set -o errexit 
set -o nounset 
set -o pipefail
set +o histexpand

shopt -s extglob

fon="https://github.com/developerelianaav/ppp-jauX/blob/main/archivos/wall.png?raw=true"
unl="https://github.com/developerelianaav/ppp-jauX/blob/main/archivos/unla.jpg?raw=true"

plk="https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/archivos/60-estudiante.conf"
pro="https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/archivos/profile"

est="/home/estudiante"
epc="/etc/polkit-1/localauthority.conf.d"

directorios() {
	if [ $(whoami) == "root" ]; then
		printf -- "\033[0;33m¡Creando directorios!\033[0m\n"
		[ ! -d "${epc}" ] && mkdir --parents "${epc}"
		[ ! -d "${est}"/Clases ] && su estudiante --command="mkdir --parents \"${est}\"/Clases"
		printf -- "\033[0;32m¡Se crearon los directorios!\033[0m\n"
	else
		[ ! -d "${est}"/Clases ] && mkdir --parents "${est}"/Clases &>/dev/null
	fi
}

descargas(){
	if [ $(whoami) == "root" ]; then
		printf -- "\033[0;33m¡Descargando archivos!\033[0m\n"
		wget -O "${epc}"/60-estudiante.conf "${plk}"
		su estudiante --command="wget -O \"${est}\"/.profile \"${pro}\""
		su estudiante --command="wget -O \"${est}\"/Clases/.unla.jpg \"${unl}\""
		su estudiante --command="wget -O \"${est}\"/Clases/.wall.png \"${fon}\""
		printf -- "\033[0;32m¡Se descargaron los archivos!\033[0m\n"
	else
		[ -f "${est}"/.profile ] && \
			wget -O "${est}"/.profile "${pro}" &>/dev/null
		wget -O "${est}"/Clases/.unla.jpg "${unl}" &>/dev/null
		wget -O "${est}"/Clases/.wall.png "${fon}" &>/dev/null
	fi

}

editador(){
	printf -- "\033[0;33m¡Editando archivos!\033[0m\n"
	sed -i -e '/^\(root\|wheel\|sudo\)/{s/\(estudiante\|,estudiante\|estudiante,\)//g}' \
	       	/etc/group /etc/gshadow
	sed -i -e 's/# auth       required   pam_wheel.so/auth       required   pam_wheel.so/g' \
		/etc/pam.d/su
	printf -- "\033[0;32m¡Se editaron los archivos!\033[0m\n"
}

modificador() {
	printf -- "\033[0;33m¡Modificando los permisos de los archivos!\033[0m\n"
	chmod 700 --recursive /home/"${SUDO_USER}" 
	chmod 755 "${0}"
 	chmod 755 "${epc}"/60-estudiante.conf
	chmod 755 "${est}"/.profile
	chown "${SUDO_USER}" --recursive /home/"${SUDO_USER}"
	chown estudiante --recursive "${est}"/.bashrc "${est}"/.profile \
		"${est}"/Clases
	chattr +i "${est}"/.bashrc "${est}"/.profile
	printf -- "\033[0;32m¡Se modificaron los permisos de los archivos!\033[0m\n"
}

programas() {
	printf -- "\033[0;33m¡Instalando los programas!\033[0m\n"
	cp "${0}" /usr/local/bin/smu.sh
	apt update && apt upgrade --yes
	apt install --yes bleachbit jp2a
	printf -- "\033[0;32m¡Se instalaron los programas!\033[0m\n"
}

ceroizador() {
	printf -- "\033[0;33m¡Limpiando para actualizar!\033[0m\n"
	[ -f /etc/polkit-1/localauthority/50-local.d/10-estudiante-policy.pkla ] && \
		rm /etc/polkit-1/localauthority/50-local.d/10-estudiante-policy.pkla
  	[ -f /etc/polkit-1/rules.d/90-strict-estudiante-policy.rules ] && \
		rm /etc/polkit-1/rules.d/90-strict-estudiante-policy.rules
	[ -f /etc/polkit-1/localauthority.conf.d/60-estudiante-conf ] && \
		rm /etc/polkit-1/localauthority.conf.d/60-estudiante-conf
	[ -f /usr/local/bin/umfs.sh ] && rm /usr/local/bin/umfs.sh
 	[ -f /usr/local/bin/smu.sh ] && rm /usr/local/bin/smu.sh
	sed -i -e 's/auth       required   pam_wheel.so/# auth       required   pam_wheel.so/g' \
		/etc/pam.d/su
 	[ -d "${est}"/Clases ] && rm --recursive --force "${est}"/Clases
	chattr -i "${est}"/.profile "${est}"/.bashrc
 	[ -d "${est}"/.profile ] && rm --force "${est}"/.profile
	printf -- "\033[0;32m¡Se limpió!\033[0m\n"
}

barrido() {
	find /home/"${SUDO_USER}"/ -name "*smu.sh*" -type f -delete
 	find /home/"${SUDO_USER}"/ -name "*umfs.sh*" -type f -delete
	find /tmp/ -name "*pkg.list*" -type f -delete
}

limpieza() {
	if [ $(whoami) != "estudiante" ]; then
		printf -- "\033[0;31m¡Esta función es solo para el estudiante!\033[0m\n"
	else
		bleachbit --clean firefox.* google_chrome.* \
			libreoffice.* system.cache system.clipboard \
			system.recent_documents system.tmp system.trash \
			&>/dev/null
		cd "${est}" && rm --recursive --force !(Clases|.config|.local) &>/dev/null
		xdg-user-dirs-update &>/dev/null ; xdg-user-dirs-update --force  &>/dev/null
  		directorios
 		descargas
		gsettings set org.gnome.desktop.background picture-uri file:///"${est}"/Clases/.wall.png
	fi
}

configuracion() {
	if [[ $(whoami) != "root" || -z "${SUDO_USER}" ]]; then
		printf -- "\033[0;31m¡No puedes utilizar esta opción!\033[0m\n"
	else
		printf -- "\033[0;33m¡Comenzando a configurar esta PC!\033[0m\n"
		directorios
		descargas
 		editador
		modificador
		programas
		barrido
		printf -- "\033[0;32m¡Se termino de configurar esta PC!\033[0m\n"
	fi
}

actualizacion() {
	if [[ $(whoami) != "root" || -z "${SUDO_USER}" ]]; then
		printf -- "\033[0;31m¡No puedes utilizar esta opción!\033[0m\n"
	else
		printf -- "\033[0;33m¡Comenzando a actualizar esta PC!\033[0m\n"
		ceroizador
		directorios
		descargas
 		editador
		modificador
		programas
		barrido
		printf -- "\033[0;32m¡Se terminó de actualizar esta PC!\033[0m\n"
	fi
}

ayuda() {
	printf -- "smu - Script Multifunción de la UNLa\n"
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
	clear
	jp2a --colors --size=40x20 "${est}"/Clases/.unla.jpg
	printf -- "smu - Script Multifunción de la UNLa\n"
	printf -- "\tVersión 4.0.0.5\n"
	printf -- "Creado por\n"
	printf -- "\tEstudiantes de la UNLa - https://www.unla.edu.ar\n" 
	printf -- "Licencia\n"
	printf -- "\tThe Unlicense - https://unlicense.org \n"
	
}

while getopts "ciuhv" option; do
	case $option in
		c)
			limpieza
			;;
		i)
			configuracion
			;;
		u)
			actualizacion
			;;
		h)
			ayuda
			;;
		v)
			version
			;;
		*)
			printf -- "\033[0;31m¡Opción errónea!\033[0m\n"
			ayuda	
	esac
done
