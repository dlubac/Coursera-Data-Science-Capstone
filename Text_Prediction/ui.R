#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Text Prediction",
    tabPanel("Prediction", fluid=TRUE, align="center",
             fluidRow(
               h4("Enter a phrase"),
               textInput("userInput", ""),
               actionButton("pred_Button", "Predict")
             ),
             br(),
             fluidRow(
               h4("Predicted word"),
               textOutput("pred_ngram")
             )),
    tabPanel("Documentation", fluid=TRUE)
  )
)
