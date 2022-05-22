# Load data
if(Read_from_cloud == 1) {
  matricula.dane <- read.csv(url("https://s3-us-west-2.amazonaws.com/cityknots-uploads/Matricula_per_DANE.csv"))
  directorio <- read.csv(url("https://s3-us-west-2.amazonaws.com/cityknots-uploads/Dir.csv"))
} else{
  matricula.dane <- read.csv("input/Matricula_per_DANE.csv",header=T)
  directorio <- read.csv("input/DIRECTORIO DE ESTABLECIMIENTOS EDUCATIVOS 20150618.csv")
}


# Build Directorio_main
Directorio_main <- data.frame(as.numeric(as.character((directorio$LAT))),as.numeric(as.character((directorio$LON))),directorio$SECTOR)
Directorio_main <- Directorio_main[complete.cases(Directorio_main), ]
colnames(Directorio_main) <- c("LAT","LON","SECTOR")


# Arrange data
danematri <- matricula.dane[with(matricula.dane,order(DANE)),]
daneurban <- directorio[with(directorio,order(directorio$DANE)),]
daneurban$LAT <- directorio$LAT[match(daneurban$DANE,directorio$DANE)]
daneurban$LON <- directorio$LON[match(daneurban$DANE,directorio$DANE)]
daneurban$LAT <- as.numeric(as.character(daneurban$LAT))
daneurban$LON <- as.numeric(as.character(daneurban$LON))
#daneurban$TOTAL <- danematri$Total.general[match(daneurban$DANE,danematri$DANE)]


# Build background map of Medellín
medellin.map <- qmap("medellin", source="google", maptype = "roadmap", zoom = 13, color = "bw", legend = "topright")



