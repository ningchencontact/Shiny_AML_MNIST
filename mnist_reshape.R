#------ Setting -------
Path = '/Users/sun/Desktop'

## x_train: train_images 
## x_test: test_images
## y_train: train_labels
## y_test: test_labels

#==================== Import package ====================
library(tensorflow)
library(keras)

#==================== Import Images ====================
mnist <- dataset_mnist()

c(train_images, train_labels) %<-% mnist$train
c(test_images, test_labels) %<-% mnist$test

#----- Plot in R : MNIST Digits-----
idx = 1
im <- train_images[idx,,]
im <- t(apply(im, 2, rev)) 
image(1:28, 1:28, im, col=gray((0:255)/255) , 
      xaxt="n", main=paste(train_labels[idx])) 

#==================== Images Prepare ====================
# reshape
train_images <- array_reshape(train_images, c(nrow(train_images), 784))
test_images <- array_reshape(test_images, c(nrow(test_images), 784))

# rescale
train_images <- train_images / 255
test_images <- test_images / 255

# one-hot encode
train_labels <- to_categorical(train_labels, 10)
test_labels <- to_categorical(test_labels, 10)

#==================== Model ====================
model <- keras_model_sequential() 
model %>% 
  layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = 'softmax')

summary(model)

#==================== Training and Evaluation ====================
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)

history <- model %>% fit(
  train_images, train_labels, 
  epochs = 30, batch_size = 128, 
  validation_split = 0.2
)

plot(history)

model %>% evaluate(test_images, test_labels)
model %>% predict_classes(test_images)

save_model_hdf5(model, file.path(Path,"my_keras_mnist_resape.h5"))
#=============================================================================================
# Your Image
#=============================================================================================
#==================== Your Digits ====================
library(EBImage)

#------ Import Image -------
import_color.image <- readImage( file.path(Path,"7.png") )
import_gray.image <- channel(import_color.image,"gray")
resize_gray.image <- resize(import_gray.image, 28, 28)
trans_gray.image = transpose(resize_gray.image)

#------ Predict Result -------
your_im <- array( dim=c(1,28,28), data=trans_gray.image )
your_im <- array_reshape(your_im, c(nrow(your_im), 784))
model %>% predict_classes(your_im)

plot(resize_gray.image)


