ArrayList<PVector> hough(PImage edgeImg, int nLines) {
  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();  
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((imgproc.result.width + imgproc.result.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge 
  // image), store all possible (r, phi) pairs describing lines going 
  // through the point.
  int minVotes = 170;
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
        for (int phi=0; phi < phiDim; phi++) {
          float r = x * cos(phi*discretizationStepsPhi) + y * sin(phi*discretizationStepsPhi); 
          r /= discretizationStepsR;
          r += (rDim-1)/2;
          accumulator[((phi+1) * (rDim+2) + (int)(r+1))] += 1;
        }
      }
    }
  }
  // size of the region we search for a local maximum
  int neighbourhood = 30;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            // check we are not outside the image
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }

  bestCandidates.sort(new HoughComparator(accumulator));

  for (int i = 0; i < nLines; i++) {
    if (i < bestCandidates.size()) {
      int idx = bestCandidates.get(i);
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      intersections.add(new PVector(r, phi));
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
      // Finally, plot the lines
      imgproc.stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          imgproc.line(x0, y0, x1, y1);
        else if (y2 > 0)
          imgproc.line(x0, y0, x2, y2);
        else
          imgproc.line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            imgproc.line(x1, y1, x2, y2);
          else
            imgproc.line(x1, y1, x3, y3);
        } else imgproc.line(x2, y2, x3, y3);
      }
    }
  }
  return intersections;
}

ArrayList<PVector> getIntersections(ArrayList<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      // draw the intersection
      float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
      int x = (int)((line2.x*sin(line1.y) - line1.x * sin(line2.y))/d);
      int y = (int)((-line2.x*cos(line1.y) + line1.x * cos(line2.y))/d); 
      intersections.add(new PVector(x, y));
      imgproc.fill(255, 128, 0);
      imgproc.ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}

PVector intersection(PVector line1, PVector line2) {
  // draw the intersection of two lines
  float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
  int x = (int)((line2.x*sin(line1.y) - line1.x * sin(line2.y))/d);
  int y = (int)((-line2.x*cos(line1.y) + line1.x * cos(line2.y))/d); 
  imgproc.fill(255, 128, 0);
  imgproc.ellipse(x, y, 10, 10);
  return new PVector(x, y);
}