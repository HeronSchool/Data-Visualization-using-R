library(shiny)
library(DBI)
library(RMariaDB)
library(ggplot2)
library(plotly)
# update.packages(ask = FALSE)

# Connection
con <- DBI::dbConnect(
  RMySQL::MySQL(),
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
      plotly::plotlyOutput("scatterplot"),

      h3("World Map"),
	plotly::plotlyOutput("worldmap")
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
    names(country())[sapply(country(), is.numeric)] # numeric columns
  })

  ############################ RIGHT PANEL
  # UI select input
  output$continent_select <- renderUI({
    req(country())
    continents <- unique(country()$Continent) # continents
    selectInput("continent", "Select Continent:", choices = c("All", continents))
  })

  output$var_select <- renderUI({
    req(numeric_cols())
    selectInput("var", "Select variable:", choices = numeric_cols())
  })

  output$xvar_select <- renderUI({
    req(numeric_cols())
    selectInput(
      "xvar",
      "X variable:",
      choices = numeric_cols(),
      selected = numeric_cols()[1]
    )
  })

  output$yvar_select <- renderUI({
    req(numeric_cols())
    selectInput(
      "yvar",
      "Y variable:",
      choices = numeric_cols(),
      selected = numeric_cols()[2]
    )
  
  })

  # continent filter
  filtered_data <- reactive({
    req(country())
    req(input$continent)
    if (input$continent == "All") {
      df <- country()
    } else {
      df <- country()[country()$Continent == input$continent, ]
    }
    return df
  })

  # selected data
  selected_data <- reactive({
    req(input$var)
    filtered_data()[[input$var]]
  })

  ############################ LEFT PANEL
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
  output$scatterplot <- renderPlotly({ # renderPlot({
   
    req(input$xvar, input$yvar)
    
    df <- filtered_data()

    p <- ggplot(df, aes_string(x = input$xvar, y = input$yvar, color = "Continent")) +
      geom_point(size = 3, alpha = 0.7) +
      theme_minimal() + 
      ggtitle(paste(input$yvar, "vs", input$xvar)) +
      xlab(input$xvar) +
      ylab(input$yvar)

    ggplotly(p)
  })

  # map plot
  output$worldmap <- renderPlotly({

    df <- filtered_data()

    plot_ly(
      data = df,
      type = "scattergeo",
      mode = "markers",
      locations = ~Code,
	color = ~Continent,
      text = ~paste(
        "Country:", Name,
        "<br>Population:", Population,
        "<br>Life Expectancy:", LifeExpectancy
      ),
      marker = list(
  	  size = ~sqrt(Population)/100,
	  color = ~Continent,
  	  opacity = 0.7
	)
    ) %>%
    layout(
      title = "World Population Map",
      geo = list(
        showland = TRUE,
        landcolor = rgb(240, 240, 240),
        showframe = FALSE)
    )
  })

# 앱 실행
shinyApp(ui = ui, server = server)


# 종료
dbDisconnect(con)
