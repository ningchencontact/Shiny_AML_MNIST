# library(EBImage)
# library(httr)

import_color.image= readImage("~/Downloads/shiny_mnist/output/2_2018-12-14_081819.png")
import_gray.image <- channel(import_color.image,"gray")
# 使用EBImage channel function 轉成灰階
resize_gray.image <- resize(import_gray.image, 28, 28) 
# 將圖片轉成 28*28
trans_gray.image <- array_reshape(1-resize_gray.image,c(1,28*28))
# 將28*28的array轉成list
res=POST(url="http://5f8c233f-8693-4046-9117-98739a2dcf18.southeastasia.azurecontainer.io/score",
         body=list(data = trans_gray.image),
         encode="json")
DisplayRes=httr::content(res)



