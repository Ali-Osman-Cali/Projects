############################
##                        ##
##     Ali Osman CALI     ##
##                        ##
############################


install.packages("tm")
install.packages("SnowballC")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("wordcloud")


library(tm)
library(SnowballC)
library(dplyr)
library(ggplot2)
library(wordcloud)


## QUESTION 1
## Download the recipe3.rds from moodle to your working 
## directory and import the file to
## R studio (assign a name to your character vector).


recipe3_Ali <- readRDS("recipe3.rds")


## QUESTION 2
## Preprocess the text data; normalize the text, 
## clean the text from all punctuation,
## numbers, stopwords, weird characters, and stem the words.



corpus_recipe3 <- Corpus(VectorSource(recipe3_Ali))

clean_corpus_recipe3 <- tm_map(corpus_recipe3, content_transformer(tolower))

clean_corpus_recipe3 <- tm_map(corpus_recipe3, content_transformer(removePunctuation))

toSpace <- content_transformer(function(x, pattern){
  return (gsub(pattern, " ", x))})

clean_corpus_recipe3 <- tm_map(clean_corpus_recipe3, toSpace, "—")

clean_corpus_recipe3 <- tm_map(clean_corpus_recipe3, 
                               content_transformer(removeNumbers))

clean_corpus_recipe3 <- tm_map(clean_corpus_recipe3, removeWords, 
                               stopwords("english"))

clean_corpus_recipe3 <- tm_map(clean_corpus_recipe3, 
                         content_transformer(stripWhitespace))

clean_corpus_recipe3 <- tm_map(clean_corpus_recipe3, stemDocument)



## QUESTION 3
## Make a bar plot of the words that show up more than 25 times.


recipe3_dtm_Ali <- DocumentTermMatrix(clean_corpus_recipe3)

recipe3_freq <- sort(colSums(as.matrix(recipe3_dtm_Ali )), decreasing=TRUE)

recipe_3df_Ali <- data.frame(term = names(recipe3_freq), occurrences = recipe3_freq)

recipe_3df_Ali$term <- factor(recipe_3df_Ali$term, 
                              levels=recipe_3df_Ali$term[order(recipe_3df_Ali$occurrences)])

recipe_3df_Ali %>% 
  filter(recipe3_freq > 25) %>% 
  ggplot(aes(term, occurrences)) + 
  geom_bar(stat = "identity", fill = "darkred", color = "black") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12))


## QUESTION 4
##Create a wordcloud of words which show up at least 20 times.


wordcloud(names(recipe3_freq), recipe3_freq, min.freq=20)





