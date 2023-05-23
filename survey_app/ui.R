#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
fluidPage(

  surveyOutput(df = df,
               survey_title = "Pre-submission survey",
               survey_description = "Thank you for your interest in contributing data to PSInet. Please complete the following form and we will contact you with further submission details.",
               theme = "#348DBC")
)
