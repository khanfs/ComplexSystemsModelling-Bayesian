
## Tell user ui script is beginning to run
print("UI function")

## This is the front-end of the app
fluidPage(theme = shinytheme("flatly"), #united, spacelab,flatly, yeti, simplex, sandstone
  #shinythemes::themeSelector(),  # <--- Add this somewhere in the UI
  navbarPage("MED-UCATION App",
    ## Home
    tabPanel("Home",
      sidebarPanel(
        h1("MED-UCATION App"),
        tags$hr(style="border-color: black;"),
        h4("MED-UCATION (Medellín-Education) helps policymakers understand the cause-effect relationships between the main variables involved in the quality of education of Medellín's highschools."),
        h4("The app uses a dataset of more than 50 thousand students that performed the Saber 11 examinations between 2004 and 2014."),
        h4("Based on the dataset a Bayesian Network can be built, where you can include expert knowledge about the cause-effect relationships between variables."),
        h4("With the resulting network, you can simulate the outcome of new policies by changing the probability distribution of one variable and observing what happens with the probability distributions of the other variables.")
      ),
      mainPanel(
        #imageOutput("image0")
        htmlOutput("image0"),
        h3("Instructions:"),
        h5("You can best use this app by going though the upper tabs from left to right:"),
        h5("1. Go to Student Data tab to see a small excerpt of the dataset used, where each row represents a different student. You can also download the dataset (which is stored in Amazon Web Services)."),
        h5("2. Go to Schools Map tab to visualize the geographical locations of the schools from which the students in the dataset belong."),
        h5("3. Go to Variables tab to see the variables of the model, and build a Correlation Matrix in order to visualize all correlations between variables."),
        h5("4. Go to Bayesian Network tab to build the Bayesian Network, where each node is a variable of the model. If you have expert knowledge about cause-effect relationships between variables, add the must-appear links in the whitelist and the must-not-appear links in the blacklist."),
        h5("5. Go to Probability Distributions tab to change the probability distribution of one variable (i.e. simulating a policy) and observe the effects on the probability distributions of the other variables. You need to follow the 6 steps sequentially.")
      )
    ),
    ## Display student data
    tabPanel("Student Data",
      mainPanel(
        h3("Student data"),
        tags$hr(style="border-color: black;"),
        h5("The dataset used contains information about more than 50 thousand Medellín highschool students from 2004 to 2014. Click the following link to download it:"),
        helpText(a("Download data",href="https://s3-us-west-2.amazonaws.com/cityknots-uploads/datos.icfes.csv",target="_blank")),
        h5("Click the following button to see a small excerpt of the dataset:"),
        actionButton("See_data", "Display data"),
        h3(textOutput("Display_data")),
        tableOutput("stu_data")
      )
    ),
    ## Schools Map
    tabPanel("Schools Map",
      sidebarPanel(
        h3("Schools Map"),
        tags$hr(style="border-color: black;"),
        h5("Build schools map:"),
        actionButton("Map", "Build schools map")
      ),
      mainPanel(
        plotOutput('Schools_map_plot')
      )
    ),
    ## Variables
    tabPanel("Variables",
      sidebarPanel(
        h3("Variables"),
        tags$hr(style="border-color: black;"),
        h5("These are the variables present in the dataset:"),
        tableOutput("List_of_variables"),
        tags$hr(style="border-color: black;"),
        h5("You can see the correlations between all variables in the correlation matrix:"),
        actionButton("Corr", "Build correlation matrix")
      ),
      mainPanel(
        h3(textOutput("Corr_text")),
        plotOutput('Correlation_plot')
      )
    ),
    ## Bayesian Network
    tabPanel("Bayesian Network",
      sidebarPanel(
        h3("Bayesian Network"),
        tags$hr(style="border-color: black;"),
        h5("Click the button below to build the network, make sure to go down and fill the Whitelist and Blacklist links according to the expert's knowledge cause-effect relationships."),
        actionButton("Build_network", "Build Network"),
        h5("Wait until it says ready:"),
        h4(textOutput("M_5")),
        tags$hr(style="border-color: black;"),
        h5("Add links to Whitelist or Blacklist:"),
        tabsetPanel(
          ## White list
          tabPanel("Whitelist",
            h5("This is the current Whitelist:"),
            tableOutput("White_list_display"),
            h5("Do you want to add a link to the current Whitelist?"),
            selectInput('w_from','From', names(Student_data), selected = "ESTU_ESTRATO"),
            selectInput('w_to','To', names(Student_data), selected = "PUNTAJE"),
            actionButton("w_Add_link", "Add link to current Whitelist"),
            h5("Do you want to erase the current Whitelist?"),
            actionButton("Erase_whitelist", "Erase current Whitelist")
          ),
          ## Blacklist
          tabPanel("Blacklist",
            h5("This is the current Blacklist:"),
            tableOutput("Black_list_display"),
            h5("Do you want to add a link to the current Blacklist?"),
            selectInput('b_from','From', names(Student_data), selected = "PUNTAJE"),
            selectInput('b_to','To', names(Student_data), selected = "ESTU_ESTRATO"),
            actionButton("b_Add_link", "Add link to current Blacklist"),
            h5("Do you want to erase the current Blacklist?"),
            actionButton("Erase_blacklist", "Erase current Blacklist")
          )
        )
     ),
      mainPanel(
        h3(textOutput("Bay_text")),
        plotOutput('Bayesian_network_plot'),
        h4(textOutput("M_6")),
        h5(textOutput("M_7")),
        h5(textOutput("M_8"))
      )
    ),
    ## Probability distributions
    tabPanel("Probability Distributions",
      sidebarPanel(
        h3("Probability Distributions"),
        tags$hr(style="border-color: black;"),

        h5("In this section, you can change the probability distribution of one variable (i.e. simulating a policy) and observe the effects on the probability distributions of the other variables. For this purpose, do the following procedure sequentially:"),
        h5("1. Calculate Bayesian network internal parameters (the Bayesian network must be already built):"),
        actionButton("Parameters", "Calculate"),
        h5("Wait (30 secs or less) until it says ready:"),
        h4(textOutput("M_1")),
        tags$hr(style="border-color: black;"),

        h5("2. Choose variable for which distribution is changed:"),
        selectInput('var','Variable', names(Student_data), selected = "ESTU_ESTRATO"),
        actionButton("Choose_var", "Choose"),
        h5("Wait until it says ready:"),
        h4(textOutput("M_2")),
        tags$hr(style="border-color: black;"),

        h5("3. Download a CSV file of the chosen variable, containing its current probability distribution and blank space for filling its new desired probability distribution (i.e. outcome of the new policy):"),
        downloadButton("downloadData", "Download"),
        h5("*Note: be careful in not overwriting it is preferable to do not overwrite other CSV files!"),
        tags$hr(style="border-color: black;"),

        h5("4. Upload a CSV file of the chosen variable, containing its current and new probability distributions:"),
        fileInput("file1", "Choose CSV File",
          accept = c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv")
        ),
        h5("Wait until it says ready:"),
        h4(textOutput("M_3")),
        tags$hr(style="border-color: black;"),

        h5("5. Choose variables for which the current and new probability distributions will be visualized (don't tick the chosen variable whose distribution was changed initially):"),
        checkboxGroupInput("Choose_vars", "Variables to visualize:", choices = names(Student_data)),
        tags$hr(style="border-color: black;"),

        h5("6. See distributions:"),
        actionButton("Distributions", "Go"),
        h5("Wait (near 30 secs per chosen variable to visualize) until it says ready:"),
        h4(textOutput("M_4"))
      ),
      mainPanel(
        h3(textOutput("CSV")),
        tableOutput("contents"),
        h3("Probability distributions of variables to visualize:"),
        tabsetPanel(
          tabPanel("Distributions",
            plotOutput('Distributions_plot',width = "80%",height = Plot_height_1)
          ),
          tabPanel("Differences",
            plotOutput('Delta_punteggi',width = "80%",height = Plot_height_2)
          )
        )      
      )
    )
  )
)

