library(readr)
library(dplyr)
library(shiny)
library(shinysurveys)
library(googlesheets4)

df <- read_csv("questions.csv")


# Extend types of inputs to checkbox
extendInputType(input_type = "checkbox", {
  shiny::checkboxGroupInput(
    inputId = surveyID(),
    label = surveyLabel(),
    choices = surveyOptions()
  ) 
})