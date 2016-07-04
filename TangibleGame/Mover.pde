import java.util.*;

PVector location;
float ELASTICITYCONSTANT = 0.7;

class Mover {
  final float normalForce = 1;
  final float mu = 0.2;
  final float frictionMagnitude = normalForce * mu;
  final float gravityConstant = 1;
  PVector velocity;
  PVector gravity;
  PVector friction;
  Plate plate;
  Balle balle;

  Mover(Plate plate, Balle balle) {
    location = new PVector(0, -plate.boxThickness/2 - balle.radius, 0);
    velocity = new PVector(0, 0, 0);
    gravity = new PVector(gravityConstant, 0, gravityConstant);
    friction = new PVector(0, 0, 0);
    this.plate = plate;
    this.balle = balle;
    scores.add(0.0);
  }
  void update() { 
    friction = velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    gravity.x = sin(plate.angleZ) * gravityConstant;
    gravity.z = -sin(plate.angleX) * gravityConstant;
    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);
  }
  void display() {
    if (currentState.equals(GameState.GAME)) {
      translate(location.x, location.y, location.z);
      balle.drawBalle();
    } else {
      fill(0, 255, 0);
      ellipse(location.x, location.z, balle.radius+40, balle.radius+40); // pourquoi utiliser ellipse.
    }
  }
  void checkEdges() {
    if (location.x >= plate.boxWidth/2 || location.x <= - plate.boxWidth/2) {
      lastScore = totalScore;
      totalScore -= velocity.mag();
      if (location.x > plate.boxWidth/2) {
        location.x = plate.boxWidth/2;
      }
      if (location.x < - plate.boxWidth/2) {
        location.x = - plate.boxWidth/2;
      }
      velocity.x *= -ELASTICITYCONSTANT;
    } 

    if (location.z >= plate.boxHeight/2 || location.z <= -plate.boxHeight/2) {
      lastScore = totalScore;
      totalScore -= velocity.mag();
      if (location.z > plate.boxHeight/2) {
        location.z = plate.boxHeight/2;
      }
      if (location.z < -plate.boxHeight/2) {
        location.z = -plate.boxHeight/2;
      }
      velocity.z *= -ELASTICITYCONSTANT;
    }
  }

  void checkCylinderCollision() {
    Iterator<PVector> iter = plate.cylinders.iterator();
    while(iter.hasNext()) {
      PVector c = iter.next();
      PVector distance = new PVector(c.x - location.x, c.y - location.z);
      if (distance.mag() < balle.radius + cylinderBaseSize/2) {
        lastScore = totalScore;
        totalScore += velocity.mag();
        PVector tempVelocity = new PVector(velocity.x, velocity.z);
        PVector n = new PVector(location.x - c.x, location.z - c.y);
        PVector unit = n.copy().normalize();
        PVector tempLoc = c.copy().add(unit.copy().mult(n.mag()+balle.radius/4));
        location = new PVector(tempLoc.x, -plate.boxThickness/2 - balle.radius, tempLoc.y);
        tempVelocity.sub(unit.mult(2 * (tempVelocity.copy().dot(unit)))).mult(ELASTICITYCONSTANT);
        velocity = new PVector(tempVelocity.x, 0, tempVelocity.y);
        iter.remove();
      }
    }
  }
}