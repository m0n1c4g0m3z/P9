class Surfer {
  int linea;
  float pos;
  float speed;
  color c;
  int shapeType;

  Surfer() {
    reset();
  }

  void reset() {
    linea = int(random(numLineas));
    pos = random(1);
    speed = random(0.001, 0.005);
    c = color(random(255), random(255), random(255), 180);
    shapeType = int(random(3));
  }

  void update() {
    pos += speed;
    if (pos > 1) {
      reset();
    }
  }

  void display() {
    int j = int(pos * (numPuntos - 1));
    float x = map(j, 0, numPuntos, viewX + viewW * 0.1, viewX + viewW * 0.9);
    float yOffset = noise(offsets[linea][j] + time) * 100 - 50;
    float y = map(linea, 0, numLineas, viewY + viewH * 0.1, viewY + viewH * 0.9) + yOffset;
    float wave = sin(time * 0.05 + linea * 0.1) * 15;
    y += wave;
    fill(c);
    noStroke();
    float s = 8;
    switch (shapeType) {
      case 0:
        ellipse(x, y, s, s);
        break;
      case 1:
        triangle(x, y - s / 2, x - s / 2, y + s / 2, x + s / 2, y + s / 2);
        break;
      case 2:
        ellipse(x, y, s * 0.6, s);
        break;
    }
  }

  void displaySobrePlaneta() {
    float cx = width / 2;
    float cy = height / 2;
    float r = min(viewW, viewH) * 0.4;
    int j = int(pos * (numPuntos - 1));
    float lat = map(linea, 0, numLineas, -HALF_PI, HALF_PI);
    float lon = map(j, 0, numPuntos, -PI, PI);
    float x3d = cos(lon + planetaRotacion) * cos(lat);
    float y3d = sin(lat);
    float x = cx + r * x3d;
    float y = cy + r * y3d + noise(offsets[linea][j] + time) * 10;
    fill(c);
    noStroke();
    float s = 6;
    switch (shapeType) {
      case 0:
        ellipse(x, y, s, s);
        break;
      case 1:
        triangle(x, y - s / 2, x - s / 2, y + s / 2, x + s / 2, y + s / 2);
        break;
      case 2:
        ellipse(x, y, s * 0.6, s);
        break;
    }
  }
}
