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

# Function to predict text
fn_search <- function(df_lookup, raw_input) {
  # Setup predictions varible
  predictions <- df_lookup
  
  # Parse input
  input_tokens <- fn_parse_input(raw_input)
  
  # Get length
  input_length <- length(input_tokens)

  for (i in 1:input_length) {
    predictions <- predictions[predictions[[i]] == input_tokens[i],]
    predictions <- predictions[!is.na(predictions[[i + 1]]),]
  }
  
  if (nrow(predictions) == 0) {
    search_new <- paste(input_tokens[-1], collapse=" ")
    search_new(lookup_table, search_new)
  } else {
    return(predictions)
  }
}

fn_parse_input <- function(input) {
  input <- gsub("[^0-9A-Za-z///' ]", " ", input)
  input_tokens <- tokens(input)
  token_count <- length(input_tokens[[1]])
  
  if (token_count > 3) {
    input_tokens <- input_tokens[[1]][as.numeric(token_count-2):token_count]
  } else {
    input_tokens <- input_tokens[[1]][1:token_count]
  }

  return(input_tokens)
}

fn_get_next_token <- function(suggestions){
  next_token <- NA
  top_suggestion <- suggestions[1,1:4]
  
  for (i in length(top_suggestion):1) {
    if (!is.na(top_suggestion[[i]])) {
      next_token <- top_suggestion[[i]]
      return(as.character(next_token))
    }
  }
  
  return(next_token)
}

# Find most common ngrams
bigrams <- fn_create_ngram(combined_data, 2)
trigrams <- fn_create_ngram(combined_data, 3)
quadgrams <- fn_create_ngram(combined_data, 4)

# Combine most common ngrams into a single table
lookup_table <- rbind(bigrams, trigrams, quadgrams)

