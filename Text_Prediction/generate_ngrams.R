library(quanteda)
library(reshape2)
library(tidyr)

# Read in data
blogs <- readLines("../final/en_US/en_US.blogs.txt")
news <- readLines("../final/en_US/en_US.news.txt")
twitter <- readLines("../final/en_US/en_US.twitter.txt")

# Sample, subset, combine, and clean data
subset_blogs <- sample(blogs, size=length(blogs) * 0.01, replace=FALSE)
subset_news <- sample(news, size=length(news) * 0.01, replace=FALSE)
subset_twitter <- sample(twitter, size=length(twitter) * 0.01, replace=FALSE)

combined_data <- c(subset_blogs, subset_news, subset_twitter)
combined_data <- gsub("[^0-9A-Za-z///' ]", " ", combined_data)

# Convert date to corpus
combined_data <- corpus(combined_data)

# Find the most common ngrams in a corpus
fn_create_ngram <- function(corpus_data, ngram){
  dfm_ngram <- dfm(corpus_data, ngrams = ngram)
  top_words <- topfeatures(dfm_ngram, n=length(dfm_ngram))
  df_top_words <- data.frame(keyName=names(top_words), value=top_words, row.names=NULL)
  df_top_words <- as.data.frame(separate(df_top_words, keyName, into=c("key1", "key2", "key3", "key4"), sep="_", remove=TRUE))
  
  return(df_top_words)
}

# Find most common ngrams
bigrams <- fn_create_ngram(combined_data, 2)
trigrams <- fn_create_ngram(combined_data, 3)
quadgrams <- fn_create_ngram(combined_data, 4)

# Combine most common ngrams into a single table
lookup_table <- rbind(bigrams, trigrams, quadgrams)

# Write table
write.csv(lookup_table, file="lookup_table.csv", sep=",")
