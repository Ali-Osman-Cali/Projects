############################
##                        ##
##     Ali Osman CALI     ##
##                        ##     
############################


install.packages("tm")
install.packages("e1071")
install.packages("gmodels")
install.packages("topicmodels")
install.packages("tidyverse")
install.packages("reshape2")
install.packages("dplyr")
install.packages("tidytext")
install.packages("ggplot2")

library(tm)
library(e1071)
library(gmodels)
library(topicmodels)
library(tidyverse)
library(reshape2)
library(dplyr)
library(tidytext)
library(ggplot2)


## Question 1
## Build a Naive Bayes classifier that learns the difference between the lines of The
## Picture of Dorian Gray and The Time Machine novels. You can find the books in
## moodle in mybooks3.rds file. Use the half of the lines, to model your classifier and
## allocate 85% of the text for training dataset. Evaluate the performance of your classifier
## and report the accuracy of your model.


mybooks3 <- readRDS("mybooks3.rds")

dim(mybooks3)

colnames(mybooks3)


## Half of the 11586 is 5,793. I round it to 5800


samplelines <- sample(seq_len(nrow(mybooks3)), size = 5800)

mysample <- mybooks3[samplelines, ]


## % 85 of 5800 is 4930

picked <- sample(seq_len(nrow(mysample)), size = 4930)
Data_train <- mysample[picked, ]
Data_test <- mysample[-picked, ]

Data_train_corpus <-Corpus(VectorSource(Data_train$text))
Data_test_corpus <-Corpus(VectorSource(Data_test$text))

Data_train_corpus_clean <- tm_map(Data_train_corpus, 
                                  content_transformer(tolower))
Data_test_corpus_clean <- tm_map(Data_test_corpus, 
                                 content_transformer(tolower))

Data_train_corpus_clean <- tm_map(Data_train_corpus_clean, 
                                  content_transformer(removeNumbers))
Data_test_corpus_clean <- tm_map(Data_test_corpus_clean, 
                                 content_transformer(removeNumbers))

Data_train_corpus_clean <- tm_map(Data_train_corpus_clean, 
                                  content_transformer(removePunctuation))
Data_test_corpus_clean <- tm_map(Data_test_corpus_clean, 
                                 content_transformer(removePunctuation))

Data_train_corpus_clean <- tm_map(Data_train_corpus_clean, 
                                  removeWords,stopwords("english"))
Data_test_corpus_clean <- tm_map(Data_test_corpus_clean, 
                                 removeWords, stopwords("english"))

Data_train_corpus_clean <- tm_map(Data_train_corpus_clean, 
                                  content_transformer(stripWhitespace))
Data_test_corpus_clean <- tm_map(Data_test_corpus_clean, 
                                 content_transformer(stripWhitespace))

Data_train_dtm <- DocumentTermMatrix(Data_train_corpus_clean)
Data_test_dtm <- DocumentTermMatrix(Data_test_corpus_clean)

Data_train_dtm <- as.data.frame(as.matrix(Data_train_dtm))
Data_test_dtm <- as.data.frame(as.matrix(Data_test_dtm))


convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1)) 
  return(x)}

Data_train_dtm <- apply(Data_train_dtm, MARGIN = 2, convert_counts)
Data_test_dtm <- apply(Data_test_dtm, MARGIN = 2, convert_counts)

class(Data_test_dtm)

myclassifier <- naiveBayes(Data_train_dtm, Data_train$title)

data_test_pred <- predict(myclassifier, Data_test_dtm)

view(data_test_pred)

CrossTable <- CrossTable(data_test_pred, Data_test$title,
           prop.chisq = FALSE, prop.t = FALSE,
           dnn = c("predicted", "actual"))

## The Picture of Dorian Gray was predicted 518 times correctly and misclassified as The Time Machine 82 times
## The Time Machine was predicted correctly 155 times and misclassified as The Picture of Dorian Gray 115 times
## Accuracy of the model is 0.728 (72.8%)



## Question 2
## For this question, use only the lines from The Picture of Dorian Gray book. Fit an
## LDA model to model the topics in each chapter in the book. Choose a number of
## topics between 4-8 and visualize the word-topic probabilities for each topic. Experiment
## with the number of topics and other parameters of the LDA function so that the
## word-topic probabilities make the most sense. Report the results of the model you
## think makes sense the most. After you select the optimum number of topics, visualize
## the topic distribution of each chapter.


dorian_gray <- mybooks3[1:8443, ]

