############################
##                        ##
##     Ali Osman CALI     ##  
##                        ##  
############################



install.packages("tidytext")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("igraph")
install.packages("ggraph")

library(tidytext)
library(tidyverse)
library(dplyr)
library(igraph)
library(ggraph)

mybooks3 <- readRDS("mybooks3.rds")


## Question 1
## Bring the book in tidy format 
## one-word-per-row


tidybook <- mybooks3 %>% 
  filter(title == "The Time Machine") %>%
  mutate(chapter = cumsum(str_detect(text, 
                                   regex("^chapter",ignore_case = TRUE)))) %>%
  unnest_tokens(word, text)


## Question 2
## Check if the Zipf’s law holds for this book 
## (by plotting the actual frequency of the
## words and expected frequency under 
## Zipf’s law in the same graph)


wordfreq <- mybooks3 %>% 
  filter(title=="The Time Machine") %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE) %>%
  head(500)


wordfreq <- wordfreq %>%
  mutate(word = factor(word, levels = word),
         rank = row_number(),
         zipfs_freq=ifelse(rank==1, n, dplyr::first(n)/rank))


wordfreq2 <- gather(wordfreq, observ, freq, c(n, zipfs_freq)) 


ggplot(wordfreq2, aes(x = rank, y = freq, color = observ)) + 
  geom_point(alpha=0.5, size=2) +
  theme_bw()+
  scale_colour_brewer(palette = "Set1")


## In high frequency we see Zipf’s law doesn't work quite well 
## but we see in low frequency  Zipf’s law holds for this book


## Question 3
## Clean the text from the stopwords, 
## and use no-stop-word version of the 
## dataframe inthe following questions.

data(stop_words)
tidybook <- tidybook %>% anti_join(stop_words)
mostcommon <- tidybook %>% count(word, sort = TRUE) 


## Question 4
## Visualize the most common 20 
## words in the book by using a bar plot


tidybook %>%
  count(word, sort = TRUE) %>% 
  head(20) %>%  
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(n, word)) + 
  geom_col(fill="maroon", color="black") + 
  labs(y = NULL) + 
  theme_bw()


## Question 5
## Visualize the most common 15 bigrams 
## in the book by using a bar plot

tale_bigrams <- mybooks3 %>% 
  filter(title == "The Time Machine") %>%
  unnest_tokens(bigram, text, token = "ngrams", n=2)

mostcommon_bi <- tale_bigrams %>% count(bigram, sort = TRUE) 

bigrams_separated <- tale_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE) %>%
  filter(!is.na(word1))

bigram_counts %>%  
  filter(!is.na(word1)) %>%
  mutate(word_pair=paste(word1, word2, sep=" ")) %>%  
  mutate(word_pair = reorder(word_pair, n)) %>% 
  head(15) %>%
  ggplot(aes(n, word_pair)) + 
  geom_col(fill="darkred", color="red") + 
  labs(y = NULL) + 
  theme_bw()


## Question 6
## Visualize the most common 10 trigrams 
## in the book by using a bar plot.


tale_trigrams <- mybooks3 %>% 
  filter(title=="The Time Machine") %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)

tale_trigrams %>%  
  filter(!is.na(word1)) %>%
  mutate(words = paste(word1, word2, word3, sep = " ")) %>%  
  mutate(words = reorder(words, n)) %>% 
  head(10) %>%
  ggplot(aes(n, words)) + 
  geom_col(fill = "darkgreen", color = "green") + 
  labs(y = NULL) + 
  theme_bw()


## Question 6
##Visualize the most common bigram 
## in each chapter by using a bar plot.

text_data <- mybooks3$text

extract_bigrams <- function(text) {
  words <- str_split(text, "\\s+")[[1]]
  bigrams <- paste(words[1:(length(words) - 1)], words[2:length(words)], sep = " ")
  return(bigrams)
}

chapter_bigrams <- lapply(text_data, extract_bigrams)

chapter_df <- data.frame(
  chapter = rep(1:length(text_data), sapply(chapter_bigrams, length)),
  bigram = unlist(chapter_bigrams)
)


bigram_counts <- chapter_df %>%
  group_by(chapter, bigram) %>%
  summarize(count = n()) %>%
  ungroup()

most_common_bigrams <- bigram_counts %>%
  group_by(chapter) %>%
  slice(which.max(count)) %>%
  ungroup()


ggplot(most_common_bigrams, aes(x = factor(chapter), y = count)) +
  geom_bar(stat = "identity", fill = "darkred") +
  labs(title = "Most Common Bigram in Each Chapter", x = "Chapter", y = "Frequency") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))








