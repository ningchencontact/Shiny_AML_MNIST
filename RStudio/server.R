shinyServer(function(input, output) {

  #=================== Tab : import ===================
  import_image <- reactive({
    # input$file will be NULL initially. After the user uploads a file, it will be a data frame .
    # The 'datapath' column will contain the local filenames where the data can be found.
    
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    #在右側fluidRow 顯示圖像結果
    import_color.image <- readImage(inFile$datapath)
    
    output$import_plot <- renderPlot({
      if( !is.null( import_image() )){
        plot(import_image()$import_color.image)
        title("Import Image")
      }
    })
    
    #將圖片傳到Custom Vision
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
  
  
  
  
  # ===== Output: result ======

  ###https://shuclasscustomvision.cognitiveservices.azure.com/customvision/v3.0/Prediction/6de7e2c3-e4d2-4b93-83e4-aa32f8aa87f9/classify/iterations/Iteration1/image
  ### Set Prediction-Key Header to : 58f227639456446c83d1b49c85089b2f
  ### Set Content-Type Header to : application/octet-stream
  ### Set Body to : <image file>
  
  ## 可能有問題?
  ## 將import_color.image(上傳的影像傳到custom vision)
   output$predictBox <- renderInfoBox({
    if( !is.null(import_image()) ){
      import_color.image <- import_image()$import_color.image
      
      res=POST(url="http://5f8c233f-8693-4046-9117-98739a2dcf18.southeastasia.azurecontainer.io/score",
               body=list(data = import_color.image ),
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
