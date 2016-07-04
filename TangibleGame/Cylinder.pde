float cylinderBaseSize = 50;
class Cylinder {
  float cylinderHeight = 120;
  int cylinderResolution = 40;
  PShape openCylinder = new PShape();
  PShape bottomCylinder = new PShape();
  PShape topCylinder = new PShape();
  Boolean isValid = true;

  Cylinder() {
    float angle;
    float[] x = new float[cylinderResolution + 1];
    float[] y = new float[cylinderResolution + 1];
    //get the x and y position on a circle for all the sides
    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    }
    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    //draw the border of the cylinder
    for (int i = 0; i < x.length; i++) {
      openCylinder.vertex(x[i], y[i], 0);
      openCylinder.vertex(x[i], y[i], cylinderHeight);
    }
    openCylinder.endShape();

    //bottomCylinder
    bottomCylinder = createShape();
    bottomCylinder.beginShape(TRIANGLE_FAN);
    bottomCylinder.vertex(0, 0, 0);
    for (int i = 0; i < x.length; i++) {
      bottomCylinder.vertex(x[i], y[i], 0);
    }
    bottomCylinder.endShape();

    //topCylinder
    topCylinder = createShape();
    topCylinder.beginShape(TRIANGLE_FAN);
    topCylinder.vertex(0, 0, cylinderHeight);
    for (int i = 0; i < x.length; i++) {
      topCylinder.vertex(x[i], y[i], cylinderHeight);
    }
    topCylinder.endShape();
  }
  void drawCylinder() {
    shape(openCylinder);
    shape(bottomCylinder);
    shape(topCylinder);
  }
}