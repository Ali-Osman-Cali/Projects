############################
##                        ##
##     Ali Osman CALI     ##
##                        ## 
############################


library(dplyr)
library(tidyr)


## TASK 1
## Import the csv file to your R-studio


demographics_df <- read.csv("demographics.csv", sep=";")


## TASK 2
## Return the number of men living in Germany in 2020, 
## whose age are between 50 and 54.


Germany_M_2020 <- demographics_Ali %>%
  filter(Country == "Germany" , Age== "50 to 54",Year == 2020,Sex=="M")
Germany_M_2020 %>% 
  select(Population)


## TASK 4
## Return the number of women living in Italy in 2019, 
## whose age are either between 25 and 29 or 35 and 39.


Italy_W_2019 <- demographics_Ali %>%
  filter(Country == "Italy" , Age== "25 to 29" | Age== "35 to 39", Year == 2019,Sex=="W")
Italy_W_2019 %>% 
  select(Population)


## TASK 5
## Create a dataframe which shows the total population for each year and each country.
## (Hint: The dataframe should have three columns: Country, Year, and Total_population.)

Total_Pop <- demographics_Ali %>% 
  group_by(Country, Year) %>%
  summarize(Total_population = sum(Population))


## TASK 6
## Create a dataframe which shows the number of people aged 65 or over, 
## for each country,year and sex. (Hint: The dataframe should have four 
## columns: Country, Year, Sex, and Pop_over65.)


Over_65 <- demographics_Ali %>%
  filter(Age == "65 to 69" | Age == "70 to 74" | Age == "75 to 79" | Age == "80 to 84" | Age == "85 and over") %>%
  group_by(Country, Year, Sex) %>%
  summarize(Pop_over65 = sum(Population))


## TASK 7
## Create a dataframe which shows old age dependency ratio and total dependency ratio
## for all countries and years (formulas below) and order the dataframe based on the
## country names, alphabetically. (Hint: There should be four columns in the dataframe:
## Country, Year, Old_age_dep, Total_dep.)


old_age_dep <- demographics_df %>%
  filter(Age >= 15 & Age <= 64 | Age > 65) %>%
  group_by(Country, Year) %>%
  summarize(Old_age_dep = sum(Population[Age > 65]) / sum(Population[Age >= 15 & Age <= 64])) %>%
  ungroup()


total_dep <- demographics_df %>%
  filter(Age >= 20 & Age <= 64 | Age < 20 | Age > 65) %>%
  group_by(Country, Year) %>%
  summarize(Total_dep = (sum(Population[Age < 20]) + sum(Population[Age > 65])) / sum(Population[Age >= 20 & Age <= 64])) %>%
  ungroup()

dependency_df <- merge(old_age_dep, total_dep, by = c("Country", "Year"), all = TRUE)

dependency_df[is.na(dependency_df)] <- 0

dependency_df <- dependency_df[order(dependency_df$Country), ]

print(dependency_df)




## TASK 8
## Download and read the gdpc_data.csv file. By using one of the join functions, 
## create a table includes Austria,Belgium, France and Netherlands population 
## and GDPC info for 2019 AND 2020

gdpc_data <- read.csv("gdpc_data.csv", sep=";")


GDPData_Ali <- gdpc_data%>%
  arrange(Country, Year)
print(GDPData_Ali)

demographics_df_summed <- demographics_df %>%
  group_by(Country, Year) %>%
  summarise(Population = sum(Population))%>%
  filter(Year== 2019 | Year== 2020 )%>%
  filter(Country == "Austria" | Country == "Belgium" | Country == "France" | Country == "Netherlands")

print(demographics_df_summed)

Merged_GDPData <- left_join(demographics_df_summed,GDPData_Ali, by = c("Country", "Year"))

print(Merged_GDPData)
















