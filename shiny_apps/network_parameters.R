## --------------------- Discretize Student_data_distributions ---------------------
## Classify variable values of Student_data_distributions into new numerical classes (similar to discretization)
## This is a reduction of the discrete sample space of each variable
#write.csv(Student_data_distributions,'Pre.csv', row.names = FALSE)
for (ii in seq(1,length(Student_data_distributions))) {
   vect <- Student_data_distributions[,ii,with = F][[1]]
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
   Student_data_distributions[[ii]] <- vect
}

## Convert Student_data_distributions columns to factors
Student_data_distributions <- Student_data_distributions[,lapply(.SD,as.factor)]
#write.csv(Student_data_distributions,'Post.csv', row.names = FALSE)


## --------------------- Find parameters of Bayesian Network ---------------------
## Fit the parameters of a Bayesian network (conditional probabilities of the variables)
print('Calculating Bayesian network parameters')
BN.hc.parameters <- bnlearn::bn.fit(BN.hc,Student_data_distributions,method = "bayes")
print('Finished calculating parameters')


## --------------------- Initialize ---------------------
## Define a variable (Root variable) for which I have a known distribution (that Policymakers can change)
Root_variable <- "TOTAL"

## Get distribution of Root_variable (Root_variable.prob is a data.table) from the data and assign it in the column current
Root_variable.prob <- prob(Student_data_distributions,Root_variable) ## Calculates probabilities of different bins/classes of the root variable, which add to 1
setnames(Root_variable.prob,"new","current") ## Change column name from 'new' to 'current'

## Create a new distribution that is the outcome of a new policy
Root_variable.prob$new <- Root_variable.prob$current[c(seq(nrow(Root_variable.prob)-2,nrow(Root_variable.prob)),seq(1,nrow(Root_variable.prob)-3))]

## Variables for which distributions will be visualized
Variables_to_visualize <- c("PUNTAJE","AMBIENTE.ESCOLAR","ESTU_TRABAJA","ESTU_ESTRATO",
          "REPROBACION_MEDIA","EXTRAEDAD","DESERCION_MEDIA")