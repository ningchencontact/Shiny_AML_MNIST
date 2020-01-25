shinyServer(function(input, output) {

  #=================== Tab : import ===================
  import_image <- reactive({
    # input$file will be NULL initially. After the user uploads a file, it will be a data frame .
    # The 'datapath' column will contain the local filenames where the data can be found.
    
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    import_color.image <- readImage(inFile$datapath)
    import_gray.image <- channel(import_color.image,"gray")
    resize_gray.image <- resize(import_gray.image, 28, 28)
    trans_gray.image <- transpose(resize_gray.image)
    input_aml <- array_reshape(1-resize_gray.image,c(1,28*28))
    
    return( list(inFile = inFile,
                 import_color.image = import_color.image,
                 resize_gray.image = resize_gray.image,
                 trans_gray.image = trans_gray.image,
                 input_aml = input_aml))
  }) 
  
  
  output$import_plot <- renderPlot({
    if( !is.null( import_image() )){
      plot(import_image()$import_color.image)
      title("Import Image")
    }
  })  
  
  # ===== Output: result ======
  output$predictBox <- renderInfoBox({
    if( !is.null(import_image()) ){
      gray_im <- import_image()$input_aml
      
      res=POST(url="http://5f8c233f-8693-4046-9117-98739a2dcf18.southeastasia.azurecontainer.io/score",
               body=list(data = gray_im ),
               encode="json")
      predict.result=httr::content(res)
      
      infoBox(
        "Predict Result", predict.result, icon = icon("thumbs-up", lib = "glyphicon"),
        color = "blue", fill = TRUE
      )
    }else{
      predict.result = 'No input image' 
      infoBox(
        "", predict.result, icon = icon("thumbs-down", lib = "glyphicon"),
        color = "red", fill = TRUE
      )
    }
    
  })
  
})
