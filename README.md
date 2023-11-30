# Entorno de trabajo para el club de retrocomputación

## Carpetas y archivos

* `docs` - Contiene libros, apuntes y material.
* `mount/` - Carpeta que se monta como unidad `C:` y contiene todo lo necesario para trabajar desde DOS.
* `dosbox.conf` - Archivo de configuración personalizado para DOSBox (utilizado por `launch.sh` para lanzar siempre un entorno consistente en distintos equipos)
* `launch.sh` -  Script Bash que lanza DOSBox utilizando la configuración personalizada.

## Cómo usar

* Instalar DOSBox
* Clonar este repositorio y mover/renombrar la carpeta para que quede ubicada en ~/DOS (Esto es para que el script `launch.sh` pueda funcionar correctamente en cualquier equipo).
* Abrir una terminal en ~/DOS/ y ejecutar `./launch.sh` . En este punto debería abrirse la pantalla de DOSBox con la carpeta `mount` montada como unidad `C:`.