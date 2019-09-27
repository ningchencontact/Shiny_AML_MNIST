#============= Setting =============
options(shiny.maxRequestSize=30*1024^2) 
Path = '/Users/ningchen/Downloads/shiny_mnist/'

#============= Package =============
library(shiny)
library(shinydashboard)
library(EBImage)
#install.packages("BiocManager") 
#BiocManager::install("EBImage")

#library(stringi)
#library(tensorflow)
#library(keras)
#install_keras()
#============= Traing Model =============
# model <- load_model_hdf5(file.path(Path,"my_keras_mnist_resape.h5"))

#mnist <- dataset_mnist()
#c(train_images, train_labels) %<-% mnist$train
#c(test_images, test_labels) %<-% mnist$test

#train_images <- train_images / 255
#test_images <- test_images / 255

#model <- keras_model_sequential()
#model %>%
#  layer_flatten(input_shape = c(28, 28)) %>%
#  layer_dense(units = 128, activation = 'relu') %>%
#  layer_dense(units = 10, activation = 'softmax')

#model %>% compile(
#  optimizer = 'adam', 
#  loss = 'sparse_categorical_crossentropy',
#  metrics = c('accuracy')
#)

#model %>% fit(train_images, train_labels, epochs = 5)

