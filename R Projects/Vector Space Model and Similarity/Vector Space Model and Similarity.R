############################
##                        ##
##     Ali Osman CALI     ##
##                        ##
############################


install.packages(tm)
install.packages(SnowballC)
install.packages(proxy)
install.packages(text2vec)
install.packages(Matrix)
install.packages(vegan)

library("tm")
library("SnowballC")
library("proxy")
library("text2vec")
library("Matrix")
library("vegan")




## QUESTION 1
## For the sentences below, create 3 term-document matrices: 
## one with binary weights,one with TF weights, one with TF-IDF weights.

## document text
## ------------------------
## Doc1 I like cheese.
## ------------------------
## Doc2 Do you like cheese?
## ------------------------
## Doc3 I like cheese and you like cake.
## ------------------------


docs_Ali <- c("I like cheese.", 
              "Do you like cheese?", 
              "I like cheese and you like cake.")
  

corpus_docs <- Corpus(VectorSource(docs_Ali))


# Preprocessing of the documents

corpus_docs <- tm_map(corpus_docs, content_transformer(tolower))
corpus_docs <- tm_map(corpus_docs, removePunctuation)
toSpace <- content_transformer(function(x, pattern){
  return (gsub(pattern, " ", x))})
corpus_docs <- tm_map(corpus_docs, toSpace, "—")
corpus_docs <- tm_map(corpus_docs, removeNumbers)
corpus_docs <- tm_map(corpus_docs, removeWords, stopwords("english"))
corpus_docs <- tm_map(corpus_docs, stemDocument)


# Matrix with binary weights

dtm_binary <- DocumentTermMatrix(corpus_docs, control = list(weighting = weightBin))
dtm_binary <- as.data.frame(as.matrix(dtm_binary))
print(dtm_binary)


# Matrix with TF weights

dtm_tf <- DocumentTermMatrix(corpus_docs, control = list(weighting = weightTf))
dtm_tf <- as.data.frame(as.matrix(dtm_tf))
print(dtm_tf)


# Matrix with TF-IDF weights

dtm_tfidf <- DocumentTermMatrix(corpus_docs, control = list(weighting = weightTfIdf))
dtm_tfidf <- as.data.frame(as.matrix(dtm_tfidf))
print(dtm_tfidf)


## QUESTION 2
## For the term-document matrix below, calculate the cosine similarity, euclidean distance
## and Jaccard similarity between each pair of documents. Show your work.

## --------------------
## word  Doc1 Doc1 Doc1
## --------------------
## word1  3    0    0   
## --------------------
## word2  0    1    2
## --------------------
## word3  1    3    2
## --------------------


term_doc <- matrix(c(3, 0, 0,
                     0, 1, 2,
                     1, 3, 2),
                   nrow = 3,
                   dimnames = list(c("word1", "word2", "word3"),
                                   c("Doc1", "Doc2", "Doc3")))

mymatrix <- as.matrix(term_doc)

# Cosine similarity

mycosine <- sim2(mymatrix, method = "cosine")
diag(mycosine) <- NA
print(mycosine)

# Euclidean distance

myeuclidean <- dist2(mymatrix, method = "euclidean")
diag(myeuclidean) <- NA
print(myeuclidean)

# Jaccard similarity

mysparsematrix <- Matrix(mymatrix, sparse=TRUE)
myjaccard <- vegdist(mysparsematrix, method = "jaccard")
print(myjaccard)


## QUESTION 3
## Download the recipe4.rds from moodle to your working directory and import the file
## to R studio (assign a name to your character vector), and preprocess the text data;
## normalize the text, clean the text from all punctuation, numbers, stopwords, weird
## characters, and stem the words.

recipe4_Ali <- readRDS("recipe4.rds")
corpus_recipe4 <- Corpus(VectorSource(recipe4_Ali))
corpus_recipe4 <- tm_map(corpus_recipe4, content_transformer(tolower))
corpus_recipe4 <- tm_map(corpus_recipe4, removePunctuation)
toSpace <- content_transformer(function(x, pattern){
  return (gsub(pattern, " ", x))})
corpus_recipe4 <- tm_map(corpus_recipe4, toSpace, "—")
corpus_recipe4 <- tm_map(corpus_recipe4, removeNumbers)
corpus_recipe4 <- tm_map(corpus_recipe4, removeWords, stopwords("english"))
corpus_recipe4 <- tm_map(corpus_recipe4, stemDocument)


## QUESTION 4
## Calculate the Cosine similarity between the recipes. 
## State which two recipes are the
## most similar based on your analysis.


recipe4_dtm <- DocumentTermMatrix(corpus_recipe4)
matrix_recipe4 <- as.matrix(recipe4_dtm)
cosine_recipe4 <- sim2(matrix_recipe4, method = "cosine")
diag(cosine_recipe4) <- NA
print(cosine_recipe4)
which(cosine_recipe4==max(cosine_recipe4, na.rm = TRUE), arr.ind=TRUE)
## 48th and 26th recipes are the most similar



## QUESTION 5
## Calculate the Euclidean distance between the recipes. 
## State which two recipes arethe most similar based on your analysis. 
## Are these the two recipes you found in the previous part?

euclidean_recipe4 <- dist2(matrix_recipe4, method = "euclidean")
diag(euclidean_recipe4) <- NA
print(euclidean_recipe4)
which(euclidean_recipe4==min(euclidean_recipe4, na.rm = TRUE), arr.ind=T)
## The most similar recipes are the same with the previous question.
## Again, 48th and 26th recipes are the most similar ones. 


## QUESTION 6
## Read the recipes, do they look similar? 
## If not, what might be the potential reasons?

corpus_recipe4[[48]]$content
corpus_recipe4[[26]]$content
## They are not identical texts. But they have big percent similarity. I get these 2 texts compared on comparing 
## websites and these websites analyzed that the similarity percentage between 2 texts is 85%. R program gives us 
## these texts not because they are identical but they have the highest similarity percentage. 




