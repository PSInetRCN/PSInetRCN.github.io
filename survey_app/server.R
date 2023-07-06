function(input, output, session) {

  renderSurvey()

  observeEvent(input$submit, {
    
    # Retrieve existing datasheet
    sheet_url <- "https://docs.google.com/spreadsheets/d/14wDlPzgNjRf7eKpNRgfgn955Mk2nFsGXJWI51Pan2Z4/edit#gid=0"
    previous <- read_sheet(sheet_url)
    
    # Obtain and and append submitted results
    response <- getSurveyData(custom_id = input$email,
                              include_dependencies = FALSE)
    updated <- bind_rows(previous, response)
    
    # Write back to Google sheet
    write_sheet(updated, ss = sheet_url, sheet = 'Sheet1')
    
    # Show submission message
    showModal(modalDialog(
      title = "Thank you. We'll be in touch shortly with next steps",
      "Please reach out to Jessica Guo (jessicaguo@arizona.edu) and Michael Benson (micbenso@iu.edu) with any questions. "
    ))
  })
  
}
