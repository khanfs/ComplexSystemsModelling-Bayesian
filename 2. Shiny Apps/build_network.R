## --------------------- Build network ---------------------
## Obtain initializing network with mmhc algorithm
if(as.character(Black_list[1,1])=="" | as.character(Black_list[1,2])=="") {
  if(as.character(White_list[1,1])=="" | as.character(White_list[1,2])=="") {
    BN.initial.mmhc <- mmhc(Student_data_build_network,whitelist = NULL,blacklist = NULL)
  } else{
    BN.initial.mmhc <- mmhc(Student_data_build_network,whitelist = White_list,blacklist = NULL)
  }
} else{
  if(as.character(White_list[1,1])=="" | as.character(White_list[1,2])=="") {
    BN.initial.mmhc <- mmhc(Student_data_build_network,whitelist = NULL,blacklist = Black_list)
  } else{
    BN.initial.mmhc <- mmhc(Student_data_build_network,whitelist = White_list,blacklist = Black_list)
  }
}



## Build network with hc algorithm
## Note: perturb is an integer, the number of attempts to randomly
## ...insert/remove/reverse an arc on every random restart.
#BN.hc <- hc(Student_data, start = BN.initial.mmhc, perturb = 1000, whitelist = White_list)
BN.hc <- BN.initial.mmhc

## Calculate strength of links (the more negative, the more strength)
BN.hc.str <- arc.strength(BN.hc,Student_data_build_network)

## Calculate score of the network
Score <<- -1 * bnlearn::score(BN.hc, Student_data_build_network)
print("Score:")
print(Score)
