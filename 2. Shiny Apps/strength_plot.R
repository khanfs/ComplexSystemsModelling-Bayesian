## --- Make the network plot ---

## Build basic plot
g <- strength.plot(BN.hc,BN.hc.str,shape = "ellipse",layout = "dot")

## Initialize attributes lists
nAttrs <- list()
eAttrs <- list()

## Put labels to edges (eAttrs$label is a named vector)
eAttrs$label <- as.character(format(log(abs(BN.hc.str$strength)),digits=4))
arrows <- rep("",nrow(BN.hc.str))
arrows[1] <- paste(as.character(BN.hc.str$from[1]),"~",as.character(BN.hc.str$to[1]),sep='')
for (i in 2:length(arrows)) {
  arrows[i] <- paste(as.character(BN.hc.str$from[i]),"~",as.character(BN.hc.str$to[i]),sep='')
}
names(eAttrs$label) <- arrows

## Define general attributes
attrs=list(node=list(fillcolor="lightgreen",shape = "ellipse",fixedsize = FALSE), edge=list(color="blue",fontsize=10), graph=list())

## Make final plot
plot(g, nodeAttrs=nAttrs, edgeAttrs=eAttrs, attrs=attrs)
