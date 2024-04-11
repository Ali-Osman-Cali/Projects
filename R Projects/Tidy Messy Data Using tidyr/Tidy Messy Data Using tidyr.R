###########################################################
###########################################################

### Tidy Messy Data using tidyr in R

###########################################################
###########################################################

###########################################################
## Task One: Getting Started
## Install and import the required 
## packages for this project.
###########################################################

## Install the required packages

install.packages("tidyverse")
install.packages("readxl")

## Load the required packages

library(tidyverse)
library(readxl)


###########################################################
## Task Two: Pivot longer
## Learn to use the pivot_longer() 
## function to make sure each variable is stored in a column
###########################################################


## Let's create a sample data


table1 <- tibble(
  country = c("A", "B", "C"),
  `1999` = c("0.7K", "37K", "212K"),
  `2000` = c("2K", "80K", "213K")
)


## Print the data


table1


## Use pivot_longer to reshape the data


table1 %>%
  pivot_longer(c('1999','2000'))


## Pivot on all the other columns except the country column


table1 %>%
  pivot_longer(-country)


## Overwrite its name with year 
## The value column should be named n_cases


table1 %>%
  pivot_longer(-country, names_to = "year",
               values_to = "n_cases")


## Using the gather function


table1 %>% 
  gather(-country, key = 'year', value = 'n_cases')


###########################################################
## Task Three: Pivot wider
## Learn to use the pivot_wider() 
## function to make sure each variable is stored in a column
###########################################################

## Read in the planet-data.csv using the read_csv() function


planet_df <- read_csv("planet-data.csv")


## Print the first six rows of the data using the head() function


head(planet_df)


## Change this long data to wide form
## Give each planet variable its own column


planet_df %>%
  pivot_wider(planet, names_from = "metric", values_from = "value")


## Quick note about spread()


planet_df %>%
  spread(key = metric, value = value)


###########################################################
## Task Four: Practice Activity
## Take a pause and practice how to
## know the number of nuclear bombs for each country
###########################################################

## Read in nukes.csv into R


nukes_df <- read_csv("nukes.csv")


## Print the first 5 rows and all columns


nukes_df %>% 
  print(n = 5, width = Inf)


## Pivot all columns except for year to a longer format.


nukes_df %>%
  pivot_longer(-year)


## Overwrite the names of the two new columns
## The name column should be named country
## The value column should be named n_bombs


nukes_df %>%
  pivot_longer(-year,names_to = "country", values_to = "n_bombs")


###########################################################
## Task Five: Plot the long data
## Learn how to plot the pivot_longer() function
###########################################################

## Replace the NA values in the n_bombs column 
## with integer zero values (0L).


nukes_df %>%
  pivot_longer(-year,names_to = "country", values_to = "n_bombs") %>%
  replace_na(list(n_bombs=0L))


## Plot the number of bombs per country over time
## Create a line plot where the number of bombs dropped 
## per country is plotted over time. Use country to color the lines.


nukes_df %>%
  pivot_longer(-year,names_to = "country", values_to = "n_bombs") %>%
  replace_na(list(n_bombs=0L)) %>%
  ggplot(aes(x=year,y=n_bombs, color=country)) + geom_line()


###########################################################
## Task Six: Unstack data
## Learn how to unstack data
###########################################################

## Load the PlantGrowth data


data("PlantGrowth")


## Print the data


PlantGrowth


## Split this data into the different treatment groups


unstack(PlantGrowth)


## Load the diets.csv data set using read_csv()


diet <- read.csv("DIETS.csv")


## Explore the data using 
## head() and tail() functions


head(diet)
tail(diet)


## Unstack the data


unstack(diet)


## The solution


diet_data <- unstack(diet, WTLOSS ~ DIET)


## Check the first 5 rows of the new data


head(diet_data,5)
write.csv(diet_data, "clean_diet.csv")


###########################################################
## Task Seven: Practice Assessment
## Take a pause and answer the 
## question to test your knowledge
###########################################################

## Question:
## As an R user with an understanding of the tidyr package. 
## You have been tasked to replace the missing values in 
## the cty (city miles per gallon) column of the mpg 
## data set with the value 5. Write a code to achieve this task.

#ANSWER


mpg %>% replace_na(list(cty=5L))


###########################################################
## Task Eight: Separate rows
## Learn to use separate_rows()
## to make sure each observation is stored in a row
###########################################################


## Import the netflix_data.csv using the read_csv() function
## Save it as net_data


netflix_df <- read.csv("netflix_data.csv")


## Print the first six rows of the data using the head() function


head(netflix_df)


## Separate the actors in the cast column over multiple rows


netflix_df %>% 
  separate_rows(cast,sep = ", ")


## Find which six actors have the most appearances


