void filterHue(PImage img) {
  imgproc.tempImage.loadPixels();
  
  color black = color(0, 0, 0);
  color white = color(255,255,255);
  float upperHue = 138;
  float lowerHue = 70; //LES BORNES POUR ISOLER LA COULEUR VERTE
  float upperBrightness = 235;
  float lowerBrightness = 30;
  float upperSaturation = 260;
  float lowerSaturation = 99;  
  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(img.pixels[i]) < upperHue && hue(img.pixels[i]) > lowerHue
        && brightness(img.pixels[i]) < upperBrightness && brightness(img.pixels[i]) > lowerBrightness
        && saturation(img.pixels[i]) < upperSaturation && saturation(img.pixels[i]) > lowerSaturation) {      
      imgproc.tempImage.pixels[i] = white;
    }else{
      imgproc.tempImage.pixels[i] = black;
    }
  }
  imgproc.tempImage.updatePixels();
}