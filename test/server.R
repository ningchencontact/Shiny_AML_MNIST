shinyServer(function(input, output) {
  
  #=================== Action Button ===================
  values <- reactiveValues(new_image = FALSE)
  observe({
    if (input$checkButton_1 == 0) return()
    values$new_image = TRUE
  })
  observe({
    if (is.null(input$checkButton_2) || input$checkButton_2 == 0)
      return()
    values$new_image = FALSE
  })
  
  #=================== Tab : import ===================
  import_image <- reactive({
    # input$file will be NULL initially. After the user uploads a file, it will be a data frame .
    # The 'datapath' column will contain the local filenames where the data can be found.
    # ?? 何時生成 'datapath' column
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    import_color.image <- readImage(inFile$datapath)
    # 從ui.R取得的彩色照片
    import_gray.image <- channel(import_color.image,"gray")
    # 使用EBImage channel function 轉成灰階
    resize_gray.image <- resize(import_gray.image, 28, 28) 
    # 將圖片轉成 28*28
    trans_gray.image <- array_reshape(1-resize_gray.image,c(1,28*28))
    # 將28*28的array轉成list
    res=POST(url="http://5f8c233f-8693-4046-9117-98739a2dcf18.southeastasia.azurecontainer.io/score",
             body=list(data = b),
             encode="json")
    DisplayRes=httr::content(res)

    return( list(inFile = inFile,
                 import_color.image = import_color.image,
                 resize_gray.image = resize_gray.image,
                 trans_gray.image = trans_gray.image,
                 DisplayRes = DisplayRes))
  }) 
  
#  import_filename <- reactive({
#    if( values$new_image && !is.null( import_image() )){
      
#      import.filename = stringi::stri_extract_first(str = import_image()$inFile$name, regex = ".*(?=\\.)")
      
#      filename_1 = paste0(unlist(strsplit(import.filename, ".", fixed = TRUE))[1],'_',substr(Sys.time(),1,10),'_',gsub(':','',substr(Sys.time(),12,19)),'.png')
#      filename_2 = paste0('gray_',substr(Sys.time(),1,10),'_',gsub(':','',substr(Sys.time(),12,19)),'.png')
#    }
#    return( list(filename_1=filename_1,filename_2=filename_2) )
#  }) 
  
  observe({
    # Run whenever checkButton is pressed
    if( values$new_image && !is.null( import_image() )){
      import_color.image = import_image()$import_color.image
      resize_gray.image = import_image()$resize_gray.image
      
      dir.create(file.path(Path, "output"), showWarnings = FALSE)
      writeImage(import_color.image,file=file.path(Path,'output',import_filename()$filename_1))
#      writeImage(resize_gray.image,file=file.path(Path,'output',import_filename()$filename_2))
    }
  }) 


  output$import_plot <- renderPlot({
    if( !is.null( import_image() )){
      plot(import_image()$import_color.image)
      title("Import Image")
    }
  })  
    
#  output$gray_plot <- renderPlot({
#    if( !is.null( import_image() )){
      #plot(import_image()$resize_gray.image)
      
#      gray_im <- import_image()$input_keras[1,,]
#      gray_im <- t(apply(gray_im, 2, rev)) 
#      image(1:28, 1:28, gray_im, col=gray((0:255)/255), 
#            xaxt='n', main='Input Keras')
      
#    }
#  })
  
 # ===== Output: result ======
   output$predictBox <- renderInfoBox({
    if( values$new_image && !is.null(import_image()) ){
      predict.result = res
      infoBox(
        "Predict Result", DisplayRes, icon = icon("thumbs-up", lib = "glyphicon"),
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

  
  #output$test <- renderPrint({
  #  import_color.image = import_image()$import_color.image
  #  if(input$checkButton && !is.null( import_color.image )){
  #    import_filename()
  #  }
  #})
  

  
})
