#### This script is for reading the saber files and subsetting to MEDELLIN
#### DANE codes are made characters, so that then they can be used for crossreferencing
#### Giovanni Fri 16 Jun 2017
library(data.table)

# Make the list of files
flist <- list.files('data/bases.de.datos.iniciales/nuevas.bases.de.datos.2017/saber.11.por.estudiante/',full.names = T)

for (file2read in flist) {
    dfpar <- as.data.table(read.csv(file2read,sep = '|'))
    
    # Check what year it is
    filename <- gsub("-RGSTRO-CLFCCN.*",".rds",file2read)
    yr <- as.numeric(substr(filename,nchar(filename)-8,nchar(filename)-5))
    
    if (yr %in% c(2015,2016)) {
      dfpar <- dfpar[ESTU_MCPIO_PRESENTACION == 'MEDELLIN']
      dfpar <- dfpar[,COLE_COD_DANE_INSTITUCION:=as.character(COLE_COD_DANE_INSTITUCION)]
    }
    
    if (yr %in% c(2014)) {
      dfpar <- dfpar[MUNI_RESIDE == "MEDELLIN" | MUNI_APLI == "MEDELLIN"]
      dfpar <- dfpar[,CODIGO_DANE := as.character(CODIGO_DANE)]
    }
    
    if (yr %in% seq(2005,2013)) {
      dfpar <- dfpar[ESTU_EXAM_MPIO_PRESENTACION == 'MEDELLIN']
      if ("COLE_CODIGO_DANE_SEDE" %in% names(dfpar)) {
        dfpar[, CODIGO_DANE := COLE_CODIGO_DANE_SEDE]
        dfpar$COLE_CODIGO_DANE_SEDE <- NULL
      }
      dfpar <- dfpar[,CODIGO_DANE := as.character(CODIGO_DANE)]
    }
    
    if (yr %in% c(2004)) {
      dfpar <- dfpar[ESTU_MCPIO_PRESENTACION == "MEDELLIN"]
    }
    
    filename <- paste("data/saber.11.por.estudiante.medellin/",gsub(".*//","",filename),sep = "")
    saveRDS(dfpar,filename)
}

### Problem: 2014 does not have DANE code
### Need way to crossreferencing
