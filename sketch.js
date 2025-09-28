let numLineas = 100;
let numPuntos = 80;
let offsets = [];
let time = 0;
let surfers = [];
let numSurfers = 200;
let viewX, viewY, viewW, viewH;
let modoPlaneta = false;
let planetaRotacion = 0;

let video;
let mostrarVideo = false;

function preload() {
  video = createVideo("https://dl.dropboxusercontent.com/scl/fi/qwtenazm9o9any676tnp0/P9.mp4?rlkey=irt8duuq14k1z6o7e849jokl1&st=rixixehn");
  video.hide();
  video.volume(0);
  video.loop();
  video.stop();
}

function setup() {
  createCanvas(windowWidth, windowHeight);
  background(0);
  calcularVista();
  for (let i = 0; i < numLineas; i++) {
    offsets[i] = [];
    for (let j = 0; j < numPuntos; j++) {
      offsets[i][j] = random(1000);
    }
  }
  for (let i = 0; i < numSurfers; i++) {
    surfers.push(new Surfer());
  }
}

function draw() {
  background(0, 25);

  if (mostrarVideo) {
    let w = height * (9 / 16);
    let h = height;
    image(video, width / 2 - w / 2, 0, w, h);
  }

  stroke(255, 60);
  noFill();
  strokeWeight(1);
  for (let i = 0; i < numLineas; i++) {
    beginShape();
    for (let j = 0; j < numPuntos; j++) {
      let x = map(j, 0, numPuntos, viewX + viewW * 0.1, viewX + viewW * 0.9);
      let yOffset = noise(offsets[i][j] + time) * 100 - 50;
      let y = map(i, 0, numLineas, viewY + viewH * 0.1, viewY + viewH * 0.9) + yOffset;
      let wave = sin(time * 0.05 + i * 0.1) * 15;
      y += wave;
      curveVertex(x, y);
      offsets[i][j] += 0.01;
    }
    endShape();
  }

  for (let s of surfers) {
    s.update();
    if (!modoPlaneta) s.display();
    else s.displaySobrePlaneta();
  }

  time += 0.01;
  planetaRotacion += 0.01;
}

function keyPressed() {
  if (keyCode === RIGHT_ARROW) modoPlaneta = true;
  if (keyCode === LEFT_ARROW) modoPlaneta = false;
  if (key === ' ') {
    mostrarVideo = !mostrarVideo;
    if (mostrarVideo) video.play();
    else video.stop();
  }
}

function calcularVista() {
  let windowRatio = width / height;
  let targetRatio = 9 / 16;
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

class Surfer {
  constructor() {
    this.reset();
  }
  reset() {
    this.linea = int(random(numLineas));
    this.pos = random(1);
    this.speed = random(0.001, 0.005);
    this.c = color(255, 180);
    this.shapeType = int(random(3));
  }
  update() {
    this.pos += this.speed;
    if (this.pos > 1) this.reset();
  }
  display() {
    let j = int(this.pos * (numPuntos - 1));
    let x = map(j, 0, numPuntos, viewX + viewW * 0.1, viewX + viewW * 0.9);
    let yOffset = noise(offsets[this.linea][j] + time) * 100 - 50;
    let y = map(this.linea, 0, numLineas, viewY + viewH * 0.1, viewY + viewH * 0.9) + yOffset;
    y += sin(time * 0.05 + this.linea * 0.1) * 15;
    fill(this.c);
    noStroke();
    let s = 8;
    if (this.shapeType === 0) ellipse(x, y, s, s);
    else if (this.shapeType === 1) triangle(x, y - s / 2, x - s / 2, y + s / 2, x + s / 2, y + s / 2);
    else ellipse(x, y, s * 0.6, s);
  }
  displaySobrePlaneta() {
    let cx = width / 2;
    let cy = height / 2;
    let r = min(viewW, viewH) * 0.4;
    let j = int(this.pos * (numPuntos - 1));
    let lat = map(this.linea, 0, numLineas, -HALF_PI, HALF_PI);
    let lon = map(j, 0, numPuntos, -PI, PI);
    let x3d = cos(lon + planetaRotacion) * cos(lat);
    let y3d = sin(lat);
    let x = cx + r * x3d;
    let y = cy + r * y3d + noise(offsets[this.linea][j] + time) * 10;
    fill(this.c);
    noStroke();
    let s = 6;
    if (this.shapeType === 0) ellipse(x, y, s, s);
    else if (this.shapeType === 1) triangle(x, y - s / 2, x - s / 2, y + s / 2, x + s / 2, y + s / 2);
    else ellipse(x, y, s * 0.6, s);
  }
}