#------ Setting -------
Path = '/Users/sun/Desktop'

#==================== Import package ====================
library(tensorflow)
library(keras)

#==================== Import Images ====================
mnist <- dataset_mnist()

#==================== Images Prepare ====================
c(train_images, train_labels) %<-% mnist$train
c(test_images, test_labels) %<-% mnist$test

train_images <- train_images / 255
test_images <- test_images / 255

#==================== Model ====================
model <- keras_model_sequential()
model %>%
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 10, activation = 'softmax')

model %>% compile(
  optimizer = 'adam', 
  loss = 'sparse_categorical_crossentropy',
  metrics = c('accuracy')
)

#model %>% fit(train_images, train_labels, epochs = 5)
#score <- model %>% evaluate(test_images, test_labels)
#cat('Test loss:', score$loss, "\n")
#cat('Test accuracy:', score$acc, "\n")

#------ Save/Export Model -------
save_model_hdf5(model, file.path(Path,"my_keras_mnist.h5"))
#model <- load_model_hdf5(file.path(Path,"my_keras_mnist.h5"))


#==================== Images Prepare ====================
class_pred <- model %>% predict_classes(test_images)

test_result = data.frame(
  original_label = test_labels,
  predict_label = class_pred
)

head(test_result)

#=============================================================================================
# Your Image
#=============================================================================================
#==================== Your Digits ====================
#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(EBImage)

#------ Import Image -------
import_color.image <- readImage( file.path(Path,"7.png") )
import_gray.image <- channel(import_color.image,"gray")
resize_gray.image <- resize(import_gray.image, 28, 28)
trans_gray.image = transpose(resize_gray.image)

#------ Predict Result -------
your_im <- array( dim=c(1,28,28), data=trans_gray.image )
model %>% predict_classes(your_im)

#=============================================================================================
# Visualize 
#=============================================================================================
#==================== MNIST Digits ====================
par(mfcol=c(6,6))
par(mar=c(0, 0, 3, 0), xaxs='i', yaxs='i')
for (idx in 1:36) { 
  im <- x_train[idx,,]
  im <- t(apply(im, 2, rev)) 
  image(1:28, 1:28, im, col=gray((0:255)/255), 
        xaxt='n', main=paste(y_train[idx]))
}

#==================== Your Digits ====================
#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(EBImage)

#------ Import Image -------
import_color.image <- readImage( file.path(Path,"7.png") )
import_gray.image <- channel(import_color.image,"gray")
resize_gray.image <- resize(import_gray.image, 28, 28)
trans_gray.image = transpose(resize_gray.image)

#------ Save Gray Image -------
writeImage(trans_gray.image,file=file.path(Path,"gray_7.png"))

#------ Plot Image -------
your_im <- array( dim=c(1,28,28), data=trans_gray.image )
im <- your_im[1,,]
im <- t(apply(im, 2, rev)) 
image(1:28, 1:28, im, col=gray((0:255)/255), 
      xaxt='n', main='a')




#=============================================================================================
# Reference
#=============================================================================================
#library(imager)
#import_color.image = readImage("/Users/sun/Desktop/small.png")
#plot(import_color.image)
#=============================================================================================
# Basic Classification : https://keras.rstudio.com/articles/tutorial_basic_classification.html
# https://stackoverflow.com/questions/31800687/how-to-get-a-pixel-matrix-from-grayscale-image-in-r/31804561