###########################################################
###########################################################

#### Joining Data in R

###########################################################
###########################################################

###########################################################
## Task One: Getting Started
## In this task, you will install and import the required 
## packages for this project.
###########################################################

## Install the required packages
install.packages(c("dplyr", "janitor"))

## Load the dplyr package
library(dplyr)

## Load the janitor package
library(janitor)


###########################################################
## Task Two: Create and Clean Data sets
## In this task, you will create and clean the sales and 
## customers data sets
###########################################################

## Create the sales data
sales <- tibble(`Customer Id` = c(1001, 1002, 1003, 1004, 1005, 1006),
                NAME = c("James", "Grace", "Moses", "Emmanuel", 
                         "Dorcas", "Deborah"),
                AGE = c(23, 26, 27, 32, 20, 22),
                PRODUCT = c("Kettle","Television","Mobile",
                            "WashingMachine","Lightings","Oven"))

## Print out the sales data

sales

## Create the customers data
customers <- tibble(`Customer Id` = c(1002, 1004, 1005, 1007, 1008), 
                    NAME = c("Park", "Waters", 
                             "Ayoola", "Brooks", "Adeoba"),
                    STATE = c("California","Newyork","Santiago",
                              "Texas","Indiana")) 

## Print out the customers data

customers


## Clean the column names for the sales data

sales <- clean_names(sales)
sales

## Clean the column names for the customers data

customers <- clean_names(customers)
customers

###########################################################
## Task Three: Inner Join - Part 1
## In this task, you will perform the inner join operation
## in R
###########################################################

## Using the merge() function

merged_df <- merge(sales, customers, by= 'customer_id')
merged_df 

## Inner join in dplyr

innerJoin <- inner_join(sales, customers, by= 'customer_id')
innerJoin

## Inner join in dplyr with the pipe operator

innerJoin_pipe <- sales %>%
  inner_join(customers, by= 'customer_id')
innerJoin_pipe

###########################################################
## Task Four: Inner Join - Part 2
## In this task, you will perform the inner join operation
## in R
###########################################################

## Let's change the customer_id to cust_id

customers <- customers %>% 
  rename(cust_id = customer_id)

## Print out the customers data

customers

## Perform inner join of the sales and customers data

innerJoin <- sales %>% inner_join(customers, by = "customer_id")

## Solution to this

innerJoin <- sales %>% inner_join(customers, by = c("customer_id" = "cust_id"))

## Print out the result

innerJoin

## Keep the common column used in the join

innerJoin <- sales %>% inner_join(customers, by = c("customer_id" = "cust_id"), keep=T)


## Print the result

innerJoin

###########################################################
## Task Five: Inner Join - Part 3
## In this task, you will perform the inner join operation
## in R
###########################################################

## Let's change the cust_id to customer_id

customers <- customers %>% 
  rename(customer_id = cust_id)

## Print out the customers data

customers

## Perform inner join of the sales and customers data

innerJoin <- sales %>% inner_join(customers, by = "customer_id")

## Print the result

innerJoin

## Drop columns with same data

innerJoin <- sales %>% inner_join(customers, by = "customer_id", suffix = c("",""))


## Print the result

innerJoin

## Rename columns with same data

innerJoin <- sales %>% inner_join(customers, by = "customer_id") %>% 
  rename(firstname = name.x, surname = name.y) %>%
  relocate(surname, .after = firstname)


## Print the result

innerJoin

## Select some columns from the result set

custDetails <- innerJoin %>% 
  select(customer_id, firstname, surname, product, state)

## Print the result

custDetails

###########################################################
## Task Six: Full (Outer) Join
## In this task, you will perform the full join operation
## in R
###########################################################

## Using the merge() function

merged_full <- merge(sales, customers, by= 'customer_id', all=TRUE)


## Print the result

merged_full

## Full join in dplyr

full_join_df <- sales %>%
  full_join(customers, by='customer_id')

## Print the result

full_join_df

###########################################################
## Task Seven: Left Join
## In this task, you will perform the left join operation
## in R
###########################################################

## Using the merge() function

left_join <- merge(x = sales, y = customers, 
                by = "customer_id", all.x = TRUE)

## Print the result

left_join

## Left join in dplyr

left_join_pipe <- sales %>% left_join(customers, by = "customer_id")

## Print the result

left_join_pipe 

###########################################################
## Task Eight: Right Join
## In this task, you will perform the right join operation
## in R
###########################################################

## Using the merge() function

right_join <- merge(x = sales, y = customers, 
                by = "customer_id", all.y = TRUE)

## Print the result

right_join

## Right join in dplyr

right_join_pipe <- sales %>% right_join(customers, by = "customer_id")

## Print the result

right_join_pipe

###########################################################
## Task Nine (Practice): Cross, Semi & Anti Join
## In this task, you will perform the semi and anti 
## join operation in R
###########################################################

## Cross join using the merge() function

cross_join <- merge(sales, customers, by = NULL)

## Print the result

cross_join

## Semi Join in dplyr

semi_join_ <- semi_join(sales, customers, by = "customer_id")


## Print the result

semi_join

## Anti-join in dplyr

anti_join_ <- anti_join(sales, customers, by='customer_id')

## Print the result

anti_join_


#################################################################
##-------------------------------------------------------------##
## THANK YOU FOR LEARNING WITH ME
##-------------------------------------------------------------##
#################################################################



