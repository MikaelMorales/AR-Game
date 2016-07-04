void sobel(PImage img) {
  float[][] hKernel = { {0, 1, 0 }, 
                        {0, 0, 0 }, 
                        {0, -1, 0 }};

  float[][] vKernel = { {0, 0, 0 }, 
                        {1, 0, -1}, 
                        {0, 0, 0 }};
  color black = color(0);
  color white = color(255);
  imgproc.result.loadPixels();
  //clear the image
  for (int i = 0; i < img.width * img.height; i++) 
    imgproc.result.pixels[i] = black;

  float max=0;
  float[] buffer = new float[img.width * img.height];

  for (int y =0; y< img.height; y++) {  
    for (int x =0; x < img.width; x++) {
      int sum_h = 0;
      int sum_v = 0;

      for (int i=0; i<3; i++) { 
        for (int j=0; j<3; j++) {
          //Check the one-pixel wide border around the image
          if (!(x+i-1 < 0 || x+i-1 > img.width-1 || y+j-1 < 0 || y+j-1 > img.height-1)) {
            sum_h += imgproc.brightness(img.pixels[(y+j-1) * img.width + x+i-1]) * hKernel[i][j];
            sum_v += imgproc.brightness(img.pixels[(y+j-1) * img.width + x+i-1]) * vKernel[i][j];
          }
        }
      }
      //store inside buffer
      float sum = sqrt(sum_h*sum_h + sum_v*sum_v);
      buffer[y*img.width + x] = sum;
      max = max(max, sum);
    }
  }
      //set the result
      for (int y = 2; y < img.height - 2; y++) {  
        for (int x = 2; x < img.width - 2; x++) { 
          if (buffer[y * img.width + x] > (int)(max * 0.3f)) {
            imgproc.result.pixels[y * img.width + x] = white;
          } else {
            imgproc.result.pixels[y * img.width + x] = black;
          }
        }
      }
      
      imgproc.result.updatePixels();
    }