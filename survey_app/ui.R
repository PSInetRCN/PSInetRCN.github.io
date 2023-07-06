
fluidPage(
  theme = bs_theme(version = 3),
  surveyOutput(df = df,
               survey_title = "Pre-submission survey",
               survey_description = h4(HTML("Thank you for your interest in contributing to PSInet. Please complete the following form <b>for a single dataset</b> and we will contact you with further submission details.")),
               theme = "#348DBC")
)
