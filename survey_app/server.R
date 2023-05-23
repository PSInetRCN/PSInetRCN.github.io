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
function(input, output, session) {

  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Thank you. We'll be in touch shortly with next steps",
      "Please reach out to Jessica Guo (jessicaguo@arizona.edu) or Michael Benson (micbenso@iu.edu) with any questions. "
    ))
  })

}
