#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(quanteda)
library(reshape2)
library(tidyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Function to parse user input
  fn_parse_input <- function(input) {
    input <- gsub("[^0-9A-Za-z///' ]", " ", input)
    input_tokens <- tokens(input)
    token_count <- ntoken(input_tokens)
    
    if (token_count <= 0) {
      print("Invalid input")
    } else if (token_count > 3) {
      input_tokens <- input_tokens[[1]][as.numeric(token_count - 2):token_count]
    } 
    
    return(input_tokens)
  }
  
  # Function to predict text
  fn_search <- function(df_lookup, search_term) {
    input_tokens <- fn_parse_input(search_term)
    input_length <- length(input_tokens[[1]])
    
    if(input_length == 1) {
      suggestions <- df_lookup[df_lookup$key1 == input_tokens[[1]][1],]
      
    } else if (input_length == 2) {
      suggestions <- df_lookup[df_lookup$key1 == input_tokens[[1]][1],]
      suggestions <- suggestions[suggestions$key2 == input_tokens[[1]][2],]
      suggestions <- suggestions[!is.na(suggestions$key3),]
      
    } else if (input_length == 3) {
      suggestions <- df_lookup[df_lookup$key1 == input_tokens[[1]][1],]
      suggestions <- suggestions[suggestions$key2 == input_tokens[[1]][2],]
      suggestions <- suggestions[suggestions$key3 == input_tokens[[1]][3],]
      suggestions <- suggestions[!is.na(suggestions$key4),]
    } else {
      print("No matches found")
      return(NULL)
    }
    
    if(nrow(suggestions) == 0) {
      tokens_new <- input_tokens[[1]][-1]
      search_new <- paste(tokens_new, sep=" ", collapse=" ")
      fn_search(lookup_table, search_new)
    } else {
      return(suggestions)  
    }
  }
  
  
  # Read in ngram lookup data
  lookup_table <- read.csv("data/lookup_table.csv")
  print(head(lookup_table))
  
  observeEvent(input$pred_Button, {
    # Get text predictions
    predictions <- fn_search(lookup_table, input$userInput)
    predictions <- head(predictions, 1)
    
    
    print(predictions[[2]])
    
    output$pred_ngram <- renderText({words})
  })
  
})
