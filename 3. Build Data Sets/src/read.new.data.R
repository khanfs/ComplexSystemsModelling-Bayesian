library(data.table)

df <- read.csv("data/DatosIcfes.csv")
EXTRAEDAD.ALL <- as.data.table(read.csv("data/EXTRAEDAD.csv",header=T))
SESTOTAL.ALL <- as.data.table(read.csv("data/SES.TOTAL.csv",header=T))
AMBIENTE.ALL <- as.data.table(read.csv("data/AMBIENTE.ESCOLAR.csv",header=T))
DESERCION.APROBACION <- as.data.table(read.csv("data/DESERCION.APROBACION.csv"))
IE <- as.data.table(read.csv("data/IE_media_tecnica.csv"))
MATRICULA <- as.data.table(read.csv("data/matricula_media.csv"))

dt <- as.data.table(df)
# dt <- dt[ESTU_EXAM_MPIO_PRESENTACION == "MEDELLIN"]
# dt <- dt[!is.na(CODIGO_DANE)]

### This makes clear we have to sum by COLE_COIGO_COLEGIO and not CODIGO_DANE
#View(unique(dt[,.(COLE_INST_NOMBRE,CODIGO_DANE),by = COLE_CODIGO_COLEGIO])[order(COLE_CODIGO_COLEGIO)])
dt$FTP_CONSECUTIVO <-NULL
dt$ESTU_NACIMIENTO_DIA <- NULL
dt$ESTU_NACIMIENTO_MES <- NULL
dt$ESTU_EXAM_DEPT_PRESENTACION <- NULL
dt$ESTU_EXAM_MPIO_PRESENTACION <- NULL
dt$ESTU_RESIDE_DEPT_PRESENTACION <- NULL
dt$ESTU_RESIDE_MPIO_PRESENTACION <- NULL
dt$ESTU_PAIS_RESIDE <- NULL
dt$ESTU_CODIGO_RESIDE_MCPIO <- NULL
dt$ESTU_EXAM_COD_MPIOPRESENTACION <- NULL
dt$ESTU_EXAM_NOMBREEXAMEN <- NULL
dt$INAC_COLEGIOTERMINO <- NULL
dt$PLAN_CODIGODANEINSTITUCION <- NULL
# dt$CODIGO_DANE <- NULL
dt$ESTU_PUESTO <- NULL
dt$ESTU_TIPODOCUMENTO <- NULL

### desercion.aprobacion adjust
DESERCION.APROBACION <- DESERCION.APROBACION[!grepl(pattern ="DIV",x = DESERCION.APROBACION$DESERCION_MEDIA)]
DESERCION.APROBACION <- DESERCION.APROBACION[,lapply(.SD,as.character)][,lapply(.SD,as.double)]


### Make the key a character
dt[, CODIGO_DANE := as.character(CODIGO_DANE)]
EXTRAEDAD.ALL$DANE <- as.character(EXTRAEDAD.ALL$DANE)
SESTOTAL.ALL$DANE <- as.character(SESTOTAL.ALL$DANE)
AMBIENTE.ALL$DANE <- as.character(AMBIENTE.ALL$DANE)
DESERCION.APROBACION$CODIGO_DANE_SEDE <- as.character(DESERCION.APROBACION$CODIGO_DANE_SEDE)
IE$DANE <- as.character(IE$DANE)
MATRICULA$DANE <- as.character(MATRICULA$DANE)

dt$YEAR <- as.numeric(substr(as.character(dt$PERIODO),1,4))
dt$PERIODO <- NULL

dt <- merge(dt,EXTRAEDAD.ALL,by.x = c("CODIGO_DANE","YEAR"),by.y = c("DANE","YEAR"),all.x = T)
dt <- merge(dt,SESTOTAL.ALL,by.x = c("CODIGO_DANE","YEAR"),by.y = c("DANE","YEAR"),all.x = T)
dt <- merge(dt,AMBIENTE.ALL,by.x = c("CODIGO_DANE","YEAR"),by.y = c("DANE","YEAR"),all.x = T)
dt <- merge(dt,DESERCION.APROBACION,by.x = c("CODIGO_DANE","YEAR"),by.y = c("CODIGO_DANE_SEDE","ANO"),all.x = T)
dt <- merge(dt,IE,by.x = c("CODIGO_DANE","YEAR"),by.y = c("DANE","ANNO"),all.x = T)
dt <- merge(dt,MATRICULA,by.x = c("CODIGO_DANE","YEAR"),by.y = c("DANE","ANNO_INF"),all.x = T)



dt[, names(dt[,dt[,sapply(.SD,is.integer)],with = F]) := lapply(.SD, as.numeric), .SDcols=names(dt[,dt[,sapply(.SD,is.integer)],with = F])]

dt <- dt[,-c("CODIGO_DANE","YEAR"),with = F]

saveRDS(dt,file = "./data/datos.icfes.rds")
 


