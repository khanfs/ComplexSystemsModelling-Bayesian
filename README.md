# Complex Systems Modelling
### DevOps Team
- Farooq Khan, Product Architect
- Dr Giovanni Mizzi, Data Scientist
- Peter de Ford Gonzales, Data Scientist
## Bayesian Networks
Bayesian Networks allow us to integrate expert knowledge and data from multiple heterogeneous sources; thus they allow us to model the heterogeneity of human behaviour  and update our knowledge (or our belief) on each variable.   As  a  result  they  are  able  to  capture  the  effect  of  the complex human behaviour - **social physics** - and the behaviour of societies in ways that cannot be achieved using classical statistical methods. Bayesian models also  enable  us  to  update  our  knowledge  on  each  variable as we gather more evidence.  This means we can update models in real-time as we learn more about each variable in the system; **using machine-learning techniques we can generate Bayesian Networks to automatically estimate all parameters in the system**.

### Process of building this kind of model:

1. Using the available data, we run algorithms to discover possible correlations between the variables.  This will be the skeleton of our Bayesian Network.
2. Then we use machine-learning algorithms to try and extract a possible set of causal relations.
3. This  network  represents  the  set  of  beliefs  extracted  by  the  data. It is then checked by an expert to eliminate links that are known to be in one direction or another, to add obvious links and eliminate impossible ones.This is the most important phase, the one in which expert knowledge is combined with knowledge extracted from the data.

Given this network we can make simulations, changing one variable and looking at what happens to the others. We can evaluate the effectiveness of public policies by predicting their effect; identifying the variables most likely involved in producing these effects.
