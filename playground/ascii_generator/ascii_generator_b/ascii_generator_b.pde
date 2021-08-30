// Note for next iteration:
// Color edit image and take in 2 photos,
// rasterize and make one quite a bit saturated, other dull
// base ASCII on one and highlights on other
// pull from opposite every once in a while (switch, dont have ascii and highlight
// be same color)

// Ascii symbols arranged dark to light
PImage img;
PFont font;
String button_pressed = "none";
String[] ascii_symbols = {
"$", "@", "B", "%", "8", "&", "W", "M", "#", "*", "o", "a", "h", "k", "b", "d", 
"p", "q", "w", "m", "Z", "O", "0", "Q", "L", "C", "J", "U", "Y", "X", "z", "c", 
"v", "u", "n", "x", "r", "j", "f", "t", "l", "I"};
int symbol_no = ascii_symbols.length;
int pixel_x = 6;
int pixel_y = 10;
int pixel_no = (600*600)/(pixel_x*pixel_y); //6000 - 60 rows, 100 per row
int[] pixel_color = new int[pixel_no];
int[] pixel_symbol = new int[pixel_no];

void setup(){
  size(600, 600);
  colorMode(HSB);
  background(0);
  font = createFont("Futura-Bold", pixel_y);

  // Process image
  img = loadImage("../photos/chrome_icon.png");
  img.resize(600, 600);
  //img = loadImage("../photos/pottery.png");
  //img.resize(500, 600);
  for (int y = 0; y < (600/pixel_y); y++){ //0-60 rows
    for (int x = 0; x < (600/pixel_x); x++){ //0-100 columns
      int this_pixel = ((600/pixel_x)*y)+x; //((# of x) * y) + x
      color c = img.get(x*(pixel_x), y*(pixel_y));
      pixel_color[this_pixel] = c;
      pixel_symbol[this_pixel] = int(map(brightness(c), 0, 255, 0, (symbol_no-1)));
    } 
  }
}

void draw(){
  background(0);
  textFont(font); 
  noStroke();
  
  if (button_pressed == "none") scale(1);
  else if (button_pressed == "o") scale(2);
  else if (button_pressed == "i") scale(0.5);
  
  // Convert to ascii and print letters
  for (int y = 0; y < (600/(pixel_y)); y++){
    for (int x = 0; x < (600/pixel_x); x++){
      int this_pixel = ((600/pixel_x)*y)+x; //((# of x) * y) + x
      color this_color = pixel_color[this_pixel];
      //Inverting colors a bit
      color inverted_color = color(blue(this_color), red(this_color), green(this_color)); 
      color inter_color = lerpColor(inverted_color, this_color>>2, .5);
      if (this_color != 0) {
        // Draw highlight
        int r = int(random(6));
        if (r == 1 || r == 2 || r == 3) fill(inter_color, brightness(this_color));
        else fill(this_color, brightness(this_color));
        rect(x*(pixel_x), y*((pixel_y)), pixel_x, pixel_y);
        // Draw ASCII
        if (r == 4 || r == 5 || r == 6) fill(inverted_color);
        else fill(this_color);
        text(ascii_symbols[pixel_symbol[this_pixel]], x*(pixel_x), y*((pixel_y)));
      }
    }
  }
}

void keyPressed(){
  // Scale the image if press i/o
  if (key == 'o') button_pressed = "i";
  if (key == 'i') button_pressed = "o";
  if (key == 'p') looping = !looping;
}

void keyReleased(){
  if (key == 'o' || key == 'i') button_pressed = "none";
}
