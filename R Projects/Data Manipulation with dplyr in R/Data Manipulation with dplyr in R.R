
###########################################################
###########################################################

## Data Manipulation with dplyr in R

###########################################################

###########################################################
## Task One: Getting Started & About tidyverse
## Understand what the tidyverse package 
## does and install the required packages for this project
###########################################################

## 1.1: Install the dplyr and the gapminder packages

install.packages("dplyr")
install.packages("gapminder")


###########################################################
## Task Two: Import packages & dataset 
## Load the required package and dataset
## into the R workspace. Also, explore the dataset
###########################################################

## 2.1: Load the dplyr and the gapminder packages


library(dplyr)
library(gapminder)


## 2.2: Look at the gapminder dataset


View(gapminder)


## 2.3: Check the structure of the dataset


str(gapminder)
dim(gapminder)


###########################################################
## Task Three: The Select Verb
## Learn how to use the select verb
## to retrieve columns of the dataset
###########################################################

## 3.1: Select the country and continent columns


select(gapminder,country,continent)
  

## 3.2: Store the result of 3.1 in a variable called country_con


country_con <- gapminder %>% select(country,continent)


## 3.3: Print out the variable


print(country_con)


###########################################################
## Task Four: The Filter Verb
## Learn how to use the filter verb
## to retrieve rows of columns of the dataset
###########################################################

## 4.1: Filter the gapminder dataset for the year 1962


filter(gapminder,year == 1962)


## 4.2: Filter for China in 2002


gapminder %>% filter(country == 'China',year == 2002)


###########################################################
## Task Five: The Arrange Verb
## Learn how to use the arrange verb
## to sort the result of a column
###########################################################

## 5.1: Sort in ascending order of lifeExp


gapminder %>% arrange(lifeExp)


## 5.2: Sort in descending order of lifeExp and 
## select the top fifteen


gapminder %>% arrange(desc(lifeExp)) %>% head(15)


#% 5.3: Filter for the year 1962, 
## then arrange in descending order of population


gapminder %>% filter(year == 1962) %>% arrange(desc(pop))
  
  

###########################################################
## Task Six: The Mutate Verb
## learn how to use the mutate verb
## to change or add columns in the dataset
###########################################################

## 6.1: Use mutate to change lifeExp to be in months


gapminder %>% 
  mutate(lifeExp * 12) 


## 6.2: Use mutate to create a new column called lifeExpMonths


gapminder %>% 
  mutate(lifeExpMonths = lifeExp * 12) 


## 6.3: Filter, mutate, and arrange the gapminder dataset
## Retrieve the life expectancy in months for the year 2007.
## Store the result in a new column called lifeExpMonths
## Sort the result in descending order


gapminder %>% filter(year == 2007) %>% 
  mutate(lifeExpMonths = lifeExp * 12) %>%
  arrange(desc(lifeExpMonths))


###########################################################
## Task Seven: The Summarize Verb
## Learn how to use the summarize verb
## to summarize a column into one single value
###########################################################

## 7.1: Summarize to find the median life expectancy


gapminder %>% 
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE))


## 7.2: Filter for 1962 then summarize the median life expectancy


gapminder %>% 
  filter(year == 1962) %>% 
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE))


## 7.3: Filter for 1962 then summarize the median life expectancy 
## and the maximum GDP per capita


gapminder %>% 
  filter(year == 1962) %>% 
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE), max(gdpPercap))


###########################################################
## Task Eight: The group_by verb
## Learn how to use the group_by verb
## to group by column(s) in the dataset
###########################################################

## 8.1: Find median life expectancy and maximum GDP per capita in each year


gapminder %>% 
  group_by(year) %>% 
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE), max(gdpPercap))


## 8.2: Find median life expectancy and maximum GDP per 
## capita in each continent in 1962


gapminder %>%
  group_by(continent) %>%
  filter(year == 1962) %>% 
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE), max(gdpPercap))



## 8.3: Find median life expectancy and maximum GDP per capita
## in each continent/year combination


gapminder %>%
  group_by(continent,year) %>%
  summarise(median_lifeExp = median(lifeExp, na.rm = TRUE), max(gdpPercap))




#################################################################
##-------------------------------------------------------------##
##                        THANK YOU 
##-------------------------------------------------------------##
#################################################################







