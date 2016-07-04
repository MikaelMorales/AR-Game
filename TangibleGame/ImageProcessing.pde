import processing.video.*;

class ImageProcessing extends PApplet {
  //Capture cam;
  Movie cam;

  PImage img;
  PImage tempImage;
  PImage result;
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  QuadGraph graph = new QuadGraph();
  
  public void settings() {
    //size(800, 600); //Display for static images
    size(640, 480); //Display for webcam
  }
  public void setup() {
    /*********************************************
     *  Static images setup
     *********************************************/
    //img = loadImage("/Users/Mikael/Documents/TempInfoVisu/TangibleGame/data/board3.jpg");
    //tempImage = createImage(img.width, img.height, RGB);
    //result = createImage(img.width, img.height, RGB);

    /*********************************************
     *  Webcam setup
     *********************************************/
    tempImage = createImage(width, height, RGB);
    result = createImage(width, height, RGB);
    //String[] cameras = Capture.list();
    //if (cameras.length == 0) {
    //println("There are no cameras available for capture.");
    //exit();
    //} else {
    //println("Available cameras:");
    //for (int i = 0; i < cameras.length; i++) {
    //println(i + cameras[i]);
    //}
    //cam = new Capture(this, 640, 480, 30);
    //cam.start();
    //}
    cam = new Movie(this, "/Users/Mikael/Documents/TempInfoVisu/TangibleGame/data/testvideo.mp4"); 
    cam.loop();
  }
  public void draw() {
    /*********************************************
     *  Webcam display
     *********************************************/
    if (cam.available() == true) {
    cam.read();
    }
    img = cam.get();
    /*********************************************
     *  Filters, edge detection and display
     *********************************************/
    filterHue(img); //Write in tempImage
    gaussianBlur(tempImage); //Write in result
    intensityFilter(result); //Write in tempImage
    sobel(tempImage); //Write in result
    image(img, 0, 0);
    intersections = hough(result, 4);
    graph.build(intersections, width, height);
    drawQuad(graph, intersections);
  }
  
  PVector getRotation() {
   return new PVector(graph.getRotationX(), graph.getRotationZ());
  }  
  
  PImage getVideo() {
    return img.copy();
  }
}