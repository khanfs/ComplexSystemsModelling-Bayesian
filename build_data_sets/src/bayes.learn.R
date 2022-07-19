library(bnlearn)
library(data.table)
library(corrplot)
library(ggplot2)
library(viridis)
library(gridExtra)
library(RColorBrewer)

dt <- readRDS("./data/datos.icfes.rds")

source("./src/functions.R")

####### APPROACH 1.
### Take variables from file that Samuel sent.
BN.ALL <- dt[,c(
             "PUNTAJE",
             # "BIOLOGIA_PUNT",
             # "MATEMATICAS_PUNT",
             # "FILOSOFIA_PUNT",
             # "FISICA_PUNT",
             # "QUIMICA_PUNT",
             # "LENGUAJE_PUNT",
             # "INTERDISCIPLINAR_PUNT" # NO
             # "ECON_PERSONAS_HOGAR",
             # "FAMI_ING_FMILIAR_MENSUAL",
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
             # "APROBACION_MEDIA",
             "REPROBACION_MEDIA",
             "AMBIENTE.ESCOLAR"
             ),
             with = F]

BN.ALL <- BN.ALL[complete.cases(BN.ALL)][,lapply(.SD,as.double)]
# BN.YR.bn <- mmhc(BN.ALL)
# BN.YR.bn.str <- arc.strength(BN.YR.bn,BN.ALL)
# strength.plot(BN.YR.bn,BN.YR.bn.str,shape = "ellipse",layout = "fdp")
# 
# BN.YR.hc <- hc(BN.ALL, start = BN.YR.bn ,perturb = 1000)
# BN.YR.hc <- hc(BN.ALL, start = BN.YR.hc ,perturb = 1000)
# BN.YR.hc.str <- arc.strength(BN.YR.hc,BN.ALL)
# strength.plot(BN.YR.hc,BN.YR.hc.str,shape = "ellipse",layout = "fdp")
# 
# score(BN.YR.hc,BN.ALL)
# [1] -863934.8
corrplot(cor(na.omit(BN.ALL[,.SD,.SDcols = sapply(BN.ALL, is.numeric)])),order="FPC", col = viridis(100),tl.col="black")

#### =======
wl <- as.data.table(matrix(c(
               "REPROBACION_MEDIA", "EXTRAEDAD",
               "ESTU_ESTRATO","PUNTAJE",
               "ESTU_ESTRATO","REPROBACION_MEDIA",
               "ESTU_ESTRATO","DESERCION_MEDIA",
               "AMBIENTE.ESCOLAR","PUNTAJE"
               ), ncol = 2, byrow = T))[,.(from = V1, to = V2)]

bl <- as.data.table(matrix(c(
  "EXTRAEDAD", "ESTU_ESTRATO"
), ncol = 2, byrow = T))[,.(from = V1, to = V2)]

BN.YR.hc <- mmhc(BN.ALL,whitelist = wl, blacklist = bl,perturb = 10000)

# plot(bn.cv(BN.ALL,BN.YR.hc,runs = 20))
# BN.YR.hc <- hc(BN.ALL, start = BN.YR.hc ,perturb = 1000,whitelist = wl)

BN.YR.hc.str <- arc.strength(BN.YR.hc,BN.ALL)
strength.plot(BN.YR.hc,BN.YR.hc.str,shape = "ellipse",layout = "dot")

#### ===== Now we have it, we want to use it
for (ii in seq(1,length(BN.ALL))) {
  vect <- BN.ALL[,ii,with = F][[1]]
  if (length(unique(vect)) > nclass.Sturges(vect)) {
    breaks <- nclass.Sturges(vect)
    r <- range(vect)  
    b <- seq(r[1],r[2],length = 2*breaks+1)  
    brk <- b[0:breaks*2+1]
    mid <- b[1:breaks*2]
    brk[1] <- brk[1]-0.01 # because open left
    k <- cut(vect, breaks=brk, labels=FALSE) 
    vect <- format(mid[k],digits = 2)
  }
  BN.ALL[[ii]] <- vect
}

BN.ALL <- BN.ALL[,lapply(.SD,as.factor)]
### some need some readjustment
# levels(BN.ALL$ECON_PERSONAS_HOGAR) <- levels(BN.ALL$ECON_PERSONAS_HOGAR)[c(2,seq(6,13),seq(3,5),1)]

####********************************
# BN.YR.hc <- hc(BN.ALL,whitelist = wl)
# BN.YR.hc <- hc(BN.ALL, start = BN.YR.hc ,perturb = 1000,whitelist = wl)

# dev.new()
# BN.YR.hc.str <- arc.strength(BN.YR.hc,BN.ALL)
# strength.plot(BN.YR.hc,BN.YR.hc.str,shape = "ellipse",layout = "dot")
####********************************


BN.YR.fitted <- bn.fit(BN.YR.hc,BN.ALL,method = "bayes")

###### This bit is for the creation of phase space. Not needed any more
### Function to calculate normalised expected value
# expectedvalue <- function(x) {
#   values <- x[,1][,apply(.SD,FUN=as.numeric,1)]
#   expect <- sum(values*x$probs)
#   return(expect)
# }
# 
# normexp <- function(x) {
#   values <- x[,1][,apply(.SD,FUN=as.numeric,1)]
#   expect <- sum(values*x$probs)
#   norm <- (expect - min(values))/(max(values)-min(values))
#   return(norm)
# }
#######

# To get the probabilities from data just table them
# Use the function prob(DATASET, "VARIABLE")
VRBL <- c("TOTAL","AMBIENTE.ESCOLAR","ESTU_TRABAJA","ESTU_ESTRATO",
          "REPROBACION_MEDIA","EXTRAEDAD","DESERCION_MEDIA")
