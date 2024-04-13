############################
##                        ##
##     Ali Osman CALI     ##
############################


install.packages("dplyr")
install.packages("ggplot2")
install.packages("readxl")
install.packages("tidyr")

library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)


## TASK 1

starbucks <- read.csv("starbucks.csv")


## PLOT 1A

starbucks %>%
  filter(size == "grande" | size == "short" | size == "tall" | size == "venti") %>%
  ggplot(aes(x = sugar_g, y = calories, color = size)) + 
  geom_point(size=2.2) + 
  scale_color_brewer(palette = "Paired")

## PLOT 1B

starbucks %>%
  filter(whip == 0 | whip == 1) %>%
  ggplot(aes(x = total_fat_g, y = calories, color=factor(whip))) + 
  geom_point(alpha = 0.6, size=2.2) + 
  scale_color_brewer(palette = "Set1")

## PLOT 1C

starbucks %>%
  filter(product_name == "White Hot Chocolate" | product_name == "White Chocolate Mocha" | product_name == "Skinny Hot Chocolate" | product_name == "Iced White Chocolate Mocha" | product_name == "Hot Chocolate" | product_name == "Chocolate Smoothie") %>%
  ggplot(aes(x = calories, y = product_name, fill=factor(product_name))) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Set2")+
  guides(fill = FALSE)



## TASK 2

olympics_new <- read.csv("olympics_new.csv")


## PLOT 2A

colnames(olympics_new)[1] <- "Number of Athletes"

agg_data <- olympics_new %>%
  group_by(year, sex) %>%
  summarise(count = n())

# Plot
ggplot(agg_data, aes(x = year, y = count, color = sex)) +
  geom_line() +
  labs(x = "Year", y = "Number of Athletes", color = "Gender") +
  scale_color_manual(values = c("darkgreen", "red")) +
  theme_minimal()



## PLOT 2B

  
Gold_Medal <-ggplot(olympics_new, aes(x=age,colour=sex))
Gold_Medal+geom_density()





