class Balle {
  float radius;
  float r = 0;
  float g = 255;
  float b = 0;

  Balle(float radius) {
    this.radius = radius;
  }

  void drawBalle() {
    strokeWeight(0);
    fill(r, g, b);
    sphere(radius);
  }

  void setRayon(float radius) {
    this.radius = radius;
  }

  void setColor(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}