// Ascii symbols arranged dark to light
PImage img;
String button_pressed = "none";
String[] ascii_symbols = {
"$", "@", "B", "%", "8", "&", "W", "M", "#", "*", "o", "a", "h", "k", "b", "d", 
"p", "q", "w", "m", "Z", "O", "0", "Q", "L", "C", "J", "U", "Y", "X", "z", "c", 
"v", "u", "n", "x", "r", "j", "f", "t", "/", "\\", "|", "(", ")", "1", "{", "}", 
"[", "]", "?", "-", "+", "~", "<", ">", "i", "!", "l", "I", ";", ":", ",", "\"", 
"^", "`", "\"", "."};
int symbol_no = ascii_symbols.length;
int pixel_y = 12;
int pixel_x = pixel_y/2;
int pixel_no = (600*600)/(pixel_y*pixel_x);
int[] pixel_symbol = new int[pixel_no];
PFont font;

void setup(){
  size(600, 600);
  //font = createFont("Courier-Bold", 18);
  font = createFont("Century.otf", 18);
  String[] fontList = PFont.list();
  printArray(fontList);
  
  // Process image
  img = loadImage("../photos/spiral_2.png");
  img.resize(600, 600);
  for (int y = 0; y < (600/pixel_y); y++){
    for (int x = 0; x < (600/pixel_x); x++){
      int this_pixel = ((600/pixel_x)*y)+x;
      color c = img.get(x*(pixel_x), y*(pixel_y));
      pixel_symbol[this_pixel] = int(map(brightness(c), 0, 255, 0, (symbol_no-1)));
    }
  }
}

void draw(){
  background(255);
  fill(0);
  textFont(font); 
  textSize(pixel_y); 
  
  if (button_pressed == "none") scale(1);
  else if (button_pressed == "o") scale(2);
  else if (button_pressed == "i") scale(0.5);
  
  // Convert to ascii and print letters
  for (int y = 0; y < (600/pixel_y); y++){
    for (int x = 0; x < (600/pixel_x); x++){
      int this_pixel = ((600/pixel_x)*y)+x;
      text(ascii_symbols[pixel_symbol[this_pixel]], x*(pixel_x), y*(pixel_y));
      print(ascii_symbols[pixel_symbol[this_pixel]]);
    }
    print("\n");
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
