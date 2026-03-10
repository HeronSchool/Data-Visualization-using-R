# Data-Visualization-using-R
MySQL/Shiny Connection and Data Visualization

This project mainly focuses on the connection and visualization of MySQL data and R.
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
