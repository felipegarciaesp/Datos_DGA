# Datos_DGA
Código para extraer datos de estaciones a partir de archivos descargados desde visor DGA (https://mapas2.mop.gob.cl/)


## Notas de uso

### Temperaturas medias diarias
Lo que se descarga como `Temperaturas Medias Diarias de Valores Extremos` desde Mapas DGA **no corresponde** a los mismos valores de `Temperaturas Medias Diarias de Valores Sinópticos` del portal clásico de descargas de la DGA (https://dga.mop.gob.cl/estadisticas-estaciones-dga/).

- `Valores Extremos`: promedio entre la temperatura mínima y la máxima del día.
- `Valores Sinópticos`: promedio de la temperatura del día calculado a partir de mediciones tomadas en horarios meteorológicos fijos globales (por ejemplo, desde las 08:00 hasta las 08:00).

Mapas DGA aún no tiene disponible la información sinóptica, por lo que, si se requiere, debe descargarse desde el portal clásico.

### Nombres de estaciones en `Estaciones.xlsx`
Los nombres ingresados en la planilla `Inputs/Estaciones.xlsx` deben estar escritos exactamente igual que en el archivo `.txt` descargado: todo en mayúsculas y con la misma cantidad de espacios. Se recomienda buscar el nombre de la estación en el `.txt` y pegarlo tal cual en la planilla.

Por continuar:

- Agrega todas las variables que te permite descargar de la pagina mapas DGA, actualemtne sol otienes caudal medio mensual, temperaturas maxima y minima diarias y preciptiacion diaria. Tienes un archivo Excel llamado Listado_Mapas_DGA en donde indicas con color amarillo cuales ya tienes, completa el listado. Revisa el nombre de descarga y como viene la información para poder compilarla. La idea no es que siempre estén todos estos archivos, pero que el codigo sepa como guardarlos en caso de que este el .txt.
