// Directions for usage:
// w, a, s, d - 
//     controls directions of motion of the dot-grid image
// mouse press - 
//     draws original image at mouse location
// l - 
//     pauses the background refresh until pressed again, 
//     if you move while on, allows motion to build up until let go
//     re-pressing will have a sort of clearing effect
// p - 
//     hard pauses drawing loop, if pressed again will un-pause
//     if you want to have the mouse-draw picture end on top of the dots,
//     use this pause while holding the mouse in the final spot
// k - 
//     rotates through 3 images to draw with, drawing with the one used in the 
//     dot grid


// Canvas size, for some reason width and height aren't working
int canvas_len = 600;
// Image variables
PImage img, img1, img2;
int img_height = canvas_len, img_width = canvas_len-(canvas_len/6);
int img1_height = canvas_len/12, img1_width = canvas_len/12;
int img2_height = (canvas_len-(canvas_len/3))/(canvas_len/100), img2_width = canvas_len/(canvas_len/100);
// Variables to track keyboard presses
boolean keyboard_w = false, keyboard_s = false, keyboard_a = false, keyboard_d = false, keyboard_l = false, keyboard_k = false;
int image_no = 0;
// Variables to track previous direction of motion
// value options are "w", "a", "s", "d", "none"
String was_vertical = "none", was_horizontal = "none";
// Array to hold vertices
Vertex[] vertices_1;
Vertex[] vertices_2;
Vertex[] vertices_3;
// Size and number of tiles
float tiles_row_length_1 = 100;
float tile_size_1 = canvas_len/tiles_row_length_1;
float tiles_row_length_2 = 75;
float tile_size_2 = canvas_len/tiles_row_length_2;
float tiles_row_length_3 = 60;
float tile_size_3 = canvas_len/tiles_row_length_3;

// Vertex class
public class Vertex {
  float x = 0;
  float y = 0;
  float vertex_size;
  float velocity;
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
    } else if (x >= canvas_len){
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
    } else if (y >= canvas_len){
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
  // Create canvas
  size(600, 600);
  background(250);
  // Can load other images from the sketch's directory
  // Loading image 0 - used for the dot grid and drawing
  img = loadImage("../photos/pottery.png");
  img.resize(img_width, img_height);
  // Loading image 1 - used for just drawing
  img1 = loadImage("../photos/chrome_icon.png");
  img1.resize(img1_width, img1_height);
  // Loading image 2 - used for just drawing
  img2 = loadImage("../photos/cursor.png");
  img2.resize(img2_width, img2_height);
  // Create first group of vertices
  vertices_1 = new Vertex[int(tiles_row_length_1*tiles_row_length_1)];
  for (int i = 0; i < tiles_row_length_1; i++){
    for (int j = 0; j < tiles_row_length_1; j++){
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_1)*i)+j;
      // Make Vertexx
      vertices_1[this_vert] = new Vertex(i*tile_size_1, j*tile_size_1);
      // Grab color from image
      color c = img.get(int(vertices_1[this_vert].x), int(vertices_1[this_vert].y));
      vertices_1[this_vert].vertex_size = map(brightness(c), 0, 255, 0, 10);
      vertices_1[this_vert].velocity = tile_size_1;
    }
  }
  // Create second group of vertices
  vertices_2 = new Vertex[int(tiles_row_length_2*tiles_row_length_2)];
  for (int i = 0; i < tiles_row_length_2; i++){
    for (int j = 0; j < tiles_row_length_2; j++){
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_2)*i)+j;
      // Make Vertexx
      vertices_2[this_vert] = new Vertex(i*tile_size_2, j*tile_size_2);
      // Grab color from image
      color c = img.get(int(vertices_2[this_vert].x), int(vertices_2[this_vert].y));
      vertices_2[this_vert].vertex_size = map(brightness(c), 0, 255, 0, 10);
      vertices_2[this_vert].x = abs(vertices_2[this_vert].x-canvas_len);
      vertices_2[this_vert].y = abs(vertices_2[this_vert].y-canvas_len);
      vertices_2[this_vert].velocity = 2*tile_size_2;
    }
  }
  // Create third group of vertices
  vertices_3 = new Vertex[int(tiles_row_length_3*tiles_row_length_3)];
  for (int i = 0; i < tiles_row_length_3; i++){
    for (int j = 0; j < tiles_row_length_3; j++){
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_3)*i)+j;
      // Make Vertexx
      vertices_3[this_vert] = new Vertex(i*tile_size_3, j*tile_size_3);
      // Grab color from image
      color c = img.get(int(vertices_3[this_vert].x), int(vertices_3[this_vert].y));
      vertices_3[this_vert].vertex_size = map(brightness(c), 0, 255, 0, 10);
      vertices_3[this_vert].x = abs(vertices_3[this_vert].x-canvas_len+(2*i));
      vertices_3[this_vert].y = abs(vertices_3[this_vert].y-canvas_len+(2*i));
      vertices_3[this_vert].velocity = 3*tile_size_3;
    }
  }
}


