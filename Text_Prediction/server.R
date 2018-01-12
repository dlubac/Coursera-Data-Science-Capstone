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
shinyServer(function(input, output, session) {
  
  # Function to parse user input
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
  
  # Function to predict text
  fn_search <- function(df_lookup, raw_input) {
    # Setup predictions varible
    predictions <- df_lookup
    
    # Parse input
    input_tokens <- fn_parse_input(raw_input)
    
    # Get length
    input_length <- length(input_tokens)
    
    for (i in 1:input_length) {
      predictions <- predictions[predictions[[i + 1]] == input_tokens[i],]
      predictions <- predictions[!is.na(predictions[[i + 2]]),]
    }
    
    if (nrow(predictions) == 0 & length(input_tokens) > 1) {
      search_new <- paste(input_tokens[-1], collapse=" ")
      fn_search(lookup_table, search_new)

    } else {
      return(predictions)
    }
  }
  
  # Function to get the next token for a phrase
  fn_get_next_token <- function(suggestions){
    next_token <- NA
    top_suggestion <- suggestions[1,2:5]
    
    for (i in length(top_suggestion):1) {
      if (!is.na(top_suggestion[[i]])) {
        next_token <- top_suggestion[[i]]
        return(as.character(next_token))
      }
    }
    
    return(next_token)
  }
  
  # Read in ngram lookup data
  withProgress(message = "Loading lookup data", value=1, {
    lookup_table <- data.table::fread("data/lookup_table.csv")
  })

  observeEvent(input$pred_Button, {
    # Check for invalid input and get a prediction if input is valid
    if (is.na(fn_parse_input(input$userInput))) {
      updateTextInput(session, "userInput", value="Please enter a phrase")
      output$pred_ngram <- renderText("")
      
    } else {
      # Get text prediction
      predictions <- fn_search(lookup_table, input$userInput)
      next_token <- fn_get_next_token(predictions)
  
      # Output prediction
      if (is.na(next_token)) {
        output$pred_ngram <- renderText("No prediction could be made")
      } else {
        output$pred_ngram <- renderText(print(next_token))
      }
    }
  })
})
