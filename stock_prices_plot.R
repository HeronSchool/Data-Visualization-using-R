con <- dbConnect(
  RMariaDB::MariaDB(),
  dbname = "",
  host = "",
  user = "",
  password = ""
)

ui <- fluidPage(
  titlePanel("Stock Market Dashboard"),

  sidebarLayout(
    sidebarPanel(
      selectInput(
        "variable",
        "Select Price Type",
        choices = c("open", "high", "low", "close", "adjusted")
      )
    ),
    mainPanel(
      h3("Price Chart"),
      plotlyOutput("price_plot"),
      
      h3("Return Distribution"),
      plotOutput("return_plot")
    )
  )
)

server <- function(input, output){
  stock_data <- reactive({
    dbGetQuery(con, "SELECT * FROM stock_prices")
  })

  returns <- reactive({
    df <- stock_data()
    # log(오늘가격)-log(어제가격)=log(오늘가격/어제가격)
    df$return <- c(NA, diff(log(df$close))) 
    df
  })

  output$price_plot <- renderPlotly({
    df <- stock_data()
    p <- ggplot(df, aes(x=date, y=.data[[input$variable]]))+
    geom_line(color="blue")+
    theme_minimal()
    ggplotly(p)
  })

  output$return_plot <- renderPlot({
    df <- returns()
    ggplot(df, aes(x=return))+
    geom_histogram(bins=50, fill="skyblue")+
    theme_minimal()
  })
}

shinyApp(ui, server)
