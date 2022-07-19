## Function to extract probabilities from data
prob <- function(DT,VRBL) {
  print(class(DT))
  
  # Need DT as data.table and VRBL as a string
  samples <- nrow(DT)
  probability <- table(DT[,VRBL,with = F])/nrow(DT)
  probability <- as.data.table(probability)[,.(as.factor(format(as.numeric(V1),digits = 2)),new = N)]
  names(probability)[1] <- VRBL
  return(probability)
}


# Function to assign distribution to node and propagate to other nodes
propagate <- function(DT,BN.fitted,VRBL.list,COND.prob) {
  ## Initialise empty result list
  result <- list()
  
  for (VRBL in VRBL.list) { ## Go through all variables
    
    print('Calculating probabilities for:')
    print(VRBL)
    
    VRBL.prob <- prob(DT,VRBL) ## Probability of ocurrence of a variable for each event in sample space
    OLD.VRBL.prob <- rbind(VRBL.prob) ## Save probabilities in old probability vector
    VRBL.prob <- VRBL.prob[1:nrow(VRBL.prob), new := 0] ## Create a zero-vector of probabilities
    
    for (i in 1:nrow(COND.prob)) {
      XTR <- as.data.frame(attr(predict(BN.fitted , VRBL, COND.prob[i,1,with = F], method = "bayes-lw", prob = T),"prob"))
      XTR$bins <- rownames(XTR)
      XTR <- as.data.table(XTR)
      XTR <- XTR[,.(bins = bins, new = V1)]
      VRBL.prob  <- VRBL.prob[,new := new + XTR$new*as.numeric(COND.prob$new[i])]
      VRBL.prob$current <- OLD.VRBL.prob$new
    }
    
    result[[VRBL]] <- VRBL.prob
  }
  return(result)
}


# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
