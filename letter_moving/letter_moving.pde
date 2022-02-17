// Velocity of motion
int velocity = 5;
// Image variable
PImage img;
// Variables to track keyboard presses
boolean keyboard_w = false, keyboard_s = false, keyboard_a = false, keyboard_d = false;
// Variables to track previous direction of motion - options are "w", "a", "s", "d", "none"
String was_vertical = "none", was_horizontal = "none";

// Vertex class
public class Vertex {
  int x = 0;
  int y = 0;
  boolean going_down = false;
  boolean going_up = false;
  boolean going_left = false;
  boolean going_right = false;
  boolean at_top = false;
  boolean at_bottom = false;
  boolean at_left = false;
  boolean at_right = false;
  
  // Vertex class
  public Vertex(int input_x, int input_y) {
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
    if (x == 0){
      at_left = true;
      at_right = false;
    } else if (x == 600){
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
    if (y == 0){
      at_top = true;
      at_bottom = false;
    } else if (y == 600){
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
} // Vertex class end

// Instantiate vertices for the letter A
Vertex top_vertex = new Vertex(300, 100);
Vertex left_vertex = new Vertex(100, 500);
Vertex right_vertex = new Vertex(500, 500);
Vertex left_midpoint = new Vertex(0, 0);
Vertex right_midpoint = new Vertex(0, 0);

// Finds the midpoint of two vertices, v1 and v2
void find_midpoint(Vertex v1, Vertex v2, Vertex m){
  m.x = (v1.x+v2.x)/2;
  m.y = (v1.y+v2.y)/2;
}

// Decides how to move vertices based on booleans
void move(){
  if (keyboard_w) {
    top_vertex.move_vertical(); //up
    left_vertex.move_vertical(); //down
    right_vertex.move_vertical(); //down
  }
  if (keyboard_s) {
    top_vertex.move_vertical(); //down
    left_vertex.move_vertical(); //up
    right_vertex.move_vertical(); //up
  }
  if (keyboard_a) {
    top_vertex.move_horizontal(); //left
    left_vertex.move_horizontal(); //left
    right_vertex.move_horizontal(); //right
  }
  if (keyboard_d) {
    top_vertex.move_horizontal(); //right
    left_vertex.move_horizontal(); //left
    right_vertex.move_horizontal(); //left
  }
}

// Setup
void setup(){
  size(600, 600);
}

// Draw
void draw(){
  // Midpoint vertices
  find_midpoint(top_vertex, left_vertex, left_midpoint);
  find_midpoint(top_vertex, right_vertex, right_midpoint);
  // Common variables
  background(250);
  strokeWeight(10);
  // Draw lines
  line(top_vertex.x, top_vertex.y, left_vertex.x, left_vertex.y);
  line(top_vertex.x, top_vertex.y, right_vertex.x, right_vertex.y);
  line(left_midpoint.x, left_midpoint.y, right_midpoint.x, right_midpoint.y);
  // Process boolean flags of vertices and move lines accordingly
  move();
}
    
// Processes key press and handles direction changing
void keyPressed(){
  if (key == 'w') {
    keyboard_w = true;
    if (was_vertical == "s") {
      top_vertex.flip_vertical_dir();
      left_vertex.flip_vertical_dir();
      right_vertex.flip_vertical_dir();
    }
    else if (was_vertical == "none") {
      top_vertex.going_up = true;
      left_vertex.going_down = true;
      right_vertex.going_down = true;
    }
    was_vertical = "w";
  }
  if (key == 's') {
    keyboard_s = true;
    if (was_vertical == "w") {
      top_vertex.flip_vertical_dir();
      left_vertex.flip_vertical_dir();
      right_vertex.flip_vertical_dir();
    }
    else if (was_vertical == "none") {
      top_vertex.going_down = true;
      left_vertex.going_up = true;
      right_vertex.going_up = true;
    }
    was_vertical = "s";
  }
  if (key == 'a') {
    keyboard_a = true;
    if (was_horizontal == "d") {
      top_vertex.flip_horizontal_dir();
      left_vertex.flip_horizontal_dir();
      right_vertex.flip_horizontal_dir();
    }
    else if (was_horizontal == "none") {
      top_vertex.going_left = true;
      left_vertex.going_right = true;
      right_vertex.going_right = true;
    }
    was_horizontal = "a";
  }
  if (key == 'd') {
    keyboard_d = true;
    if (was_horizontal == "a") {
      top_vertex.flip_horizontal_dir();
      left_vertex.flip_horizontal_dir();
      right_vertex.flip_horizontal_dir();
    }
    else if (was_horizontal == "none") {
      top_vertex.going_right = true;
      left_vertex.going_left = true;
      right_vertex.going_left = true;
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
