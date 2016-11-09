---
title: "README.md"
author: "Rubi Canales"
date: "8 de noviembre de 2016"
output: html_document
---


### **OBJETIVO:** 
##### Script con la automatización de adquisición de datos en **R** como una base metódica en la búsqueda de reproducibilidad de resultados y replicabilidad de acciones relacionadas con el análisis de datos.

### **ACTIVIDADES:**
##### Del sitio de los _National Centers for Environmental Information_ de la _National Oceanic and Atmospheric Administration_ (NOAA) se extraerá la categoría de datos de clima severo (_Severe Weather_) y, de ésta, una parte de la base de datos de eventos de tormentas (_Storm Events Database_). Descargando los archivos relacionados con decesos (_fatalities_) para un rango de una década con los que se desee trabajar.  

##### A continuación se describe paso a paso el **_proceso de automatización para la adquisición de datos_**:

##### **Paso 1** Carga los paquetes necesarios si éstos no han sido cargados.

```{r}
PACKAGES <- list(paq="R.utils","R.oo")
```

##### **Paso 2** Revisar si los paquetes han sido instalados, si no los instala y después los carga.
```{r}
for (package in PACKAGES ) {
  if (!require(package, character.only=T, quietly=T)) {
    # Instalar paquetes
    install.packages(PACKAGES)
    # Cargar paquetes
    library(PACKAGES)
  }
}
```

##### **Paso 3** Establecer el directorio de trabajo.
```{r}
Dir_Descargas <- "C:/Tarea6/Descargas/"
```

##### **Paso 4** Valida la existencia y crea un directorio de descarga, de no existir.
```{r}
if( !file.exists(Dir_Descargas) ) {
  dir.create(file.path(Dir_Descargas), recursive=TRUE) 
  if( !dir.exists(Dir_Descargas) ) {
    stop("No existe directorio")
  }
}
```

##### **Paso 5** Valida la existencia de un directorio para los conjuntos de datos y lo crea de ser necesario.
```{r}
Dir_Datos <- "C:/Tarea6/Datos/"
if( !file.exists(Dir_Datos) ) {
  dir.create(file.path(Dir_Datos), recursive=TRUE)
  if( !dir.exists(Dir_Datos) ) {
    stop("No existe directorio")
  }
}
```

##### **Paso 6** Lista de los nombres de archivos a trabajar. 
```{r}
FILES <-  list(archivo=
               "StormEvents_fatalities-ftp_v1.0_d2004_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2005_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2006_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2007_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2008_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2009_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2010_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2011_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2012_c20160223.csv",
               "StormEvents_fatalities-ftp_v1.0_d2013_c20160223.csv")                          
``` 
##### **Paso 7** Si el archivo no está presente en el directorio de datos lo buscará en el directorio de descarga, si no está presente se descargará de Internet y se descomprime en la carpeta de datos.

###### URL de donde se obtendrá la información en caso de no existir.
```{r}
url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"
```

```{r}
for( file in FILES ){
  # Valida si el archivo descompactado ya existe en el área de datos.
  if( ! file.exists( paste0(Dir_Datos,file))) {
    # Si no existe busca el archivo compactado en el área de descarga.
    if( ! file.exists( paste0(Dir_Descargas,file,".gz")) ){
      download.file( paste0(url,file,".gz"), paste0(Dir_Descargas,file,".gz"))
    }
    # Descompacta el archivo y lo deja en el área de datos.
    gunzip(paste0(Dir_Descargas,file,".gz"),paste0(Dir_Datos,file))
  }
}			    
```

##### **Paso 8** Creación del DataFrame que concatena todos los archivos.

```{r}
# La estructura de datos es limpiada en cada ejecución.
if( exists("Fatalities") ){
  rm(Fatalities)
}
```

##### La estructura es inicialmente llenada con la lectura del primer archivo. Las lecturas subsecuentes van añadiendo el restos de los archivos a la estructura.
```{r}
for( file in FILES ){
  if( !exists("Fatalities" ) ) {
    # Primer lectura.
    Fatalities<-read.csv( paste0(Dir_Datos,file), header=T, sep=",", na.strings="")
    # Regresa el total de registros del archivo incial.
    cat(file , "con " , nrow(Fatalities), " registros.","\n")
  } 
  # Lecturas subsecuentes.
  else {
    data<-read.csv( paste0(Dir_Datos,file), header=T, sep=",", na.strings="")
    Fatalities<-rbind(Fatalities,data)
    # Regresa el total de registros por cada archivo.
    cat(file , "con " , nrow(data), " registros.","\n")
  }
}
# Se elimina la variable temporal.
rm(data)
```
##### **Paso 9** Desplegará el número de registros de la estructura, es decir  la suma de todos los registros de cada archivo.
```{r}
cat("Total de registros: ",nrow(Fatalities))
```

