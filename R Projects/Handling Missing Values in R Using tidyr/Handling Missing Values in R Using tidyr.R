###########################################################
###########################################################

### Handling Missing Values in R using tidyr

###########################################################
###########################################################

###########################################################
## Task One: Getting Started
## Install and import the required 
## packages for this project.
###########################################################

## Install the tidyverse package


install.packages("tidyverse")


## Load the tidyverse package


library(tidyverse)


## Load the ggplot2 package into the R workspace


library(ggplot2)


###########################################################
## Task Two: Import and explore the data sets
## Load and explore the msleep data
###########################################################

## Load the msleep data


msleep


## Check the first 6 rows of the data


head(msleep)


## Check the dimension of the data


dim(msleep)


## Check the column names


colnames(msleep)


## Check the number of missing values for each column


sum(is.na(msleep))


## Use the map function to check for 
## number of missing values


msleep %>% 
  map(is.na) %>% 
  map(sum)


## Calculate the proportion of missingness
## for each variable


msleep %>% 
  map(is.na) %>% 
  map(sum) %>%
  map(~./nrow(msleep)) %>%
  bind_cols()



###########################################################
## Task Three: Select Missing Variables
## Select the columns with 
## missing values
###########################################################

## Select the vore, sleep_rem, sleep_cycle, and brainwt


msleep_data <- select(msleep, vore, sleep_rem,sleep_cycle,brainwt)


## Print the new msleep data


print(msleep_data)


## Check the dimension of the new data


dim(msleep_data)


###########################################################
## Task Four: Drop Missing Rows
## Drop the missing rows in the
## vore variable
###########################################################

## Drop rows with NA values in the vore column


msleep_data <- msleep_data %>%
  drop_na(vore)

view(msleep_data)

## Check the dimension of the new data


dim(msleep_data)


###########################################################
## Task Five: Replace Missing Values
## Replace the missing values 
## in the sleep_rem and sleep_cycle variables
###########################################################

## Replace the NA values in the sleep_rem 
## column with integer zero values (0L).


msleep_data <- msleep_data %>%
  replace_na(list(sleep_rem = 0L))


## Replace the missing values in the sleep_cycle column
## using the median of the values


msleep_data %>%
  mutate(sleep_cycle = replace_na(sleep_cycle,
                                  median(sleep_cycle, na.rm = 1)))


###########################################################
## Task Six: Fill Missing Values
## Fill the missing values in the 
## brainwt variable in different direction
###########################################################

## Fill the brainwt column upwards


msleep %>%
  fill(brainwt, .direction = "down")


## Replace the NA values in the sleep_rem 
## column with integer zero values (0L).
## Fill the brainwt column upwards


msleep_data %>%
  replace_na(list(sleep_rem = 0L)) %>%
  mutate(sleep_cycle = replace_na(sleep_cycle,
                                  median(sleep_cycle, na.rm = T))) %>%
  fill(brainwt, .direction = "up")



###########################################################
## Practice: Fill Missing Values
## Work on a practice exercise to
## fill the missing values in the brainwt column
###########################################################

## Fill the missing values in the brainwt column
## "downup" and "updown".


msleep_data %>%
  replace_na(list(sleep_rem = 0L)) %>%
  mutate(sleep_cycle = replace_na(sleep_cycle,
                                  median(sleep_cycle, na.rm = T))) %>%
  fill(brainwt, .direction = "downup")


msleep_data %>%
  replace_na(list(sleep_rem = 0L)) %>%
  mutate(sleep_cycle = replace_na(sleep_cycle,
                                  median(sleep_cycle, na.rm = T))) %>%
  fill(brainwt, .direction = "updown")


###########################################################
## Task Seven: Wrap up - Chain all operations
## In this task, you will combine and chain all the 
## operations we have performed using the pipe operator
###########################################################

## Chain all the steps together and
## save the result as msleep_data


msleep_data <- msleep_data %>% 
  replace_na(list(sleep_rem = 0L)) %>%
  fill(brainwt, .direction = "up") %>%
  mutate(sleep_cycle = 
           replace_na(sleep_cycle, 
                      median(sleep_cycle, na.rm = T)))


## Print the cleaned data

msleep_data


#################################################################
##-------------------------------------------------------------##
##                        THANK YOU FOR
##-------------------------------------------------------------##
#################################################################




