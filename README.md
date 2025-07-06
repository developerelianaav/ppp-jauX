# ppp-jauX
En este repositorio se encuentran los archivos utilizados por el grupo 2
en una PPP de la UNLa, que transcurrió entre Junio y Agosto del 2025.

## umfs.sh

* P: ¿Qué es ```umfs.sh```?
* R: ```umfs.sh``` es un script escrito para [Bash](https://www.gnu.org/software/bash/), su objetivo
  es automatizar las tareas del Grupo 1 y 2.
* P: ¿Qué tareas automatiza ```umfs.sh```?
* R: ```umfs.sh``` actualmente automatiza las siguientes tareas:
  1. Limpieza del ```/home/``` del estudiante.
  2. Restricción agresiva del usuario.
  3. Instalación de los programas necesarios para la PPP (Parcialmente completado).
* P: ¿Qué hay en la carpeta archivos?
* R: En la carpeta archivos se encuentran archivos, valga la redundancia, que ```umfs.sh```
  descarga y utiliza en sus tareas.
* P: ¿Cómo puedo entender que hace el script?
* R: Leyendolo y viendo que hace cada programa llamado, recomendaría usar las guías
  de Red Hat y las páginas man.

## Uso de umfs.sh

* Si es la primera vez que se instala ```umfs.sh```:

```
wget "https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/umfs.sh"
sudo bash umfs.sh -i
```

* Si ```umfs.sh``` ya ha sido instalado en la pc anteriormente:

```
wget "https://raw.githubusercontent.com/developerelianaav/ppp-jauX/refs/heads/main/umfs.sh"
sudo bash umfs.sh -u
```

## Recursos útiles
* [man bash](https://www.man7.org/linux/man-pages/man1/bash.1.html)
* [man test](https://www.man7.org/linux/man-pages/man1/test.1.html)
* [Bash best practices](https://bertvv.github.io/cheat-sheets/Bash.html)
* [Using Case](https://www.redhat.com/en/blog/arguments-options-bash-scripts)
* [Do not use If](https://www.youtube.com/watch?v=p0KKBmfiVl0)
* Lectura de varias publicaciones en [Unix](https://unix.stackexchange.com), [StackOverFlow](https://stackoverflow.com)
  y [Serverfault](https://serverfault.com).
