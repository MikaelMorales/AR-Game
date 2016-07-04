void intensityFilter(PImage img) {
  imgproc.tempImage.loadPixels();
  color black = color(0, 0, 0);
  color white = color(255,255,255);
  float upperBrightness = 235;
  float lowerBrightness = 30; 
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) < upperBrightness && brightness(img.pixels[i]) > lowerBrightness) {      
      imgproc.tempImage.pixels[i] = white;
    }else{
      imgproc.tempImage.pixels[i] = black;
    }
  }
  imgproc.tempImage.updatePixels();
}