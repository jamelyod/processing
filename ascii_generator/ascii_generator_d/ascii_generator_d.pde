import processing.video.*;
Movie mov;

// Ascii symbols arranged dark to light
String button_pressed = "none";
String[] ascii_symbols = {
"$", "@", "B", "%", "8", "&", "W", "M", "#", "*", "o", "a", "h", "k", "b", "d", 
"p", "q", "w", "m", "Z", "O", "0", "Q", "L", "C", "J", "U", "Y", "X", "z", "c", 
"v", "u", "n", "x", "r", "j", "f", "t", "/", "\\", "|", "(", ")", "1", "{", "}", 
"[", "]", "?", "-", "+", "~", "<", ">", "i", "!", "l", "I", ";", ":", ",", "\"", 
"^", "`", "\"", "."};
int symbol_no = ascii_symbols.length;
int pixel_size = 24;
int pixel_no = (1200*800)/(pixel_size*pixel_size);
int[] pixel_symbol = new int[pixel_no];

void setup(){
  size(1200, 700);
  colorMode(HSB);
  background(0);
  //mov = new Movie(this, "medusa.mov");
  //mov = new Movie(this, "medusa_hc.mov");
  mov = new Movie(this, "mary.mov");
  //mov = new Movie(this, "pieta.mov");
  mov.loop();
}

void draw(){
  background(0);
  fill(255);
  textSize(pixel_size);
  
  if (button_pressed == "none") scale(1);
  else if (button_pressed == "o") scale(2);
  else if (button_pressed == "i") scale(0.5);
  
  // Read in movie frame 
  //image(mov, 0, 0);
  loadPixels();
  mov.loadPixels();
  
  // Convert to ascii and print letters
  for (int y = 0; y < (800/pixel_size); y++){
    for (int x = 0; x < (1200/pixel_size); x++){
      int this_pixel = ((1200/pixel_size)*y)+x;
      color c = mov.get(x*(pixel_size), y*(pixel_size));
      pixel_symbol[this_pixel] = int(map(brightness(c), 0, 255, (symbol_no-1), 0));
      text(ascii_symbols[pixel_symbol[this_pixel]], x*(pixel_size), y*(pixel_size));
    }
  }
}

void keyPressed(){
  // Scale the image if press i/o
  if (key == 'o') button_pressed = "i";scale(0.5);
  if (key == 'i') button_pressed = "o";scale(2);
}

void keyReleased(){
  if (key == 'o' || key == 'i') button_pressed = "none";
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