// Draw
void draw(){
  // Backgrond and stroke variables
  noStroke();
  if (!keyboard_l){
    background(250);
  }
  //image(img, 50, 0);
  // Iterate over third group of vertices and draw ellipses
  fill(230);
  for (int i = 0; i < tiles_row_length_3; i++){
    for (int j = 0; j < tiles_row_length_3; j++){ 
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_3)*i)+j;
      // Draw ellipses
      ellipse(vertices_3[this_vert].x, vertices_3[this_vert].y, vertices_3[this_vert].vertex_size, vertices_3[this_vert].vertex_size);
      // Process boolean flags of vertices and move lines accordingly
      vertices_3[this_vert].move();
    }
  }
  // Iterate over second group of vertices and draw ellipses
  fill(150);
  for (int i = 0; i < tiles_row_length_2; i++){
    for (int j = 0; j < tiles_row_length_2; j++){ 
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_2)*i)+j;
      // Draw ellipses
      ellipse(vertices_2[this_vert].x, vertices_2[this_vert].y, vertices_2[this_vert].vertex_size, vertices_2[this_vert].vertex_size);
      // Process boolean flags of vertices and move lines accordingly
      vertices_2[this_vert].move();
    }
  }
  // Iterate over first group of vertices and draw ellipses
  fill(0);
  for (int i = 0; i < tiles_row_length_1; i++){
    for (int j = 0; j < tiles_row_length_1; j++){ 
      // Operative vertex from loop
      int this_vert = (int(tiles_row_length_1)*i)+j;
      // Draw ellipses
      ellipse(vertices_1[this_vert].x, vertices_1[this_vert].y, vertices_1[this_vert].vertex_size, vertices_1[this_vert].vertex_size);
      // Process boolean flags of vertices and move lines accordingly
      vertices_1[this_vert].move();
    }
  }
  if (mousePressed == true){
    if (image_no == 0) image(img, (mouseX - (img_width/2)), (mouseY - (img_height/2)));
    else if (image_no == 1) image(img1, (mouseX - (img1_width/2)), (mouseY - (img1_height/2)));
    else if (image_no == 2) image(img2, (mouseX - (img2_width/2)), (mouseY - (img2_height/2)));
  }
}
    
    
// Processes key press and handles direction changing
// This handles the logic of when to move vertical vs horizontal
void keyPressed(){
  if (key == 'w') {
    keyboard_w = true;
    // Moving first group of vertices
    for (int i = 0; i < tiles_row_length_1*tiles_row_length_1; i++){
      if (was_vertical == "s") vertices_1[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_1[i].going_up = true;
    }
    // Moving second group of vertices
    for (int i = 0; i < tiles_row_length_2*tiles_row_length_2; i++){
      if (was_vertical == "s") vertices_2[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_2[i].going_up = true;
    }
    // Moving third group of vertices
    for (int i = 0; i < tiles_row_length_3*tiles_row_length_3; i++){
      if (was_vertical == "s") vertices_3[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_3[i].going_up = true;
    }
    was_vertical = "w";
  }
  if (key == 's') {
    keyboard_s = true;
    for (int i = 0; i < tiles_row_length_1*tiles_row_length_1; i++){
      if (was_vertical == "w") vertices_1[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_1[i].going_down = true;
    }
    for (int i = 0; i < tiles_row_length_2*tiles_row_length_2; i++){
      if (was_vertical == "w") vertices_2[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_2[i].going_down = true;
    }
    for (int i = 0; i < tiles_row_length_3*tiles_row_length_3; i++){
      if (was_vertical == "w") vertices_3[i].flip_vertical_dir();
      else if (was_vertical == "none") vertices_3[i].going_down = true;
    }
    was_vertical = "s";
  }
  if (key == 'a') {
    keyboard_a = true;
    for (int i = 0; i < tiles_row_length_1*tiles_row_length_1; i++){
      if (was_horizontal == "d") vertices_1[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_1[i].going_left = true;
    }
    for (int i = 0; i < tiles_row_length_2*tiles_row_length_2; i++){
      if (was_horizontal == "d") vertices_2[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_2[i].going_left = true;
    }
    for (int i = 0; i < tiles_row_length_3*tiles_row_length_3; i++){
      if (was_horizontal == "d") vertices_3[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_3[i].going_left = true;
    }
    was_horizontal = "a";
  }
  if (key == 'd') {
    keyboard_d = true;
    for (int i = 0; i < tiles_row_length_1*tiles_row_length_1; i++){
      if (was_horizontal == "a") vertices_1[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_1[i].going_right = true;
    }
    for (int i = 0; i < tiles_row_length_2*tiles_row_length_2; i++){
      if (was_horizontal == "a") vertices_2[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_2[i].going_right = true;
    }
    for (int i = 0; i < tiles_row_length_3*tiles_row_length_3; i++){
      if (was_horizontal == "a") vertices_3[i].flip_horizontal_dir();
      else if (was_horizontal == "none") vertices_3[i].going_right = true;
    }
    was_horizontal = "d";
  }
  if (key == 'l') {
    keyboard_l = !keyboard_l;
  }
  if (key == 'p') {
    looping = !looping;
  }
  if (key == 'k') {
    if (image_no < 2){
      image_no++;
    } else image_no = 0;
  }
}
         
          
// Processes letting go of keys
// Turn this off if you want the motion to continue forever
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
