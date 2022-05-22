Add_link <- as.data.table(matrix(c(input$from,input$to  #"ESTU_ESTRATO","PUNTAJE"
           ), ncol = 2, byrow = T))[,.(from = V1, to = V2)] # 'From' and 'to' are the names of the columns

White_list <- rbind(White_list,Add_link)
