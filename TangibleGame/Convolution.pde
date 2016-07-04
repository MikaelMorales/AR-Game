void convolute(PImage img) {
  float[][] kernel = {{ 0, 0, 0 }, 
                      { 0, 2, 0 }, 
                      { 0, 0, 0 }};

  transformAlgo(img, kernel, 1.f);
}

void gaussianBlur(PImage img) {
  float[][] kernel = {{ 9, 12, 9 }, 
                      { 12, 15, 12 }, 
                      { 9, 12, 9 }};

  transformAlgo(img, kernel, 100);
}

void transformAlgo(PImage img, float[][] kernel, float weight) {
  imgproc.result.loadPixels();
  float convolution = 0;
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {

      convolution = 0;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          //Check the one-pixel wide border around the image
          if (!(x+i-1 < 0 || x+i-1 > img.width-1 || y+j-1 < 0 || y+j-1 > img.height-1)) {
            convolution += imgproc.brightness(img.pixels[(y+j-1) * img.width + x+i-1]) * kernel[i][j];
          }
        }
      }
      int c = (int)(convolution/weight);
      int col = getIntFromColor(c,c,c);
      imgproc.result.pixels[y * img.width + x] = col;
    }
  }
  imgproc.result.updatePixels();
}

int getIntFromColor(float Red, float Green, float Blue){
    int R = Math.round(255 * Red);
    int G = Math.round(255 * Green);
    int B = Math.round(255 * Blue);

    R = (R << 16) & 0x00FF0000;
    G = (G << 8) & 0x0000FF00;
    B = B & 0x000000FF;

    return 0xFF000000 | R | G | B;
}