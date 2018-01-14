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
    tabPanel("Documentation", fluid=TRUE,
             h4("Application Overview"),
             p("This application allows you to enter a phrase and receive a prediction of the next word in the phrase."),
             br(),
             h4("Application Loading"),
             p("After starting the application please wait until the \"Loading lookup data\" message is no longer displayed in the bottom right corner."),
             br(),
             h4("Application Usage"),
             p("To receive a prediction enter your phrase in the textbox and click the \"Predict\" button. The output will be displayed below the \"Predicted Word\" header."),
             br(),
             a("Github Repository", href="https://github.com/dlubac/Coursera-Data-Science-Capstone", target="_blank")
             
             )
  )
)
