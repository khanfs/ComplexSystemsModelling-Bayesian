## Tell user server script is beginning to run
print("Server function")

## This is the back-end of the app
shinyServer(function(input,output,session) {
  ## This code is for stopping the app when closing the session. In this way
  ## the app will restart again in every new browser session
  session$onSessionEnded({
    stopApp   
  })
  
  ## Home
  output$image0 <- renderText({c('<img src="',src,'">')})

  ## Display student data
  observeEvent(input$See_data,{
    output$Display_data <- renderText({
      return("Small excerpt of the dataset:")
    })
    output$stu_data <- renderTable({
      Student_data_distributions[1:40,]
    })
  })

  ## Schools map
  observeEvent(input$Map,{
    source('map.R')
    output$Schools_map_plot <- renderPlot({
      plot(medellin.map + geom_point(aes(x = LON, y = LAT, colour = SECTOR), data = Directorio_main))
    })
  })
  
  ## Variables
  output$List_of_variables <- renderTable({
    dataframe_vars <- data.frame(names(Student_data_variables))
    colnames(dataframe_vars) <- c("Variables")
    return(dataframe_vars)
  })
  
  observeEvent(input$Corr,{
    output$Corr_text <- renderText({
      return("Correlation Matrix:")
    })
    output$Correlation_plot <- renderPlot({
      corrplot::corrplot(cor(na.omit(Student_data_variables[,.SD,.SDcols = sapply(Student_data, is.numeric)])),order="FPC", col = viridis(100),tl.col="black") #
    })
  })
  
  ## --- Whitelist
  
  ## Add link reactive variable, used for adding a link to the whitelist
  w_Add_this_link <- reactive({
    return(as.data.table(matrix(c(as.character(input$w_from),as.character(input$w_to)), ncol = 2, byrow = T))[,.(from = V1, to = V2)]) # 'From' and 'to' are the names of the columns
  })
  
  ## Whitelist reactive variable
  w_Count_erase <<- 0
  w_Count_add <<- 0
  White_list_reactive <- eventReactive(c(input$w_Add_link,input$Erase_whitelist), {
    ## Return initial Whitelist in first run of the function
    if(input$w_Add_link==0 & input$Erase_whitelist==0) {
      return(White_list) 
    }
    
    ## Add link case
    if (w_Count_erase == as.numeric(input$Erase_whitelist)) {
      w_Count_add <<- w_Count_add + 1
      if(as.character(White_list[1,1])=="" | as.character(White_list[1,2])=="") {
        White_list[1,1] <<- as.character(input$w_from)
        White_list[1,2] <<- as.character(input$w_to)
        return(White_list)
      }
      else{
        White_list <<- rbind(White_list,w_Add_this_link())
        return(White_list)
      }
    }
    
    ## Erase link case
    if (w_Count_add == as.numeric(input$w_Add_link)) {
      w_Count_erase <<- w_Count_erase + 1
      White_list <<- as.data.table(matrix(c("",""), ncol = 2, byrow = T))[,.(from = V1, to = V2)] # 'From' and 'to' are the names of the columns
      return(White_list)
    }
  })
  
  ## Display whitelist on screen
  output$White_list_display <- renderTable({
    return(White_list_reactive())
  })
  

  ## --- Blacklist
  
  ## Add link reactive variable, used for adding a link to the blacklist
  b_Add_this_link <- reactive({
    return(as.data.table(matrix(c(as.character(input$b_from),as.character(input$b_to)), ncol = 2, byrow = T))[,.(from = V1, to = V2)]) # 'From' and 'to' are the names of the columns
  })
  
  ## Blacklist reactive variable
  b_Count_erase <<- 0
  b_Count_add <<- 0
  Black_list_reactive <- eventReactive(c(input$b_Add_link,input$Erase_blacklist), {
    ## Return initial Blacklist in first run of the function
    if(input$b_Add_link==0 & input$Erase_blacklist==0) {
      return(Black_list) 
    }
    
    ## Add link case
    if (b_Count_erase == as.numeric(input$Erase_blacklist)) {
      b_Count_add <<- b_Count_add + 1
      if(as.character(Black_list[1,1])=="" | as.character(Black_list[1,2])=="") {
        Black_list[1,1] <<- as.character(input$b_from)
        Black_list[1,2] <<- as.character(input$b_to)
        return(Black_list)
      }
      else{
        Black_list <<- rbind(Black_list,b_Add_this_link())
        return(Black_list)
      }
    }
    
    ## Erase link case
    if (b_Count_add == as.numeric(input$b_Add_link)) {
      b_Count_erase <<- b_Count_erase + 1
      Black_list <<- as.data.table(matrix(c("",""), ncol = 2, byrow = T))[,.(from = V1, to = V2)] # 'From' and 'to' are the names of the columns
      return(Black_list)
    }
  })
  
  ## Display blacklist on screen
  output$Black_list_display <- renderTable({
    return(Black_list_reactive())
  })  
  
  
  ## --- Build the network
  observeEvent(input$Build_network,{
    source('build_network.R', local = FALSE)
    output$Bay_text <- renderText({
      return("Bayesian Network:")
    })
    output$Bayesian_network_plot <- renderPlot({
      source('strength_plot.R',local = TRUE)
      #g <- strength.plot(BN.hc,BN.hc.str,shape = "ellipse",layout = "dot")
      #plot(g, attrs=list(node=list(fillcolor="lightgreen",shape = "ellipse",fixedsize = FALSE), edge=list(color="blue"), graph=list()))
    })
    output$M_5 <- renderText({
      return("Ready!")
    })
    output$M_6 <- renderText({
      return(paste("The network score is: ",as.character(format(Score,digits=8)),sep=''))
    })
    output$M_7 <- renderText({
      return("*Note #1: the score is equal to the negative of the Bayesian Information Criterion of the network. The bigger the score, the better the network!")
    })
    output$M_8 <- renderText({
      return("*Note #2: the weight of each link is defined as the natural logarithm of the magnitude of the score's loss which would be caused by the link's removal. The bigger the value, the more important the link is!")
    }) 
  })

    
  ## --- Probability distributions
  ## Calculate network parameters
  observeEvent(input$Parameters,{
    source('network_parameters.R')
    output$M_1 <- renderText({
      return("Ready!")
    })
  })
  
  ## Choose variable and calculate its probabilities
  observeEvent(input$Choose_var,{
    print('Choose variable and calculate its probability distribution')
    ## Define a variable (Root variable) for which I have a known distribution (that Policymakers can change)
    Root_variable <<- as.character(input$var)

    ## Get distribution of Root_variable (Root_variable.prob is a data.table) from the data and assign it in the column current
    Root_variable.prob <<- prob(Student_data_distributions,Root_variable) ## Calculates probabilities of different bins/classes of the root variable, which add to 1

    ## Create a new distribution that is the outcome of a new policy
    setnames(Root_variable.prob,"new","current") ## Change column name from 'new' to 'current'
    Root_variable.prob$new <<- as.numeric(rep(0.0,nrow(Root_variable.prob)))

    output$M_2 <- renderText({
      return("Ready!")
    })    
  })
  
  ## Download CSV file
  output$downloadData <- downloadHandler(
    filename = paste("probability_distributions","csv", sep = "."),
    content = function(file_path) {
      write.csv(Root_variable.prob, file_path, row.names = FALSE)
    },
    contentType = "text/csv"
  )
  
  ## Upload CSV file
  observeEvent(input$file1,{
    output$CSV <- renderText({
      return("New probability distribution of chosen variable from CSV file:")
    })
    output$M_3 <- renderText({
      return("Ready!")
    }) 
  })
  
  Root_variable.prob_reactive <- eventReactive(input$file1,{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1

    if (is.null(inFile)) {
      return(NULL)
    } else {
      return(read.csv(inFile$datapath)) #, header = input$header
    }
  })
  
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)
    #read.csv("estu.csv")
    read.csv(inFile$datapath)
  })
  
  ## Build plots
  observeEvent(input$Distributions,{
    source('distributions.R',local = TRUE) ## False -> File sourced in global environment
    
    output$Distributions_plot <- renderPlot({
      Plot_height_1 <<- as.character(paste(as.character(350*(length(Variables_to_visualize)+1)),"px",sep = ""))

      plots <- list()
      
      events <- as.character(Root_variable.prob[[1]])
      events_joined=c(events,events)
      type=c(rep("Current",length(events)),rep("New",length(events)))
      value=c(Root_variable.prob[[2]],Root_variable.prob[[3]])
      data=data.frame(events_joined,type,value)
      plots[[1]] <- ggplot(data, aes(x=events_joined, y=value, fill=type)) + geom_bar(position="dodge", stat="identity") +
          ggtitle(paste("Probability distribution of",Root_variable, sep = " ")) + xlab(paste(Root_variable, sep = " ")) + ylab("Probability")
      
      for(i in 1:length(Variables_to_visualize)) {
        Temp_var <- Variables_to_visualize.prob[[i]]
        events <- as.character(Temp_var[[1]])
        events_joined=c(events,events)
        type=c(rep("Current",length(events)),rep("New",length(events)))
        value=c(Temp_var[[2]],Temp_var[[3]])
        data=data.frame(events_joined,type,value)
        plots[[i+1]] <- ggplot(data, aes(fill=type, y=value, x=events_joined)) + geom_bar(position="dodge", stat="identity") +
            ggtitle(paste("Probability distribution of",Variables_to_visualize[i], sep = " ")) + xlab(paste(Variables_to_visualize[i], sep = " ")) + ylab("Probability")
      }
      multiplot(plotlist = plots, cols = 1)
    })
    
    output$Delta_punteggi <- renderPlot({
      Plot_height_2 <<- as.character(paste(as.character(350*(length(Variables_to_visualize)+1)),"px",sep = ""))

      plots <- list();

      events_joined <- as.character(Root_variable.prob[[1]])
      type=c(rep("Difference",length(events_joined)))
      value= Root_variable.prob[[3]] - Root_variable.prob[[2]]
      data=data.frame(events_joined,type,value)
      plots[[1]] <- ggplot(data, aes(y=value, x=events_joined)) + geom_bar(position="dodge", stat="identity") +
          ggtitle(paste("Probability difference distribution of",Root_variable, sep = " ")) + xlab(paste(Root_variable, sep = " ")) + ylab("Probability difference")
      
      for(i in 1:length(Variables_to_visualize)) {
        Temp_var <- Variables_to_visualize.prob[[i]]
        print(Temp_var)
        events_joined <- as.character(Temp_var[[1]])
        print(events_joined)
        type=c(rep("Difference",length(events_joined)))
        value= Temp_var[[3]] - Temp_var[[2]]
        data=data.frame(events_joined,type,value)
        plots[[i+1]] <- ggplot(data, aes(y=value, x=events_joined)) + geom_bar(position="dodge", stat="identity") +
            ggtitle(paste("Probability difference of",Variables_to_visualize[i], sep = " ")) + xlab(paste(Variables_to_visualize[i], sep = " ")) + ylab("Probability difference")
      }
      multiplot(plotlist = plots, cols = 1)
    })
    output$M_4 <- renderText({
      return("Ready!")
    }) 
  })
})