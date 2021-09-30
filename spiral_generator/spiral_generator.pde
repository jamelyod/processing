int width = 600;
int height = 500;
float distance = 0;
float angle = 0;
float center_x = width/2;
float center_y = height/2;
boolean dir = true;
int dir_incr = 1;
float distance_change = 0.1;
float angle_change = 0.02;
float ellipse_size = 20;
float c_selection = 0;
float[] c = { 0, 150, 220 };

void setup() {
  size(600, 500);
  background(255);
}

void draw() {
  for (int i = 0; i < 30; i++){
    // Polar to Cartesian conversion
    float x = center_x + cos(angle)*distance;
    float y = center_y + sin(angle)*distance;

    // Don't go over the edge
    if (x >= width*2 || x <= (-1 * (width*2)) || y >= height*2 || y <= (-1 * (height*2))){
      distance = 0;
      angle = random(0, 1);
      center_x = width/2;
      center_y = height/2;
      x = center_x + cos(angle)*distance;
      y = center_y + sin(angle)*distance;
    }

    // Draw an ellipse at x,y
    noStroke();
    fill(c_selection);
    // Adjust for center of window
    ellipse(x, y, ellipse_size, ellipse_size); 

    // Increment distance and angle
    if (dir){
      distance += distance_change;
      angle += angle_change;
      dir_incr += random(0, 6);
    } else if (!dir){
      distance -= distance_change;
      angle -= angle_change;
      dir_incr += random(0, 6);
    }
    // Switch direction
    if (dir_incr%360 == 0) {
      dir_incr = 1;
      dir = !dir;
      angle = -1 * angle;
      c_selection = c[int(random(c.length))];
    }
  }
}