function setup() {
  createCanvas(windowWidth, windowHeight);
  background(0);
}

function draw() {
  fill(255);
  noStroke();
  ellipse(mouseX, mouseY, 20, 20);
}