netflix_df %>% 
  separate_rows(cast,sep = ", ") %>%
  rename(actor=cast) %>%
  count(actor,sort=TRUE) %>%
  head()


###########################################################
## Task Nine: Separate & Unite
## Use separate() to make sure each 
## cell contains a single value and
## unite to merge columns by a delimiter
###########################################################


## Read the movies_duration.csv using the read_csv() function


movies_data <- read_csv("movies_duration.csv")


## Print the first six rows of the data using the head() function


head(movies_data)


## Split the duration column into value and unit columns


movies_data %>%
  separate(duration,into = c("value","unit"), sep= " ", convert=TRUE)


## Find the average duration for each type and unit


movies_data %>%
  separate(duration,into = c("value","unit"), sep= " ", convert=TRUE) %>%
  group_by(type,unit) %>%
  summarize(mean_duration = mean(value))


## Join the title and type columns using sep = ' - '


movies_data %>%
  unite(title_type, title, type, sep= " - ")


###########################################################
## Task Ten: Practice Activity
## Take a pause and practice how to 
## get a count of movies per director
###########################################################

## Load the netflix_directors.csv data using read_csv()


netflix_directors_df <- read.csv("netflix_directors.csv")


## Print director_df to see what string 
## separates directors in the director column.


netflix_directors_df


## Spread the values in the director column over separate rows.


netflix_directors_df %>%
  separate_rows(director, sep = ", ")


## Spread the director column over separate rows
## Count the number of movies per director


netflix_directors_df %>%
  separate_rows(director, sep = ", ") %>%
  count(director, sort=TRUE)
  

## Drop rows with NA values in the director column using drop_na()
## and recount the number of movies per director


netflix_directors_df %>%
  drop_na(director) %>%
  separate_rows(director, sep = ", ") %>%
  count(director, sort=TRUE)


###########################################################
## Task Eleven: Separate rows & Separate
## Learn how to combine the 
## separate_rows() and separate() functions to tidy data
###########################################################

## Load and print the drink.xlsx data using read_excel()


drink_df <- read_excel("drink.xlsx")
drink_df


## Separate the ingredients column over rows


drink_df %>%
  separate_rows(ingredients, sep = "; ")


## Separate the ingredients into three columns
## ingredient, quantity, and unit


drink_df %>% 
  separate_rows(ingredients, sep = "; ") %>%
  separate(ingredients, into = c("ingredient","quantity","unit"),
           sep=" ",
           convert=TRUE)


## Separate the ingredients over rows
## Separate ingredients into three columns
## Group by ingredient and unit
## Calculate the total quantity of each ingredient


drink_df %>% 
  separate_rows(ingredients, sep = "; ") %>%
  separate(ingredients, into = c("ingredient","quantity","unit"),
           sep=" ",
           convert=TRUE) %>%
  group_by(ingredient,unit) %>%
  summarize(totalQuantity=sum(quantity))


###########################################################
## Task Twelve: Wrap up
## Wrap up this project by looking at 
## how to create visuals of our tidy data.
###########################################################

## Recall the wide data from task three


planet_df %>% 
  pivot_wider(planet, names_from = "metric", values_from = "value") 


## Plot the distance to the sun and temperature
## Plot planet temperature (y-axis) over distance to sun (x-axis)


planet_df %>% 
  pivot_wider(planet, names_from = "metric", values_from = "value") %>% 
  ggplot(aes(x = distance_to_sun, y = temperature)) +
  geom_point(aes(size = diameter)) +
  geom_text(aes(label = planet), vjust = -1) +
  labs(x = "Distance to sun (million km)", 
       y = "Mean temperature (Celsius)") +
  theme(legend.position = "none")


###########################################################
## Task Thirteen: Practice Activity
## Take a pause and practice how to plot planet_wide dataset
###########################################################

## Read and print the planet_wide.csv data

planet_wide <- read.csv("planet_wide.csv") 

planet_wide

## Tidy the data set

planet_wide %>%
  pivot_longer(-metric,names_to = "planet") %>%
  pivot_wider(planet, names_from = "metric",values_from = "value") 

tidy_planet <- planet_wide %>%
  pivot_longer(-metric,names_to = "planet") %>%
  pivot_wider(planet, names_from = "metric",values_from = "value")


## Create the plot

planet_wide %>%
  pivot_longer(-metric,names_to = "planet") %>%
  pivot_wider(planet, names_from = "metric",values_from = "value") %>%
  ggplot(aes(x= diameter,y= number_of_moons)) + geom_point(aes(size = diameter)) + 
  geom_text(aes(label = planet), vjust = -1) + 
  theme(legend.position = "none")



#################################################################
##-------------------------------------------------------------##
##                        THANK YOU 
##-------------------------------------------------------------##
#################################################################











