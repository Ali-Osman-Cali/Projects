###########################################################
###########################################################

## Manipulate R data frames using SQL in RStudio

###########################################################
###########################################################

###########################################################
## Task One: Getting Started
## Install and import the required 
## packages for this project.
###########################################################


## 1.1: Installing the required packages

install.packages("sqldf")
install.packages("gapminder")

## 1.2: Importing required packages

library(sqldf)
library(gapminder)

###########################################################
## Task Two: Import and explore the data sets
## Load and explore the gapminder 
## and the UCBAdmissions data sets for this project.
###########################################################

## 2.1: Load the required data sets

gapminder
UCBAdmissions

## 2.2: Change UCBAdmissions to a data frame

ucb <- as.data.frame(UCBAdmissions)
ucb

## 2.3: View, check the dimension, the column names,
## and the structure of the gapminder data

View(gapminder)
dim(gapminder)
names(gapminder)
str(gapminder)

## 2.4: View, check the dimension, the column names,
## and the structure of the ucb data

View(ucb)
dim(ucb)
names(ucb)
str(ucb)

###########################################################
## Task Three: SQL SELECT and FROM statements
## Use the SELECT and FROM statements
## to query the gapminder data 
###########################################################

## 3.1: Retrieve all the data from gapminder


data <- sqldf( 'SELECT * FROM gapminder')


## 3.2: Retrieve the country column from gapminder


View(sqldf('SELECT country FROM gapminder'))


## 3.3: Retrieve the country and continent column from gapminder


country_continent <- sqldf('SELECT country, continent FROM gapminder')


## 3.4: Retrieve the first 5 countries and continents


head(country_continent, 5)


## 3.5: Retrieve the first 5 countries and continents


sqldf('SELECT country,continent FROM gapminder LIMIT 5 ')


## 3.6: Retrieve the first ten rows from gapminder. Sort the result
## by country in ascending and lifeExp in descending order


sqldf('SELECT * FROM gapminder ORDER BY country ASC, lifeExp DESC LIMIT 10 ')


## 3.7: Retrieve the different continents without duplicates


sqldf('SELECT DISTINCT (continent) FROM gapminder')


###########################################################
## Task Four: WHERE and SQL Operators - I
## learn how to set conditions on the 
## result set using the WHERE clause with SQL operators
###########################################################

## 4.1: Retrieve all gapminder data for United States


sqldf('SELECT * FROM gapminder WHERE country = "United States"')


## 4.2: Retrieve all gapminder data for United States in 2002


sqldf('SELECT * FROM gapminder WHERE country = "United States" AND year= 2002')


## 4.3: Retrieve all gapminder data for United States or Canada


sqldf('SELECT * FROM gapminder WHERE country = "United States" OR country = "Canada"')


## 4.4: Retrieve all ucb data for all admitted males or females


sqldf('SELECT * FROM ucb WHERE Admit = "Admitted" AND (Gender = "Male" OR Gender = "Female")')


## 4.5: Retrieve all ucb data for department A, B, or C


sqldf('SELECT * FROM ucb WHERE Dept = "A" OR Dept = "B" OR Dept ="C"')


## Alternative solution


sqldf('SELECT * FROM ucb WHERE Dept IN ("A", "B", "C")')


## 4.7: Retrieve all ucb data not in department A, B, or C


sqldf('SELECT * FROM ucb WHERE Dept NOT IN ("A", "B", "C")')


###########################################################
## Task Five: WHERE and SQL Operators - II
## Learn how to set conditions on the 
## result set using the WHERE clause with SQL operators
###########################################################

## 5.1: Retrieve all gapminder data for the 
## years 1997, 2002, or 2007


sqldf('SELECT * FROM gapminder WHERE year IN (1997,2002,2007)')


## Exercise 5.2: Retrieve all gapminder data not in the 
## years 1997, 2002, or 2007


sqldf('SELECT * FROM gapminder WHERE year NOT IN (1997,2002,2007)')


## 5.2: Retrieve all ucb data where the admission frequency 
## is between 20 and 100


