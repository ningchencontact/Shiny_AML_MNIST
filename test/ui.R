shinyUI(

  dashboardPage(
    dashboardHeader(title = "AzureML with MNIST"),
    dashboardSidebar(
      br(),
      actionButton("checkButton_2", "Upload New File"),
      span(class = "text-muted",
           paste0(stri_dup(intToUtf8(160), 6), "Please click [Upload New File]"),
           br(),
           paste0(stri_dup(intToUtf8(160), 6),"before you upload")
      ),
      
      # Input: Select a file ----
      fileInput("file", "Choose PNG/JPEG File",
                multiple = FALSE ,
                accept = c('image/png', 'image/jpeg')
                ),

      span( strong(paste0(stri_dup(intToUtf8(160), 6), "Check Image")) ),
      actionButton("checkButton_1", "File OK & Go Predict")
    ),
    dashboardBody(
      
      fluidRow(
        box(plotOutput('import_plot'))
#        box(plotOutput('gray_plot')
        )
        #box(verbatimTextOutput('import_plot'))
      ),
      fluidRow(
        infoBoxOutput("predictBox")
      )
      
    )
  )
  
  
  
  )
