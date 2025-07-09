# ppp-jauX
En este repositorio se encuentran los archivos utilizados por el grupo 2
en una PPP de la UNLa, que transcurrió entre Junio y Agosto del 2025.

## smu.sh

* P: ¿Qué es ```smu.sh```?
* R: ```smu.sh``` es un script escrito para [Bash](https://www.gnu.org/software/bash/), su objetivo es automatizar las tareas del Grupo 2.
* P: ¿Qué tareas automatiza ```smu.sh```?
* R: ```smu.sh``` actualmente automatiza las siguientes tareas:
  1. Limpieza del ```/home/``` del estudiante.
  2. Restricción agresiva del usuario.
  3. Instalación de algúnos de los programas necesarios para la PPP.
* P: ¿Qué hay en la carpeta archivos?
* R: En la carpeta archivos se encuentran archivos, valga la redundancia, que ```smu.sh```
  descarga y utiliza en sus tareas.
* P: ¿Cómo puedo entender que hace el script?
* R: Leyendolo y viendo que hace cada programa.

## Uso de smu.sh

* Si es la primera vez que se instala ```smu.sh```:

```
wget "https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/smu.sh"
sudo bash smu.sh -i
```

* Si ```smu.sh``` ya ha sido instalado anteriormente:

```
wget "https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/smu.sh"
sudo bash smu.sh -u
```

## Recursos útiles
* [bash cheat-sheet](https://bertvv.github.io/cheat-sheets/Bash.html)
* [man bash](https://www.man7.org/linux/man-pages/man1/bash.1.html)
* [man test](https://www.man7.org/linux/man-pages/man1/test.1.html)
