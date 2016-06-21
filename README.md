# spore-bounce

Pequeño juego de plataformas hecho en lua con [love2d](https://love2d.org/).




## Requisitos

**Linux** o **Windows** con el framework [love2d](https://love2d.org/) instalado. 




## Ejecución

###### Ubuntu

- Para empaquetar el juego:
```
git clone --recursive https://github.com/MdeMoUcH/spore-bounce
cd spore-bounce
zip -r spore-bounce.love * 
```

- Para ejecutar el juego:
```
love spore-bounce.love
```
O simplemente doble click.




## Errores

###### Error: main.lua:15: module 'Advanced-Tiled-Loader/Loader' not found: [...]
Descarga el repositorio con los submodulos (dentro del repositorio):
```
git submodule update --init --recursive
```




[MdeMoUcH](http://www.twitter.com/mdemouch) | [La Gran M](http://www.lagranm.com) | [Ubuntu Fácil](http://www.ubuntufacil.com)
