library(quanteda)
library(reshape2)

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
  df_top_words <- as.data.frame(transform(df_top_words, keyName = colsplit(keyName, "_", c("1", "2", "3", "4"))))
  
  return(df_top_words)
}

# Function to predict text
fn_search <- function(df_top_words, search_term) {
  df_top_words <- as.data.frame(df_top_words)
  suggestions <- df_top_words[df_top_words$keyName[1] == search_term,]
  suggestions <- head(suggestions[order(-suggestions$value),], 3)

  return(suggestions)
}

fn_parse_input <- function(input) {
  input_tokens <- tokens(input, remove_numbers=TRUE, remove_punct=TRUE)
  token_count <- ntoken(input_tokens)
  
  if (token_count <= 0) {
    print("Invalid input")
  } else if (token_count > 3) {
    input_tokens <- input_tokens[[1]][as.numeric(token_count - 2):token_count]
  } 
  
  return(input_tokens)
}

# Find most common ngrams
bigrams <- fn_create_ngram(combined_data, 2)
trigrams <- fn_create_ngram(combined_data, 3)
quadgrams <- fn_create_ngram(combined_data, 4)

# Combine most common ngrams into a single table
#lookup_table <- rbind(top_words_bigram_split, top_words_trigram_split, top_words_quadgram_split)

