# Data-Visualization-using-R
MySQL/Shiny Connection and Data Visualization

This project mainly focuses on the connection and visualization of MySQL data and R.
To test this program, 2 steps are needed:
1. Set up MySQL workbench and create a table. (Ex. world)
3. Run the R project.
Then you can test if the visualization is properly working.

## MySQL workbench Setting
When setting up a MySQL workbench, you need to check the host, port, user, password and dbname.

![KakaoTalk_20260112_162746161](https://github.com/user-attachments/assets/2a75db57-a46e-4870-b8bd-8f39f7b01507)

## R Setting
First, Inside the world_country_boxplot.R file, change the dbname, host, port, user, password of con variable according to your setting. Then you can run the Project and see how the boxplot is shown while changing the choice of the input of Shiny layout.

## Result
<img width="1906" height="748" alt="image" src="https://github.com/user-attachments/assets/66c9be12-4842-4836-ba5d-e675fca49b98" />

### reference
- [1]https://dev.mysql.com/doc/index-other.html