mycorpus <- Corpus(VectorSource(dorian_gray))
mycorpus_clean <- tm_map(mycorpus, content_transformer(tolower))
mycorpus_clean <- tm_map(mycorpus_clean, content_transformer(removePunctuation))
toSpace <- content_transformer(function(x, pattern){return (gsub(pattern, " ", x))})
mycorpus_clean <- tm_map(mycorpus_clean, toSpace, "—")
mycorpus_clean <- tm_map(mycorpus_clean, content_transformer(removeNumbers))
mycorpus_clean <- tm_map(mycorpus_clean, removeWords, stopwords("english"))
mycorpus_clean <- tm_map(mycorpus_clean, content_transformer(stripWhitespace))
mycorpus_clean <- tm_map(mycorpus_clean, stemDocument)

mydtm <- DocumentTermMatrix(mycorpus_clean)


mydtm_df <- as.data.frame(as.matrix(mydtm))


inspect(mydtm)

## First Experiment

my_lda <- LDA(mydtm_df, k=4, control=list(seed = 1234))

mytopicsterms <- tidy(my_lda, matrix = "beta")

mytopicsterms %>% head(12)

mytopicsterms_top <- mytopicsterms %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

mytopicsterms_top %>% head(8)

mytopicsterms_top %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE, alpha=0.9) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + theme_bw()

mydocuments <- tidy(my_lda, matrix = "gamma")
mydocuments %>% head(5)

by_chapter <- dorian_gray %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, 
                                     regex("^chapter ", 
                                                 ignore_case = TRUE)))) %>% 
  ungroup() %>% filter(chapter > 0) %>% unite(document, title, chapter)


word_counts <- by_chapter %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(document, word, sort = TRUE) %>%
  ungroup()


word_counts %>% head(10)


chapters_dtm <- word_counts %>% cast_dtm(document, word, n)


chapters_lda <- LDA(chapters_dtm, k = 4,  control = list(seed = 1234))
chapter_topics <- tidy(chapters_lda, matrix = "beta")
chapter_topics %>% head(8)

top_terms <- chapter_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + 
  theme_bw()

## Second Experiment

my_lda <- LDA(mydtm, k=6, control=list(seed = 123456))

mytopicsterms <- tidy(my_lda, matrix = "beta")

mytopicsterms %>% head(18)

mytopicsterms_top <- mytopicsterms %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

mytopicsterms_top %>% head(12)

mytopicsterms_top %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE, alpha=0.9) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + theme_bw()

mydocuments <- tidy(my_lda, matrix = "gamma")
mydocuments %>% head(5)

by_chapter <- dorian_gray %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, regex("^chapter ", 
                                                 ignore_case = TRUE)))) %>%
  ungroup() %>%
  filter(chapter > 0) %>%
  unite(document, title, chapter)

word_counts <- by_chapter %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(document, word, sort = TRUE) %>%
  ungroup()

word_counts %>% head(10)

chapters_dtm <- word_counts %>% cast_dtm(document, word, n)

chapters_lda <- LDA(chapters_dtm, k = 6,  control = list(seed = 123456))
chapter_topics <- tidy(chapters_lda, matrix = "beta")
chapter_topics %>% head(12)

top_terms <- chapter_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + 
  theme_bw()

## Third Experiment 

my_lda <- LDA(mydtm, k=8, control=list(seed = 12345678))

mytopicsterms <- tidy(my_lda, matrix = "beta")

mytopicsterms %>% head(24)

mytopicsterms_top <- mytopicsterms %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

mytopicsterms_top %>% head(16)

mytopicsterms_top %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE, alpha=0.9) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + theme_bw()

mydocuments <- tidy(my_lda, matrix = "gamma")
mydocuments %>% head(5)

by_chapter <- dorian_gray %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, regex("^chapter ", 
                                                 ignore_case = TRUE)))) %>%
  ungroup() %>%
  filter(chapter > 0) %>%
  unite(document, title, chapter)

word_counts <- by_chapter %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(document, word, sort = TRUE) %>%
  ungroup()

word_counts %>% head(10)

chapters_dtm <- word_counts %>% cast_dtm(document, word, n)

chapters_lda <- LDA(chapters_dtm, k = 8,  control = list(seed = 12345678))
chapter_topics <- tidy(chapters_lda, matrix = "beta")
chapter_topics %>% head(16)

top_terms <- chapter_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() + 
  theme_bw()
