##### 23 Jun 2017
#####
##### SOME FUNCTIONS
#####

## Function to extract probabilities from data

prob <- function(DT,VRBL) {
  # Need DT as data.table
  # Need VRBL as a string
  samples <- nrow(DT)
  probability <- table(DT[,VRBL,with = F])/nrow(DT)
  probability <- as.data.table(probability)[,.(as.factor(format(as.numeric(V1),digits = 2)),probs = N)]
  names(probability)[1] <- VRBL
  return(probability)
}

# Function to assign distribution to node and propagate to other nodes
propagate <- function(DT,BN.fitted,VRBL.list,COND.prob) {
  
  # Initialise empty result list
  result <- list()
  
  for (VRBL in VRBL.list) {
  
    VRBL.prob <- prob(DT,VRBL)
    OLD.VRBL.prob <- rbind(VRBL.prob)
    VRBL.prob <- VRBL.prob[1:nrow(VRBL.prob), probs := 0] 
    
    for (i in 1:nrow(COND.prob)) {
      XTR <- as.data.frame(attr(predict(BN.fitted , VRBL, COND.prob[i,1,with = F], method = "bayes-lw", prob = T),"prob"))
      XTR$bins <- rownames(XTR)
      XTR <- as.data.table(XTR)
      XTR <- XTR[,.(bins = bins, probs = V1)]
      VRBL.prob  <- VRBL.prob[,probs := probs + XTR$probs*as.numeric(COND.prob$probs[i])]
      VRBL.prob$probs.old <- OLD.VRBL.prob$probs
    }
    
    result[[VRBL]] <- VRBL.prob
  }
  
  return(result)
}