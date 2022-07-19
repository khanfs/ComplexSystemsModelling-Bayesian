## --------------------- Initialize ---------------------
## Clear-all
rm(list = ls()) # Clear variables
graphics.off() # Clear plots
cat("\014") # Clear console

## Tell user ui script is beginning to run
print("Global function")

## Allow specific errors to be displayed on screen, instead of displaying a generic error
options(shiny.sanitize.errors = FALSE)


## --------------------- Load packages ---------------------
source('dependencies.R')


## --------------------- Load functions ---------------------
source("functions.R")


## --------------------- Read data ---------------------
## Select 0 if data is loaded from local folder, or 1 if data is loaded from cloud
Read_from_cloud <- 1
src = "https://s3-us-west-2.amazonaws.com/cityknots-uploads/0.PNG"

## Load Student dataset
if(Read_from_cloud == 1) {
  Student_data <- read.csv(url("https://s3-us-west-2.amazonaws.com/cityknots-uploads/datos.icfes.csv"))
} else{
  Student_data <- fread("input/datos.icfes.csv") ## This is a datatable (and therefore a dataframe too!)
}
print("Data loaded")


## --------------------- Data pre-processing ---------------------
## Convert Student_data to data.table format
Student_data <- as.data.table(Student_data)

## Select relevant variables from data
Student_data <- Student_data[,c(
             "PUNTAJE",
             # "BIOLOGIA_PUNT",
             # "MATEMATICAS_PUNT",
             # "FILOSOFIA_PUNT",
             # "FISICA_PUNT",
             # "QUIMICA_PUNT",
             # "LENGUAJE_PUNT",
             # "INTERDISCIPLINAR_PUNT" # NO
             #"ECON_PERSONAS_HOGAR",
             #"FAMI_ING_FMILIAR_MENSUAL",
             # "FAMI_COD_EDUCA_PADRE",
             # "FAMI_COD_EDUCA_MADRE",
             # "FAMI_COD_OCUP_PADRE",
             # "FAMI_COD_OCUP_MADRE",
             "ESTU_ESTRATO",
             # "ECON_MATERIAL_PISOS",
             # "ECON_CUARTOS",
             # "ECON_SN_COMPUTADOR",
             "ESTU_TRABAJA",
             # "CIENCIAS_SOCIALES_PUNT",
             # "INGLES_DESEM",
             # "ECON_SN_CELULAR",
             # "ECON_SN_INTERNET",
             # "ECON_SN_SERVICIO_TV",
             # "ECON_SN_TELEFONIA",
             "TOTAL",
             # "SES",
             "DESERCION_MEDIA",
             "EXTRAEDAD",
             #"APROBACION_MEDIA",
             "REPROBACION_MEDIA",
             "AMBIENTE.ESCOLAR"
             ),
             with = F] ## with = F is for returning a data frame column, not a vector

## Keep just rows with complete data
Student_data <- Student_data[complete.cases(Student_data)]

## Convert columns of Student_data to numeric
#Student_data <- sapply(Student_data, function(x) as.numeric(as.character(x)))
Student_data$PUNTAJE <- as.numeric(as.character(Student_data$PUNTAJE))
Student_data$ESTU_ESTRATO <- as.numeric(as.character(Student_data$ESTU_ESTRATO))
Student_data$ESTU_TRABAJA <- as.numeric(as.character(Student_data$ESTU_TRABAJA))
Student_data$TOTAL <- as.numeric(as.character(Student_data$TOTAL))
Student_data$DESERCION_MEDIA <- as.numeric(as.character(Student_data$DESERCION_MEDIA))
Student_data$EXTRAEDAD <- as.numeric(as.character(Student_data$EXTRAEDAD))
Student_data$REPROBACION_MEDIA <- as.numeric(as.character(Student_data$REPROBACION_MEDIA))
Student_data$AMBIENTE.ESCOLAR <- as.numeric(as.character(Student_data$AMBIENTE.ESCOLAR))

## Normalize variables
# for (i in 1:ncol(Student_data)) { # Run through columns of dataframe
#  Student_data[,i] <- Student_data[,i,with=FALSE]/max(Student_data[,i,with=FALSE])
# }

## Copy student data to new datatables
Student_data_variables <- Student_data
Student_data_build_network <- Student_data
Student_data_distributions <- Student_data


## --- Build initial white list and black list
## Make whitelist (list of must links)
White_list <- as.data.table(matrix(c("",""), ncol = 2, byrow = T))[,.(from = V1, to = V2)] # 'From' and 'to' are the names of the columns

## Make blacklist (list of links to avoid)
Black_list <- as.data.table(matrix(c("",""), ncol = 2, byrow = T))[,.(from = V1, to = V2)] # 'From' and 'to' are the names of the columns

## --- Other variables
Plot_height_1 <- "1000px"
Plot_height_2 <- "1000px"

Score <- 0

## --- Tell user it is the end of the global script
print("End of Global function")
