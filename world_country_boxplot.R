library(shiny)
library(DBI)
library(RMariaDB)


# Connection
con <- dbConnect(
	RMariaDB::MariaDB(),
	dbname = "world",
	host = "localhost",
	port = 3306,
	user = "root",
	password = "000000"
)

# Data
country <- dbGetQuery(con, "SELECT * FROM country")
head(country)

numeric_cols <- names(country)[sapply(country, is.numeric)]

summary(country[, numeric_cols])

# UI
ui <- fluidPage(
	titlePanel("World Country 통계 분석"),

	sidebarLayout(
		sidebarPanel(
			selectInput("var", "변수 선택:", choices = numeric_cols)
		),
		mainPanel(
			h3("Summary"),
			verbatimTextOutput("summary"),
			h3("Boxplot"),
			plotOutput("boxplot")
		)
	)
)

# Server 동작
server <- function(input, output){
	
	selected_data <- reactive({
		country[[input$var]]
	})

	output$boxplot <- renderPlot({
		boxplot(selected_data(), col="skyblue", main=paste(input$var, "Boxplot"))
	})

}

# 앱 실행
shinyApp(ui = ui, server = server)


# 종료
dbDisconnect(con)
