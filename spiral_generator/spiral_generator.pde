int width = 600;
int height = 500;
float distance = 0;
float angle = 0;
boolean dir = true;
int dir_incr = 1;
float center_x = width/2;
float center_y = height/2;
float distance_change = 0.3;
float angle_change = 0.02;
float ellipse_size = 10;
float c = 0;

void setup() {
  size(600, 500);
  background(255);
}

void draw() {
  // Polar to Cartesian conversion
  float x = center_x + cos(angle)*distance;
  float y = center_y + sin(angle)*distance;

  // Draw an ellipse at x,y
  noStroke();
  fill(c);
  // Adjust for center of window
  ellipse(x, y, ellipse_size, ellipse_size); 

  // Increment the angle
  // Increment the radius
  if (dir){
    distance += distance_change;
    angle += angle_change;
    dir_incr += random(0, 6);
  } else if (!dir){
    distance -= distance_change;
    angle -= angle_change;
    dir_incr += random(0, 6);
  }
  // Increment the incrementer
  if (dir_incr%1440 == 0) {
    dir_incr = 1;
    dir = !dir;
    angle = -1 * angle;
    c = random(0, 4)*25;
  }

  // Don't go over the edge
  if (x >= width){
    x = 0 + (x - width);
  } else if (x <= 0){
    x = width + x;
  }
  if (y >= height){
    y = 0 + (y - height);
  } else if (y <= 0){
    y = height + y;
  }
}