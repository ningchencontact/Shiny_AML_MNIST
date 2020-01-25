shinyUI(

  dashboardPage(
    dashboardHeader(title = "MNIST"),
    dashboardSidebar(
      br(),
      # Input: Select a file ----
      fileInput("file", "Choose PNG/JPEG File",
                multiple = FALSE ,
                accept = c('image/png', 'image/jpeg')
                )
    ),
    dashboardBody(
      
      fluidRow(
        box(plotOutput('import_plot'))
      ),
      fluidRow(
        infoBoxOutput("predictBox")
      )
      
    )
  )
  
  
  
  )
