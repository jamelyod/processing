// Ascii symbols arranged dark to light
PImage img;
PFont font;
String button_pressed = "none";
String[] ascii_symbols = {
"$", "@", "B", "%", "8", "&", "W", "M", "#", "*", "o", "a", "h", "k", "b", "d", 
"p", "q", "w", "m", "Z", "O", "0", "Q", "L", "C", "J", "U", "Y", "X", "z", "c", 
"v", "u", "n", "x", "r", "j", "f", "t", "/", "\\", "|", "(", ")", "1", "{", "}", 
"[", "]", "?", "-", "+", "~", "<", ">", "i", "!", "l", "I", ";", ":", ",", "\"", 
"^", "`", "\"", "."};
int symbol_no = ascii_symbols.length;
int pixel_size = 6;
int pixel_no = (600*600)/(pixel_size*pixel_size);
int[] pixel_color = new int[pixel_no];
int[] pixel_symbol = new int[pixel_no];

void setup(){
  size(600, 600);
  font = createFont("Futura-Bold", pixel_size);

  // Process image
  img = loadImage("../photos/chrome_icon.png");
  img.resize(600, 600);
  for (int y = 0; y < (600/pixel_size); y++){
    for (int x = 0; x < (600/pixel_size); x++){
      int this_pixel = ((600/pixel_size)*y)+x;
      color c = img.get(x*(pixel_size), y*(pixel_size));
      pixel_color[this_pixel] = c;
      pixel_symbol[this_pixel] = int(map(brightness(c), 0, 255, 0, (symbol_no-1)));
    }
  }
}

void draw(){
  background(0);
  textFont(font); 
  
  if (button_pressed == "none") scale(1);
  else if (button_pressed == "o") scale(2);
  else if (button_pressed == "i") scale(0.5);
  
  // Convert to ascii and print letters
  for (int y = 0; y < (600/pixel_size); y++){
    for (int x = 0; x < (600/pixel_size); x++){
      int this_pixel = ((600/pixel_size)*y)+x;
      fill(255);
      fill(pixel_color[this_pixel]);
      rect(pixel_size, pixel_size, x*(pixel_size), y*(pixel_size), pixel_size/6);
    }
  }
  
  // Convert to ascii and print letters
  for (int y = 0; y < (600/pixel_size); y++){
    for (int x = 0; x < (600/pixel_size); x++){
      int this_pixel = ((600/pixel_size)*y)+x;
      fill(pixel_color[this_pixel]);
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
