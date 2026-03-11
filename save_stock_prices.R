library(RMariaDB)
library(quantmod)

# MySQL connect
con <- dbConnect(
  RMariaDB::MariaDB(),
  dbname = "stockdb",
  host = "localhost",
  user = "root",
  password = "000000"
)

# ticker
ticker <- "AAPL"

# data download
# This command will automatically download Apple's stock data 
# and create an object named AAPL in your R environment.
getSymbols(ticker, src="yahoo")

stock_data <- data.frame(
  date = index(AAPL),
  coredata(AAPL)
)

head(stock_data)

# column names
colnames(stock_data) <- c("date", "open", "high", "low", "close", "volume", "adjusted")

# MySQL save
dbWriteTable(con, "stock_prices", stock_data, overwrite=TRUE)

#dbDisconnect(con)
