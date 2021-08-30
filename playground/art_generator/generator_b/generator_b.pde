
// Later, draw with image

  
// Size and number of tiles
float tiles_row_length = 100;
float tile_size = 600/tiles_row_length;
// Velocity of motion
float velocity = tile_size;
// Image variable
PImage img;
// Variables to track keyboard presses
boolean keyboard_w = false, keyboard_s = false, keyboard_a = false, keyboard_d = false;
// Variables to track previous direction of motion - options are "w", "a", "s", "d", "none"
String was_vertical = "none", was_horizontal = "none";
// Array to hold vertices
Vertex[] vertices;

// Vertex class
public class Vertex {
  float x = 0;
  float y = 0;
  float vertex_size;
  boolean going_down = false;
  boolean going_up = false;
  boolean going_left = false;
  boolean going_right = false;
  boolean at_top = false;
  boolean at_bottom = false;
  boolean at_left = false;
  boolean at_right = false;
  
  // Vertex class
  public Vertex(float input_x, float input_y) {
    x = input_x;
    y = input_y;
  }
  
  // Move the vertex down
  public void move_down(){
    y += velocity;
  }
  
  // Move the vertex up
  public void move_up(){
    y -= velocity;
  }
  
  // Move the vertex left
  public void move_left(){
    x -= velocity;
  }
  
  // Move the vertex right
  public void move_right(){
    x += velocity;
  }
  
  // Flips the current direction for vertical
  public void flip_vertical_dir(){
    going_down = !going_down;
    going_up = !going_up;
  }
  
  // Flips the current direction for horizontal
  public void flip_horizontal_dir(){
    going_left = !going_left;
    going_right = !going_right;
  }
  
  // Checks if the vertex has hit the left or right bounds
  private void check_x_bounds(){
    if (x <= 0){
      at_left = true;
      at_right = false;
    } else if (x >= 600){
      at_left = false;
      at_right = true;
    }
  }
  
  // Moves the vertex horizontally
  public void move_horizontal(){
    check_x_bounds();
    if (at_left) {
      move_right();
      if (going_left) {
        going_right = true;
        going_left = false;
      }
      at_left = false;
    } 
    else if (at_right) {
      move_left();
      if (going_right) {
        going_left = true;
        going_right = false;
      }
      at_right = false;
    } 
    else if (going_left) move_left();
    else if (going_right) move_right();
  }
  
  // Checks if the vertex has hit the top or bottom bounds
  private void check_y_bounds(){
    if (y <= 0){
      at_top = true;
      at_bottom = false;
    } else if (y >= 600){
      at_top = false;
      at_bottom = true;
    }
  }
  
  // Moves the vertex vertically
  public void move_vertical(){
    check_y_bounds();
    if (at_top) {
      move_down();
      if (going_up) {
        going_down = true;
        going_up = false;
      }
      at_top = false;
    } 
    else if (at_bottom) {
      move_up();
      if (going_down) {
        going_up = true;
        going_down = false;
      }
      at_bottom = false;
    } 
    else if (going_up) move_up();
    else if (going_down) move_down();
  }
  
  // Decides how to move vertices based on booleans
  void move(){
    if (keyboard_w) move_vertical(); //up
    if (keyboard_s) move_vertical(); //down
    if (keyboard_a) move_horizontal(); //left
    if (keyboard_d) move_horizontal(); //right
  }
} // Vertex class end


// Setup
void setup(){
  size(600, 600);
  img = loadImage("../photos/pottery.png");
  img.resize(500, 600);
  // Create vertices
  vertices = new Vertex[int(tiles_row_length*tiles_row_length)];
  for (int i = 0; i < tiles_row_length; i++){
    for (int j = 0; j < tiles_row_length; j++){
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length)*i)+j;
      // Make Vertexx
      vertices[this_vert] = new Vertex(i*tile_size, j*tile_size);
      // Grab color from image
      color c = img.get(int(vertices[this_vert].x), int(vertices[this_vert].y));
      vertices[this_vert].vertex_size = map(brightness(c), 0, 255, 0, 10);
    }
  }
}


// Draw
void draw(){
  // Common variables
  background(250);
  image(img, 50, 0);
  noStroke();
  fill(250);
  // Iterate over vertices and draw ellipses
  for (int i = 0; i < tiles_row_length; i++){
    for (int j = 0; j < tiles_row_length; j++){ 
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length)*i)+j;
      // Draw ellipses
      ellipse(vertices[this_vert].x, vertices[this_vert].y, vertices[this_vert].vertex_size, vertices[this_vert].vertex_size);
      // Process boolean flags of vertices and move lines accordingly
      vertices[this_vert].move();
    }
  }
}
    
    
// Processes key press and handles direction changing
void keyPressed(){
  if (key == 'w') {
    keyboard_w = true;
    for (int i = 0; i < tiles_row_length*tiles_row_length; i++){
      if (was_vertical == "s") vertices[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices[i].going_up = true;
    }
    was_vertical = "w";
  }
  if (key == 's') {
    keyboard_s = true;
    for (int i = 0; i < tiles_row_length*tiles_row_length; i++){
      if (was_vertical == "w") vertices[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices[i].going_down = true;
    }
    was_vertical = "s";
  }
  if (key == 'a') {
    keyboard_a = true;
    for (int i = 0; i < tiles_row_length*tiles_row_length; i++){
      if (was_horizontal == "d") vertices[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices[i].going_left = true;
    }
    was_horizontal = "a";
  }
  if (key == 'd') {
    keyboard_d = true;
    for (int i = 0; i < tiles_row_length*tiles_row_length; i++){
      if (was_horizontal == "a") vertices[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices[i].going_right = true;
    }
    was_horizontal = "d";
  }
}
         
          
// Processes letting go of keys
void keyReleased(){
  if (key == 'w') {
    keyboard_w = false;
  }
  if (key == 's') {
    keyboard_s = false;
  }
  if (key == 'a') {
    keyboard_a = false;
  }
  if (key == 'd') {
    keyboard_d = false;
  }
}
