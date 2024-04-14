############################
##                        ##
##     Ali Osman CALI     ##
##                        ## 
############################


## TASK 1
## Download the kindergarten.csv dataset, import it 
## to your environment and assign the dataframe a name.


kindergarten_df <- read.csv("kindergarten.csv", sep=";")


## TASK 1A
## Return the number of children whose age is above 36 months.


nrow(subset(kindergarten_df, Months>36))


## TASK 1B
## Return the names of the children whose 
## favorite fruit is apple or strawberry.


fruit_subset <- subset(kindergarten_df, Fav_fruit == "apple" | Fav_fruit == "strawberry")
names <- fruit_subset$Name
print(names)


## TASK 1C
## Create a new dataframe which shows the children 
## with blue eyes and brown hair


EyeorHairdf <- subset(kindergarten_df, Eye == "blue" & Hair == "brown")
print(EyeorHairdf)


## TASK 1D
## Assume that the current class in the kindergarden is only for kids up to age of 4 
## (48 months). Add a new column to the dataframe, which shows how many more months
## each child can attend this class


kindergarten_df$Months_left <- 48 - kindergarten_df$Months
print(kindergarten_df)


# TASK 2
## Create the dataframe below
## ------------------------
##    mylog      mynum
## ------------------------
##    TRUE        1
##    FALSE       NA
##    FALSE       2
##    TRUE        3
## ------------------------



mylog <- c(TRUE, FALSE, FALSE, TRUE)
mynum <- c(1, NA, 2, 3)
df1 <- data.frame(mylog, mynum)
print(df1)



## TASK 2A
## Return the column sums of the dataframe, 
## for each column, by using a for loop


column_sums <- vector()
for (col in colnames(df1)) {
  column_sum <- sum(df1[[col]], na.rm = TRUE)
  column_sums <- c(column_sums, column_sum)  
}
print(column_sums)


## TASK 2B
## How does the sum returns a numeric value for a logical column?
## Explain with acommented line in your R script.


mylog_sum <- sum(df1$mylog, na.rm = TRUE)

## TRUE IS TREATED AS 1 AND FALSE IS TREATED AS 0
## WE USE THE SUM() FUNCTION ON A LOGICAL COLUMN IN A DATA FRAME




## TASK 2C
## Return the column sums of the dataframe, 
## by using apply function


column_sums <- apply(df1, 2, sum, na.rm = TRUE)
print(column_sums)


## TASK 2D
## Add a new character column to the dataframe by using ifelse() function. 
## The newcolumn should be in character class, showing “available” if there is no 
## NA element in the row and “not available” otherwise.


df1$availability <- ifelse(rowSums(is.na(df1)) > 0, "not available", "available")
print(df1)




## TASK 3
## Create two numeric vectors (A and B) of length 4 each. Assume that each vector shows
## the number of points team scored in four matches in the tournament. Write a for loop
## which returns the name of the winning team for each of the four games. In case of a
## tie, the for loop should return one of the team names randomly.


set.seed(123)
A <- c(2, 4, 3, 1)
B <- c(3, 2, 4, 1)  

for (i in 1:4) {
  if (A[i] > B[i]) {
    print(paste("Match", i, "- Winner: Team A"))
  } else if (B[i] > A[i]) {
    print(paste("Match", i, "- Winner: Team B"))
  } else {
    winner <- sample(c("Team A", "Team B"), 1)
    print(paste("Match", i, "- Tie. Winner:", winner))
  }
}



## TASK 4
## You bought a stock at price 50. The price of the stock increases or decreases 
## everyday by x percent, where x is a randomly drawn number from a uniform distribution
## between -10 and 10. Find how many days does it take for the stock price to reach 
## above 70 or below 25?
  
  
set.seed(123) 

price <- 50
days <- 0

while (price > 25 && price < 70) {
value <- runif(1, -10, 10)
  price <- price + (price * value / 100)
  days <- days + 1
}

cat("It takes", days, "days for the stock price to reach above 70 or below 25.")









