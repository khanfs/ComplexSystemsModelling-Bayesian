# Complex Systems Modelling
### DevOps Team
- Farooq Khan, Product Architect
- Giovanni Mizzi, PhD, Lead Data Scientist
- Peter de Ford Gonzales, Data Scientist
## Bayesian Networks
Bayesian Networks allow us to integrate expert knowledge and data from multiple heterogeneous sources; thus they allow us to model the heterogeneity of human behaviour  and update our knowledge (or our belief) on each variable.   As  a  result  they  are  able  to  capture  the  effect  of  the complex human behaviour - **social physics** - and the behaviour of societies in ways that cannot be achieved using classical statistical methods. Bayesian models also  enable  us  to  update  our  knowledge  on  each  variable as we gather more evidence.  This means we can update models in real-time as we learn more about each variable in the system; **using machine-learning techniques we can generate Bayesian Networks to automatically estimate all parameters in the system**.

### Process of building this kind of model:

1. Using the available data, we run algorithms to discover possible correlations between the variables.  This will be the skeleton of our Bayesian Network.
2. Then we use machine-learning algorithms to try and extract a possible set of causal relations.
3. This  network  represents  the  set  of  beliefs  extracted  by  the  data. It is then checked by an expert to eliminate links that are known to be in one direction or another, to add obvious links and eliminate impossible ones. This is the most important phase, the one in which expert knowledge is combined with knowledge extracted from the data.

Given this network we can make simulations, changing one variable and looking at what happens to the others. We can evaluate the effectiveness of public policies by predicting their effect; identifying the variables most likely involved in producing these effects.

## A New Scientific Revolution in Policymaking?

When sciences were born they were not even called sciences.  Philosophers used to also be physicists, mathematicians, chemists but also politicians, writers and artists.With time, disciplines have separated, they got their own identity, and kept evolving as different, in most of the cases without transferring knowledge from one to the other.  This has become the standard, the “traditional” approach in the sciences for a very long time.  Many disciplines and entire fields of study have been born in such a context.

Policymaking and social sciences in general have always been very complicated fields.  This is mainly due to their complexity, i.e. the fact that they try to tackle, to model, predict and influence systems made of a multitude of thinking agents, people, all with their own ideas, all influencing each other and being influenced from what surrounds them.

The  traditional  compartmentalised  approach,  of  course,  hardly  helps.   Each area of human activity is studied through specific disciplines, and policies are formulated according to each area of study.  However, it is apparent that too many policies fail to deliver, and in the worst cases exacerbate problems.  We Think that this is due to the fact that because of the structure of science and research in the last decades, they have not fully benefited from the knowledge developed in other fields of study.We think that to really understand the dynamics of these very complex systems, a multidisciplinary approach is needed.  

What is needed is to have people that are at the edge of different disciplines, at their intersection, and put them together with people that are experts in their own different fields, so that those people can work as a glue or a bridge, as a hub through which knowledge can be shared and everyone could benefit from each other’s knowledge.There is a great need for a return to the old ways but with the knowledge of the new ones, a more multidisciplinary approach with more scientific rigour on one side combined with expert knowledge on the other.

The one thing that would make it possible and so achievable is something that we have today in great abundance, and we didn’t have only a few years ago.This approach requires accurate information about the matter that one wants to study, (or to legislate on in the case of policymaking).  Today we have an unprecedented availability of data about the most diverse matters, and among them especially about people and their behaviour, which was something very difficult to collect before the digital era. Data must be the starting point of this approach, because only by studying the actual world, phenomena that actually happen, we can hope to understand them and use them to our benefit.

In the past, collecting data was a difficult and consuming process, thus every organisation  used  to  collect  data  on  their  own  and  retain  it  for  their  own purposes. Today we have an unprecedented amount of data at our disposal which comes for free from the internet.  Also, many organisations and governments understand the value of sharing their data, and they make them available online more and more everyday. This  big  amount  of  data  is  a  very  precious  source  of  information that can help us to uncover the hidden knowledge that we need to better understand and predict complicated social systems like nations, and that would allow us to make better and more effective policies.   

Choices  need  to  be  supported by data  about what  is  actually going  on, but then expert  knowledge must be combined with the data in order to produce mathematical models able to accurately predict the possible outcome of a particular choice. We want to be able to derive insights about citizens according to their different behaviour and demographics and discover the interplay between them, in order to produce policies tailored to specific groups of people.However, it’s not enough to simply analyse data without trying to understand the laws that govern the complex systems they describe.  

Data should be the means through which we understand the world and test our theories based on a scientific approach.  Data can help us to discover hidden possibilities, but then the goal is to be able to formulate theories and models that allow us to truly understand how these social systems work.

## MED-UCATION App
MED-UCATION (Medellín-Education) helps policymakers understand the cause-effect relationships between the main variables involved in the quality of education of Medellín's highschools.

The app uses a dataset of more than 50 thousand students that performed the Saber 11 examinations between 2004 and 2014. Based on the dataset a Bayesian Network can be built, where you can include expert knowledge about the cause-effect relationships between variables.

With the resulting network, you can simulate the outcome of new policies by changing the probability distribution of one variable and observing what happens with the probability distributions of the other variables.
