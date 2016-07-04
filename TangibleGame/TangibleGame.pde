enum GameState {
  GAME, 
    PLACEMENT;
}
GameState currentState = GameState.GAME;

float depthCamera = 2000;

final int scaleConstant = 10;

//Surface for data visualisation 
PGraphics visualisationSurface;
PGraphics topView;
PGraphics scoreBoard;
PGraphics barChart;
//scrollbar
HScrollbar hs;

//Needed object for the game
Plate plate;
Balle balle;
Mover mover;
Cylinder cylinder;

//Processing windows
ImageProcessing imgproc;

void settings() {
  size(700, 700, P3D);
}
void setup() {
  noStroke();
  plate = new Plate(1000, 20, 1000);
  balle = new Balle(40);
  mover = new Mover(plate, balle);
  visualisationSurface = createGraphics(width, height/5, P2D);
  topView = createGraphics(height/5 - 20, height/5 - 20, P2D);
  scoreBoard = createGraphics(height/5 - 40, height/5 - 20, P2D);
  barChart = createGraphics(width - topView.width - scoreBoard.width - 50, height/5 - 40, P2D); 
  hs = new HScrollbar(topView.width + scoreBoard.width + 40, height-25, barChart.width, 15);
  imgproc = new ImageProcessing();
  String []args = {"Image processing window"}; 
  PApplet.runSketch(args, imgproc);
}
void draw() {
  background(200);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);
  if (currentState.equals(GameState.GAME)) {
    pushMatrix();
    //camera(width/2.0, -1000, depthCamera, width/2.0, height/2.0, 0, 0, 1, 0);
    camera(width/2, height/2, depthCamera, 250, 250, 0, 0, 1, 0);
    PVector rotation = imgproc.getRotation();
    plate.display();
    float rotX = -(float)Math.toRadians(rotation.x);
    float rotZ = -(float)Math.toRadians(rotation.y);
    plate.angleX = rotX;
    plate.angleZ = rotZ;
    mover.update();
    mover.checkEdges();
    mover.checkCylinderCollision();
    mover.display();
  } else {
    pushMatrix();
    camera(0, 0, depthCamera, 0, 0, 0, 0, 1, 0);
    plate.display();
    mover.display();
  }
  popMatrix();
  noLights(); //Permet de colorier la surface d'une couleur différente de la balle.
  drawSurface();
  hs.update();
  hs.display();
  PImage vid = imgproc.getVideo();
  vid.resize(160,0);
  image(vid, width-160.0,0.0); 
}
void mouseWheel(MouseEvent event) {
  plate.mouseWheel(event);
}
void mouseDragged() {
  plate.mouseDragged();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentState = GameState.PLACEMENT;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      currentState = GameState.GAME;
    }
  }
}

void mouseClicked() {
  if (currentState.equals(GameState.PLACEMENT)) {
    plate.addCylinder();
  }
}