COND <- "PUNTAJE"

COND.prob <- prob(BN.ALL,COND)
setnames(COND.prob,"probs","probs.old")
COND.prob$probs <- COND.prob$probs.old[c(seq(nrow(COND.prob)-2,nrow(COND.prob)),seq(1,nrow(COND.prob)-3))]


### Initialise

###### This bit is for the creation of phase space. Not needed any more
# phase <- NULL
# for (i in 1:nrow(COND.prob)){
#   print(i)

# COND.prob$probs <- rep(0,nrow(COND.prob))
# COND.prob$probs[i] <- 1

######


  # This done do keep the bins. One might want to simulate the distribution.
  # Then need to bin it. Not done here
  
  ### This is the important bit
  ### The function that propagates propagate(DATASET,FITTED BN, ARRAY OF VARIABLES, CONDITIONING VARIABLE PROB DIST)
  VRBL.prob <- propagate(BN.ALL,BN.YR.fitted,VRBL,COND.prob)
  ### ---
  
###### This bit is for the creation of phase space. Not needed any more
#   res <- lapply(VRBL.prob, FUN = normexp)
#   res[[COND]] <- expectedvalue(COND.prob)
#   phase <- rbind(phase,res)
# }

#### This is done by hand because no time to automate
# phase.TOTAL <- phase
# phase <- phase.EXTRAEDAD
# df <- melt(as.data.table(phase),id.vars = "EXTRAEDAD")
# df <- df[,c("EXTRAEDAD","value"):=lapply(.(EXTRAEDAD,value),as.numeric)]
# # df <-df[,.(EXTRAEDAD,value = (value-min(value))/(max(value)-min(value))),by = variable]
# 
# pdf("./EXTRAEDAD.pdf",width = 7.5,height = 10)
# ggplot(df,aes(x = EXTRAEDAD, y = value)) + geom_line() + facet_grid(variable ~ .) + ylim(c(0,1))
# # geom_line(aes(group = variable,color = variable))
# dev.off()
######
   

#### PICTURES
cols <- brewer.pal(3,"Set2")
names(cols) <- c("probs","probs.old","Other")

png("Rplot.png",width = 1500, height = 2000, units = "px", res = 120)
plts <- list()
# First row old probs
# barplot(names.arg = as.data.frame(COND.prob)[,COND],height = COND.prob$probs.old, ylim = c(0,1),main = COND)
pltdata <- melt(COND.prob)
plts[[COND]] <- ggplot(pltdata,aes_string(x = COND, y = "value", fill = "variable")) + geom_bar(stat = "identity",position = "dodge") + 
  ylab("Probability") + 
  theme(legend.title=element_blank()) + 
  scale_fill_manual(breaks=c("probs.old", "probs"),
                      labels=c("Old", "New"),
                      values=cols)

for (i in names(VRBL.prob)){
  # barplot(names.arg = as.data.frame(VRBL.prob[[i]])[,1],height = VRBL.prob[[i]]$probs.old, ylim = c(0,1),main = i)
  pltdata <- melt(VRBL.prob[[i]])
  plts[[i]] <- ggplot(pltdata,aes_string(x = i, y = "value", fill = "variable")) + geom_bar(stat = "identity",position = "dodge") + 
    ylab("Probability") + 
    theme(legend.title=element_blank()) + 
    scale_fill_manual(breaks=c("probs.old", "probs"),
                      labels=c("Old", "New"),
                      values=cols)
}
grid.arrange(grobs = plts,ncol = 2)
dev.off()

png("Rplot1.png",width = 800, height = 600, units = "px", res = 120)
plts[[COND]]
dev.off()

# png("delta_punteggi.png",width = 1400, height = 800, units = "px", res = 120)
# par(mfrow=c(1,length(VRBL)+1))
# barplot(names.arg = as.data.frame(COND.prob)[,COND],height = COND.prob$probs-COND.prob$probs.old, ylim = c(-0.5,0.5),main = COND)
# for (i in names(VRBL.prob)){
#   barplot(names.arg = as.data.frame(VRBL.prob[[i]])[,1],height = VRBL.prob[[i]]$probs-VRBL.prob[[i]]$probs.old, ylim = c(-0.5,0.5),main = i)
# }
# dev.off()

png("delta.png",width = 1500, height = 2000, units = "px", res = 120)
pltsdf <- list()
# First row old probs
# barplot(names.arg = as.data.frame(COND.prob)[,COND],height = COND.prob$probs.old, ylim = c(0,1),main = COND)
pltdata <- COND.prob
pltdata$diff <- pltdata$probs-pltdata$probs.old
pltsdf[[COND]] <- ggplot(pltdata,aes_string(x = COND, y = "diff")) + geom_bar(stat = "identity") +
  ylab("Probability difference") +
  theme(legend.title=element_blank())

for (i in names(VRBL.prob)){
  # barplot(names.arg = as.data.frame(VRBL.prob[[i]])[,1],height = VRBL.prob[[i]]$probs.old, ylim = c(0,1),main = i)
  pltdata <-VRBL.prob[[i]]
  pltdata$diff <- pltdata$probs-pltdata$probs.old
  pltsdf[[i]] <- ggplot(pltdata,aes_string(x = i, y = "diff")) + geom_bar(stat = "identity") +
    ylab("Probability difference") +
    theme(legend.title=element_blank())
}
grid.arrange(grobs = pltsdf,ncol = 2)
dev.off()

#### SINGLE
for (i in names(VRBL.prob)) {
  png(paste0(i,".png"),width = 1500, height = 500, units = "px", res = 120)
  print(grid.arrange(plts[[i]], pltsdf[[i]],ncol = 2))
  dev.off()
}


