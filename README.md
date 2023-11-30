# Entorno de trabajo para el club de retrocomputación

## Carpetas y archivos

* `linux/` - Contiene archivos que **no** pertenecen a DOS, por lo que no se recomienda acceder a dicha carpeta ni modificar los archivos dentro de ella.
* `mount/` - Carpeta que se monta como unidad `C:` y contiene todo lo necesario para trabajar desde DOS.
* `launch.sh` -  Script Bash que lanza DOSBox utilizando una configuración personalizada en la carpeta local. Es el único archivo que no pertenece a DOS que se encuentra fuera de la carpeta `linux` junto con README.md

## Cómo usar

* Instalar DOSBox
* Clonar este repositorio y mover/renombrar la carpeta para que quede ubicada en ~/DOS (Esto es para que el script `launch.sh` pueda funcionar correctamente en cualquier equipo).
* Abrir una terminal en ~/DOS/ y ejecutar `./launch.sh` . En este punto debería abrirse la pantalla de DOSBox con la carpeta `mount` montada como unidad `C:`.