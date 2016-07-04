float totalScore = 0;
float lastScore = 0;
ArrayList<Float> scores = new ArrayList();
int rectangleSize = 5;
float scaleFactor = 1;
long lastTime = System.currentTimeMillis();

void drawSurface() {
  visualisationSurface.beginDraw();
  visualisationSurface.background(200, 173, 127);
  drawTopView();
  drawScoreBoard();
  drawBarChart();
  visualisationSurface.endDraw();
  image(visualisationSurface, 0, 4*height/5);
  image(topView, 10, 4*height/5 + 10); 
  image(scoreBoard, topView.width + 20, 4*height/5 + 10);
  image(barChart, topView.width+scoreBoard.width + 40, 4*height/5 + 10);
}

void drawTopView() {
  topView.beginDraw();
  topView.noStroke();
  topView.background(100, 149, 237);
  topView.translate(topView.width/2, topView.height/2); //Set 0,0 in center of topView

  float scaleWidth = (topView.width/plate.boxWidth);
  float scaleHeight = (topView.height/plate.boxHeight);

  //Dessine la balle
  topView.fill(255, 0, 0);
  topView.ellipse(location.x*scaleWidth, location.z*scaleHeight, 2*balle.radius*scaleWidth, 2*balle.radius*scaleHeight);

  //Dessine les cylindres
  topView.fill(245, 222, 179);
  for (PVector c : plate.cylinders) {
    topView.ellipse(c.x*scaleWidth, c.y*scaleHeight, 2*cylinderBaseSize*scaleWidth, 2*cylinderBaseSize*scaleHeight);
  }
  topView.endDraw();
}

void drawScoreBoard() {
  scoreBoard.beginDraw();
  scoreBoard.background(200, 173, 127);

  scoreBoard.stroke(255);
  scoreBoard.strokeWeight(4);
  scoreBoard.noFill();
  scoreBoard.rect(0, 0, scoreBoard.width, scoreBoard.height);

  scoreBoard.textSize(12);

  scoreBoard.text("Velocity:", 7, scoreBoard.height/2 - 1);
  scoreBoard.text(mover.velocity.mag(), 7, scoreBoard.height/2 + 11);

  scoreBoard.text("Total Score:", 7, 15);
  scoreBoard.text(totalScore, 7, 27);

  scoreBoard.text("Last Score:", 7, scoreBoard.height - 20);
  scoreBoard.text(lastScore, 7, scoreBoard.height - 8);

  scoreBoard.fill(10);

  scoreBoard.endDraw();
}


void drawBarChart() {
  barChart.beginDraw();
  barChart.background(220, 216, 210);
  barChart.fill(0, 0, 255);
  barChart.noStroke();
  if (System.currentTimeMillis() - lastTime > 1000) {
    if (lastScore != totalScore) {
      scores.add(totalScore);
      lastTime = System.currentTimeMillis();
    }
  }

  if (scores.size() > 0) {
    while ((lastScore/scaleFactor)*1.3 > barChart.height) {
      scaleFactor *= 2;
    }
  }

  for (int i = 0; i < scores.size(); i++) {
    for (int j = 0; j < scores.get(i)/(rectangleSize*scaleFactor); j++) {
      barChart.rect(i * (2*rectangleSize)*hs.getPos(), barChart.height - j*7, rectangleSize*hs.getPos(), rectangleSize);
    }
  }

  barChart.endDraw();
}