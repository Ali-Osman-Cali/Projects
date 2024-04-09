install.packages("rvest")
library(rvest)

url <- "https://en.wikipedia.org/wiki/List_of_bicycle-sharing_systems"
webpage <- read_html(url)

table_nodes <- html_nodes(webpage, "table")

print(table_nodes[[1]])

bike_sharing_df <- html_table(table_nodes[[1]], fill = TRUE)

summary(bike_sharing_df)

write.csv(bike_sharing_df, file = "raw_bike_sharing_systems.csv")