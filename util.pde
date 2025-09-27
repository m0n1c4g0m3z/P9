void calcularVista() {
  float windowRatio = float(width) / float(height);
  float targetRatio = 9.0 / 16.0;
  if (windowRatio > targetRatio) {
    viewH = height;
    viewW = viewH * targetRatio;
    viewX = (width - viewW) / 2;
    viewY = 0;
  } else {
    viewW = width;
    viewH = viewW / targetRatio;
    viewX = 0;
    viewY = (height - viewH) / 2;
  }
}

void dibujarOndasNormales() {
  if (dist(mouseX, mouseY, width / 2, height / 2) < min(viewW, viewH) / 4) {
    lineColor = color(random(255), random(255), random(255));
  } else if (mousePressed) {
    lineColor = color(random(255), random(255), random(255));
  } else {
    lineColor = color(255);
  }

  stroke(lineColor, 150);
  for (int i = 0; i < numLineas; i++) {
    beginShape();
    for (int j = 0; j < numPuntos; j++) {
      float x = map(j, 0, numPuntos, viewX + viewW * 0.1, viewX + viewW * 0.9);
      float yOffset = noise(offsets[i][j] + time) * 100 - 50;
      float y = map(i, 0, numLineas, viewY + viewH * 0.1, viewY + viewH * 0.9) + yOffset;
      float wave = sin(time * 0.05 + i * 0.1) * 15;
      y += wave;
      curveVertex(x, y);
      offsets[i][j] += 0.01;
    }
    endShape();
  }
}

void dibujarPlaneta() {
  float cx = width / 2;
  float cy = height / 2;
  float r = min(viewW, viewH) * 0.4;
  stroke(100, 200, 255, 150);
  noFill();

  for (int i = 0; i < numLineas; i++) {
    float lat = map(i, 0, numLineas, -HALF_PI, HALF_PI);
    beginShape();
    for (int j = 0; j < numPuntos; j++) {
      float lon = map(j, 0, numPuntos, -PI, PI);
      float x3d = cos(lon + planetaRotacion) * cos(lat);
      float y3d = sin(lat);
      float z3d = sin(lon + planetaRotacion) * cos(lat);
      float x = cx + r * x3d;
      float y = cy + r * y3d + noise(offsets[i][j] + time) * 10;
      curveVertex(x, y);
      offsets[i][j] += 0.01;
    }
    endShape();
  }

  noFill();
  stroke(255, 60);
  ellipse(cx, cy, r * 2, r * 2 * 0.95);
}
