# Data-Visualization-using-R
## World Country Statistics Dashboard

This project is an interactive data visualization dashboard built with **R Shiny**.  
It connects to a **MySQL database** and allows users to explore global country statistics such as population, life expectancy, and economic indicators.

Users can filter data by continent and visualize relationships between variables through boxplots, scatter plots, and an interactive world map.

## Purpose

This project was created to practice building an interactive data dashboard using R Shiny and integrating it with a relational database.

## Features

- Connects to a MySQL database using RMariaDB
- Filter countries by continent
- Summary statistics of selected variables
- Boxplot visualization
- Interactive scatter plot using Plotly
- World map visualization with country-level markers

## Tech Stack

- R
- Shiny
- Plotly
- ggplot2
- MariaDB / MySQL
- DBI

## Dataset

The dashboard uses the **MySQL World Database**, which contains information about countries including:

- Country name
- Continent
- Population
- Life expectancy
- Surface area
- GNP

Source:
https://dev.mysql.com/doc/world-setup/en/

## How to Run

1. Install required R packages

```r
install.packages(c("shiny","DBI","RMariaDB","ggplot2","plotly"))

2. Import the MySQL World Database.

3. Update database connection information in the code.
host, user, password

4. Run the application
```r
shinyApp(ui = ui, server = server)

### Project Structure
project/
├── world_country_boxplot.R
├── README.md
└── data/

## Screenshot

Dashboard Interface
<img width="1877" height="807" alt="image" src="https://github.com/user-attachments/assets/c118f424-1662-4e97-a6bc-8f571d82d5c0" />

Scatter Plot Example
<img width="1266" height="567" alt="image" src="https://github.com/user-attachments/assets/fb9fcbee-3c09-4d71-acff-223a269efb95" />

World Map Visualization



To test this program, 2 steps are needed:
1. Set up MySQL workbench and create a table. (Ex. world)
3. Run the R project.
Then you can test if the visualization is properly working.

## MySQL workbench Setting
When setting up a MySQL workbench, you need to check the host, port, user, password and dbname.

## R Setting
First, Inside the world_country_boxplot.R file, change the `dbname`, `host`, `port`, `user`, `password` of `con` variable according to your setting. Then you can run the Project and see how the boxplot is shown while changing the choice of the input of Shiny layout.

## Result
<img width="1877" height="807" alt="image" src="https://github.com/user-attachments/assets/c118f424-1662-4e97-a6bc-8f571d82d5c0" />
<img width="1266" height="567" alt="image" src="https://github.com/user-attachments/assets/fb9fcbee-3c09-4d71-acff-223a269efb95" />

### reference
- [1]https://dev.mysql.com/doc/index-other.html
