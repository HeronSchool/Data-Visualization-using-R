library(RMariaDB)
library(shiny)
library(ggplot2)
library(plotly)

# DB Connection
con <- dbConnect(
  RMariaDB::MariaDB(),
  dbname = Sys.getenv("DB_NAME"),
  host = Sys.getenv("DB_HOST"),
  port = as.numeric(Sys.getenv("DB_PORT")),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD")
)

ui <- fluidPage(
  titlePanel("World Country Statistics Summary"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("continent_select"),
      uiOutput("var_select"),
      uiOutput("xvar_select"),
      uiOutput("yvar_select")
    ),

    mainPanel(
      h3("Summary"),
      verbatimTextOutput("summary"),
      
      h3("Boxplot"),
      plotOutput("boxplot"),

      h3("Scatter Plot"),
      plotlyOutput("scatterplot"),
    )
  )
)

server <- function(input, output, session){
  # DB data
  country <- reactive({
    dbGetQuery(con, "SELECT * FROM country")
  })
  
  # variables
  numeric_cols <- reactive({
    names(country())[sapply(country(), is.numeric)]
  })

  ####################### RIGHT PANEL - sidebarLayout
  # UI select input
  output$continent_select <- renderUI({
    req(country())
    continents <- unique(country()$Continent)
    selectInput("continent", "Select Continent:", 
                choices = c("All", continents))
  })

  output$var_select <- renderUI({
    req(numeric_cols())
    selectInput("var", "Select variable:", choices = numeric_cols())
  })
  
  output$xvar_select <- renderUI({
    req(numeric_cols())
    selectInput("xvar", "X variable:", choices = numeric_cols(),
                selected = numeric_cols()[1])
  })

  output$yvar_select <- renderUI({
    req(numeric_cols())
    selectInput("yvar", "Y variable:", choices = numeric_cols(),
                selected = numeric_cols()[2])
  })

  # continent filter
  filtered_data <- reactive({
    req(country())
    req(input$continent)
    if (input$continent == "All"){
      country()
    } else {
      country()[country()$Continent == input$continent, ]
    }
  })
  
  # selected data
  selected_data <- reactive({
    req(input$var)
    filtered_data()[[input$var]]
  })

  ####################### LEFT PANEL - mainPanel
  # summary
  output$summary <- renderPrint({
    summary(selected_data())
  })
  
  # plot
  output$boxplot <- renderPlot({
    df <- data.frame(value = selected_data())

    ggplot(df, aes(y = value)) +
    geom_boxplot(fill = "skyblue") +
    ggtitle(paste(input$var, "Boxplot")) +
    theme_minimal()
  })

  # scatter plot
  output$scatterplot <- renderPlotly({
    req(input$xvar, input$yvar)
    
    df <- filtered_data()
    p <- ggplot(df, aes(x = .data[[input$xvar]], y = .data[[input$yvar]], color = Continent)) +
	   geom_point(size = 3, alpha = 0.7) +
	   theme_minimal() +
	   ggtitle(paste(input$yvar, "vs", input$xvar)) +
	   xlab(input$xvar) +
	   ylab(input$yvar)
    ggplotly(p)
  })

}

# Execute
shinyApp(ui = ui, server = server)