sqldf('SELECT * FROM ucb WHERE freq BETWEEN 20 AND 100')


## 5.3: Retrieve all ucb data where the admission frequency 
## is not between 1 and 100


sqldf('SELECT * FROM ucb WHERE freq NOT BETWEEN 20 AND 100')


## 5.4: Retrieve all ucb data where the admission frequency 
## is not equal 100


sqldf('SELECT * FROM ucb WHERE Freq != 100')


## 5.5: Retrieve all ucb data where the admission frequency 
## is greater than 100


sqldf('SELECT * FROM ucb WHERE Freq > 100')


## 5.6: Retrieve all ucb data for all females and
## where the admission frequency is greater than or equal to 100


sqldf("SELECT * FROM ucb WHERE Gender = 'Female' AND Freq >= 100")


## 5.7: Retrieve all ucb data for all males and
## where the admission frequency is less than 100


sqldf("SELECT * FROM ucb WHERE Gender = 'Male' AND Freq <= 100")


## 5.8: Check if there is any missing value in the Freq variable


sqldf("SELECT * FROM ucb WHERE Freq IS NULL")


###########################################################
## Task Six: Wildcard Characters
## Learn how to use SQL wildcard 
## characters in the WHERE clause
###########################################################

## 6.1: Retrieve all gapminder data for countries that 
## starts with Mal


sqldf('SELECT * FROM gapminder WHERE country LIKE "Mal%"')


## 6.2: Retrieve all gapminder data for countries that 
## starts with Si


sqldf('SELECT * FROM gapminder WHERE country LIKE "Si%"')


## 6.3: Retrieve all gapminder data for countries that 
## ends with in


sqldf('SELECT * FROM gapminder WHERE country LIKE "%in"')


## 6.4: Retrieve countries that 
## ends with in. The result should not contain duplicates


sqldf('SELECT DISTINCT(country) FROM gapminder WHERE country LIKE "%in"')


## 6.5: Retrieve all gapminder data for countries that 
## ends with an


sqldf('SELECT DISTINCT(country) FROM gapminder WHERE country LIKE "%an"')


## 6.6: Retrieve all gapminder data for countries that 
## don't ends with ia

sqldf('SELECT DISTINCT(country) FROM gapminder WHERE country NOT LIKE "%ia"')


##########################################################
## Task Seven: Aggregating Data
## Learn how to use SQL aggregate 
## functions to aggregate and summarize data
###########################################################

## 7.1: Find the average life expectancy


sqldf('SELECT AVG(lifeExp) AS average_lifeExp FROM gapminder')


## 7.2: Find the average life expectancy for different continents


sqldf('SELECT continent, AVG(lifeExp) AS average_lifeExp FROM gapminder GROUP BY continent')



## 7.3: Order by the average life expectancy in descending order


sqldf('SELECT continent, AVG(lifeExp) AS avg_salary FROM gapminder
      GROUP BY continent
      ORDER BY avg_salary DESC')


## 7.4: Find the number of countries in each continent


sqldf('SELECT continent, COUNT(country) continent_count FROM gapminder
      GROUP BY continent')


## 7.5: Which department had the most admitted students?


sqldf('SELECT Dept FROM ucb WHERE Freq = (SELECT MAX(Freq) FROM ucb WHERE Admit="Admitted")')


## 7.6: Find the total number of admitted students as total_admit


sqldf('SELECT SUM(Freq) AS total_admit FROM ucb 
      WHERE Admit = "Admitted"')


## 7.7: Find the total number of admitted male
## students as total_admit


sqldf('SELECT SUM(Freq) AS total_admit FROM ucb 
      WHERE Admit = "Admitted" AND Gender = "Male"')


## 7.8: Which department had the lowest admitted Female student?


sqldf('SELECT Dept FROM ucb 
      WHERE Freq = (SELECT MIN(Freq) FROM ucb WHERE Admit="Admitted" AND Gender= "Female")')



#################################################################
##-------------------------------------------------------------##
##                           THANK YOU
##-------------------------------------------------------------##
#################################################################
