class Plate {
  float boxWidth;
  float boxThickness;
  float boxHeight;
  float angleY = 0;
  float angleX = 0;
  float angleZ = 0;
  float speedAngle = 0.1;
  ArrayList<PVector> cylinders = new ArrayList<PVector>();

  Plate(float x, float y, float z ) {
    boxWidth = x;
    boxThickness = y;
    boxHeight = z;
  }

  void display() {
    if (currentState.equals(GameState.GAME)) {
      translate(width/2, height/2, 0);
      rotateX(plate.angleX);
      rotateZ(plate.angleZ);
      fill(240, 109, 109);
      box(boxWidth, boxThickness, boxHeight);
      noFill();
      for (PVector v : cylinders) {
        pushMatrix();
        rotateX(PI/2);
        translate(v.x, v.y, boxThickness/2);
        fill(196);
        Cylinder cylinder = new Cylinder();
        cylinder.drawCylinder();
        popMatrix();
      }
    } else {
      fill(190);
      rect(-boxWidth/2, -boxHeight/2, boxWidth, boxHeight); // pourquoi utiliser rect?
      for (PVector v : cylinders) {
        pushMatrix();
        translate(v.x, v.y, boxThickness/2);
        fill(67, 65, 65);
        Cylinder cylinder = new Cylinder();
        cylinder.drawCylinder();
        popMatrix();
      }
    }
  }

  void mouseDragged() {
    if (currentState.equals(GameState.GAME)) {
      if (pmouseY - mouseY > 0) {
        if (angleX < PI/3) { 
          angleX += speedAngle;
        } else {
          angleX = PI/3;
        }
      } else if (pmouseY - mouseY < 0) {
        if (angleX > -PI/3) {
          angleX -= speedAngle;
        } else {
          angleX = -PI/3;
        }
      } 
      if (pmouseX - mouseX < 0) {
        if (angleZ < PI/3) {
          angleZ += speedAngle;
        } else {
          angleZ = PI/3;
        }
      } else if (pmouseX - mouseX > 0) {
        if (angleZ > -PI/3) {
          angleZ -= speedAngle;
        } else {
          angleZ = -PI/3;
        }
      }
    }
  }

  void mouseWheel(MouseEvent event) {
    float e = event.getCount();  
    float maxSpeed = 0.4;
    float minSpeed = 0.02;
    float speedChange = 0.02;
    if (currentState.equals(GameState.GAME)) {
      if (e > 0) {
        speedAngle += speedChange;
        if (speedAngle > maxSpeed) {
          speedAngle = maxSpeed;
        }
      } else if (e < 0) {
        speedAngle -= speedChange;
        if (speedAngle < minSpeed) {
          speedAngle = minSpeed;
        }
      }
    }
  }

  void addCylinder() {
    float widthRatio = depthCamera/width; // BESOIN DE CE RATIO A CAUSE DE LA POSITION DE LA CAMERA
    float heightRatio = depthCamera/height; // a cause des distances, qui sont pas égales vu de loins que de près
    float xPos = (mouseX-(width/2)) * widthRatio;
    float yPos = (mouseY-(height/2)) * heightRatio;
    float radiusCylinder = cylinderBaseSize/2;
    if (mouseX >= (width/2 + radiusCylinder - boxWidth/(2*widthRatio)) // pour ne pas dessiner or de la plaque.
      && mouseX <= (width/2 - radiusCylinder + boxWidth/(2*widthRatio))
      && mouseY >= (height/2 + radiusCylinder - boxHeight/(2*heightRatio))
      && mouseY <= (height/2 - radiusCylinder + boxHeight/(2*heightRatio))) {

      PVector distanceFromBalle = new PVector(location.x - xPos, location.z - yPos);
      boolean clearCylinders = true; //Pas de cylinder l'un sur l'autre
      if (distanceFromBalle.mag() > balle.radius + cylinderBaseSize/2) { //Pas ajouter de cylinder SUR la balle      
        for (PVector c : cylinders) {
          PVector distanceCylinders = new PVector(c.x - xPos, c.y - yPos);
          if (distanceCylinders.mag() < cylinderBaseSize*2) { //Pas d'empillement de cylindre
            clearCylinders = false;
          }
        }
        if (clearCylinders)
          cylinders.add(new PVector(xPos, yPos));
      }
    }
  }
}