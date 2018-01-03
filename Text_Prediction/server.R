#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Read in ngram lookup data
  lookup_table <- read.csv("data/lookup_table.csv")
  print(head(lookup_table))
  
  observeEvent(input$pred_Button, {
    output$pred_ngram <- renderText({"test"})
  })
  
})
