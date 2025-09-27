int numLineas = 100;
int numPuntos = 80;
float[][] offsets;
float time = 0;
color lineColor;
ArrayList<Surfer> surfers = new ArrayList<Surfer>();
int numSurfers = 200;
float viewX, viewY, viewW, viewH;
boolean modoPlaneta = false;
float planetaRotacion = 0;

void setup() {
  fullScreen();
  background(0);
  offsets = new float[numLineas][numPuntos];
  lineColor = color(255);
  calcularVista();
  for (int i = 0; i < numLineas; i++) {
    for (int j = 0; j < numPuntos; j++) {
      offsets[i][j] = random(1000);
    }
  }
  for (int i = 0; i < numSurfers; i++) {
    surfers.add(new Surfer());
  }
}

void draw() {
  fill(0, 20);
  rect(0, 0, width, height);
  noFill();

  if (keyPressed && keyCode == RIGHT) {
    modoPlaneta = true;
  } else if (keyPressed && keyCode == LEFT) {
    modoPlaneta = false;
  }

  if (!modoPlaneta) {
    dibujarOndasNormales();
    for (Surfer s : surfers) {
      s.update();
      s.display();
    }
  } else {
    dibujarPlaneta();
    for (Surfer s : surfers) {
      s.update();
      s.displaySobrePlaneta();
    }
  }

  time += 0.01;
  planetaRotacion += 0.01;
}

void windowResized() {
  calcularVista();
}
