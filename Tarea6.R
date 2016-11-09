# Script que contiene la automatización de adquisición de datos. 
# Elaborado por: Rubi Canales
# Fecha: Noviembre 2016

#Paso 1. Carga los paquetes necesarios si éstos no han sido cargados.
PACKAGES <- list(paq="R.utils","R.oo")

#Paso 2. Revisar si los paquetes han sido instalados, si no los instala y después los cargar.
for (package in PACKAGES ) {
  if (!require(package, character.only=T, quietly=T)) {
    # Instalar
    install.packages(PACKAGES)
    # Cargar
    library(PACKAGES)
  }
}

#Paso 3. Establecer el directorio de trabajo.
Dir_Descargas <- "C:/Tarea6/Descargas/"

# Valida la existencia y crea un directorio de descarga, de no existir.
if( !file.exists(Dir_Descargas) ) {
  dir.create(file.path(Dir_Descargas), recursive=TRUE) 
  if( !dir.exists(Dir_Descargas) ) {
    stop("No existe directorio")
  }
}
  

#Paso 4. Valida la existencia de un directorio para los conjuntos de datos y lo crea de ser necesario.
Dir_Datos <- "C:/Tarea6/Datos/"
if( !file.exists(Dir_Datos) ) {
  dir.create(file.path(Dir_Datos), recursive=TRUE)
  if( !dir.exists(Dir_Datos) ) {
    stop("No existe directorio")
  }
}

#Paso 5. Lista de los nombres de archivos a trabajar. 
# Si el archivo no está presente en el directorio
# de datos lo buscará en el directorio de descarga, si no está presente se descargará de la red.

#file <- paste0(Dir_Datos,"StormEvents_fatalities-ftp_v1.0_d2004_c20160223.csv")
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

# URL de donde se obtendrá la información en caso de no existir.
url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

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

#Paso 6. Creación del DataFrame que concatena todos los archivos.

# La estructura de datos es limpiada en cada ejecución.
if( exists("Fatalities") ){
  rm(Fatalities)
}

# La estructura es inicialmente llenada con la lectura del primer archivo.
for( file in FILES ){
  if( !exists("Fatalities" ) ) {
    Fatalities<-read.csv( paste0(Dir_Datos,file), header=T, sep=",", na.strings="")
    # Regresa el total de registros del archivo incial.
    cat(file , "con " , nrow(Fatalities), " registros.","\n")
  } 
  # Las lecturas subsecuentes van añadiendo el restos de los archivos a la estructura.
  else {
    data<-read.csv( paste0(Dir_Datos,file), header=T, sep=",", na.strings="")
    Fatalities<-rbind(Fatalities,data)
    # Regresa el total de registros por cada archivo.
    cat(file , "con " , nrow(data), " registros.","\n")
  }
}
# Se elimina la variable temporal.
rm(data)
# Paso 7. Desplegará el número de registros de la estructura, es decir
# la suma de todos los registros de cada archivo.
cat("Total de registros: ",nrow(Fatalities))

# Fin

