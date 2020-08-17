## CS766 Spring 2019

## Homework 6

YJC - ychuang6@wisc.edu

### Challenge 1a

I used the function "dir" to list the content of the folder and identified file names containing the extension ".jpg".
With the identified files, I used a loop to save all images in the respective grayscale and rgb stacks.
Grayscale images are obtained by using rgb2gray function.

I use 1 as half_window_size to get window square of 3x3. 

When generating the index map, I did the modified laplacian function by applying filter of [-1, 2 -1] in x and y directions of the gray scale images. 
The absolute sum of x and y direction filtered images are then pass through a convolution filter containing the value 1 only in order to get the sum of the created window size for the center of each window. 
This is then filtered by average filter of 25x25. I used the size 25 since there are 25 images in total and a small averaging filter size were not able to filter out noises. 


### Challenge 1b

In the refocusApp, I started by selecting a random image, then obtain image height, width and dimension values from this image as well as using it as the first image to be rendered. 
The select and image rendering steps are embedded inside a while loop. 
The app will terminate when user select region outside the render image area. 