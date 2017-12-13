library(quanteda)
library(ggplot2)

# Read in data
blogs <- readLines("../final/en_US/en_US.blogs.txt")
news <- readLines("../final/en_US/en_US.news.txt")
twitter <- readLines("../final/en_US/en_US.twitter.txt")

# Subset data and combine
subset_blogs <- sample(blogs, size=length(blogs) * 0.01, replace=FALSE)
subset_news <- sample(news, size=length(news) * 0.01, replace=FALSE)
subset_twitter <- sample(twitter, size=length(twitter) * 0.01, replace=FALSE)

combined_data <- c(subset_blogs, subset_news, subset_twitter)

# Clean data
combined_data <- gsub("[^0-9A-Za-z///' ]", " ", combined_data)

# Transform to corpus
combined_data <- corpus(combined_data)

# Initial analysis
dfm_unigram <- dfm(combined_data)
words <- topfeatures(dfm_unigram, length(dfm_unigram))
summary(words)
hist(words, breaks=300, xlab="Word Count")

# Find most common unigrams
top_words_unigram <- topfeatures(dfm_unigram, n=10)
top_words_unigram <- data.frame(keyName=names(top_words_unigram), value=top_words_unigram, row.names=NULL)
top_words_unigram <- top_words_unigram[order(-top_words_unigram$value),]

textplot_wordcloud(dfm_unigram, min.freq=500, random.order=FALSE, rot.per=0.25)

unigram_plot <- ggplot(top_words_unigram, aes(x=reorder(top_words_unigram$keyName, -top_words_unigram$value), y=top_words_unigram$value)) + 
  geom_bar(stat="identity") +
  ggtitle("Most Common Unigrams") +
  xlab("Word") +
  ylab("Occurances")

print(unigram_plot)

# Find most common bigrams
dfm_bigram <- dfm(combined_data, ngrams=2)
top_words_bigram <- topfeatures(dfm_bigram, n=10)
top_words_bigram <- data.frame(keyName=names(top_words_bigram), value=top_words_bigram, row.names=NULL)
top_words_bigram <- top_words_bigram[order(-top_words_bigram$value),]

bigram_plot <- ggplot(top_words_bigram, aes(x=reorder(top_words_bigram$keyName, -top_words_bigram$value), y=top_words_bigram$value)) + 
  geom_bar(stat="identity") +
  ggtitle("Most Common Bigrams") +
  xlab("Word") +
  ylab("Occurances")

print(bigram_plot)

# Find most common trigrams
dfm_trigram <- dfm(combined_data, ngrams=3)
top_words_trigram <- topfeatures(dfm_trigram, n=10)
top_words_trigram <- data.frame(keyName=names(top_words_trigram), value=top_words_trigram, row.names=NULL)
top_words_trigram <- top_words_trigram[order(-top_words_trigram$value),]

trigram_plot <- ggplot(top_words_trigram, aes(x=reorder(top_words_trigram$keyName, -top_words_trigram$value), y=top_words_trigram$value)) + 
  geom_bar(stat="identity") +
  ggtitle("Most Common Trigrams") +
  xlab("Word") +
  ylab("Occurances") +
  theme(axis.text.x = element_text(angle=45, hjust=1))

print(trigram_plot)


