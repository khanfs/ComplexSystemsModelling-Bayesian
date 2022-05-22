#setnames(Root_variable.prob,"new","current") ## Change column name from 'new' to 'current'


Root_variable.prob_re <- as.data.table(Root_variable.prob_reactive())
Root_variable.prob_re[[1]] <- as.factor(Root_variable.prob_re[[1]])
Root_variable.prob_re$new <- as.numeric(Root_variable.prob_re$new)
Root_variable.prob_re$current <- as.numeric(Root_variable.prob_re$current)
Root_variable.prob[[3]] <- Root_variable.prob_re[[3]]

# print(Root_variable.prob_re)
# print(class(Root_variable.prob_re))
# print(class(Root_variable.prob_re[[1]]))
# print(class(Root_variable.prob_re[[2]]))
# print(class(Root_variable.prob_re[[3]]))
# print(class(Root_variable.prob_re$new))
# print(class(Root_variable.prob))
# print(class(Root_variable.prob[[1]]))
# print(class(Root_variable.prob[[2]]))
# print(class(Root_variable.prob[[3]]))
# print(class(Root_variable.prob$new))
# print(Root_variable.prob)

assign("Variables_to_visualize", input$Choose_vars, envir = .GlobalEnv)
Variables_to_visualize.prob <- propagate(Student_data_distributions,BN.hc.parameters,Variables_to_visualize,Root_variable.prob)

print(Variables_to_visualize.prob[[1]])
print(class(Variables_to_visualize.prob[[1]]))


