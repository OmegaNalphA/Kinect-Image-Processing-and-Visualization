int cols = 23;
int rows;
int scale = 30;
int circw = 5;
int w = 700;
int h = 500;
int r = 1;
int space = 30;
boolean checkside = true;
int side=0; // which side enter from

int colorCount = 0; // counting colored area

float move = 0;  
float [][] grid; 
float linesL;
float linesR;
color[][] colors;
float still;

int mode = 0;

void setup () {
  size (500, 300, P3D);
  rows = h/scale;
  grid = new float [cols][rows];
  colors = new color[cols][rows];

  for (int i=2; i<cols; i++) {
    for (int j=1; j<rows; j++) {
      colors[i][j] = color(255); // set color to white
    }
  } 
}

void draw () {
  background(255);
  frameRate(60);
  translate(-30, 20);
  
  // animating z coordinate
  move += 0.05;  
  float yoff = move;
  for (int x = 0; x < cols; x++) {
    float xoff = 0;
    for (int y = 0; y < rows; y++) {
      grid[x][y] = map(sin(yoff), 0, 1, -10, 10);
      xoff += 0.3;
    }
    yoff += 0.3;
  }
  
  // modes
  if (mode == 0) {
    // check side of entry
    if (checkside == true) {
     if (overRect(0,0,width/2,height)== true) {
       side = 1;   //if enter from left side
       checkside = false;
     } else if (overRect(width-10,0,width/2,height)== true) {
       side = 2; //if enter from right side
       checkside = false;
     } 
    }
  
    //grid lines
    if (side == 1) {
        linegridL();
    } else if (side == 2) {
        linegridR();
    }
    
  } else if (mode == 1) {
    colorAdd();
  } else if (mode == 2) {
    popEffect();
  }  
  pointgrid();
}
   
void linegridL() {
  float percentl = map(mouseX, 0, width, 0, 1);
  float newlinesL = lerp(0, cols, percentl);
  linesL = max(newlinesL, linesL);
   
  // set mode to next mode
  if (linesL > 22 && mode == 0) {
    mode=1;
    linesL = 0;
    newlinesL = 0;
  }  
  fill(255);
  stroke(0);
  float lineCount = linesL;
  
  if (mode > 0) {
    lineCount = 23;
  } 
  for (int i = 2; i < lineCount; i++) {
    for (int j = 1; j < rows; j++) {
      for (int y = j-1; y < j; y++) {
        beginShape(QUAD_STRIP);
        for (int x = i-2; x < i; x++) { 
          float z = grid[x][y];
          vertex(x*(scale), height - y*(scale), z);
          vertex(x*(scale), height - (y+1)*(scale), z); 
        }
        endShape();
      }
    }
  }
}


void linegridR() {
  float percentr = map(mouseX, 0, width, 0, 1);
  float linesR = lerp(0, cols, percentr);
  //linesR = min(linesR, newlinesR);
  
  if (linesR < 1 && mode == 0) {
    mode=1;
    linesR = 0;
    //newlinesL = 0;
  }  
  fill(255);
  stroke(0);
  float lineCount = linesR;
  if (mode > 0) {
    lineCount = 0;
  }
  
   for (int j = 1; j < rows; j++) {
     for (int i = cols; ((i >=2) && (i > lineCount)); i--) {
       for (int y = j-1; y < j; y++) {
       beginShape(QUAD_STRIP);
       for (int x = i-2; x < i; x++) {
         vertex(x*scale, height-y*(scale), grid[x][y]);
         vertex(x*(scale), height-(y+1)*(scale), grid[x][y]); 
       }
     endShape();
     }  
    }
   }
}

// grid of points
void pointgrid() {

 for (int y = 0; y < rows; y++) {
    for (int x=0; x < cols; x++) {
      pushMatrix();
      fill(0);
      lights();
      translate(x*(scale), height - y*(scale), grid[x][y]);
      ellipse(0,0,r,r);
      popMatrix();
    }
  }
}

void colorAdd() {
  for (int i=2; i<cols; i++) {
    for (int j=1; j<rows; j++) {
       for (int y = j-1; y < j; y++) {
       beginShape(QUAD_STRIP);
       for (int x = i-2; x < i; x++) {
        fill(colors[i][j]);
        float z = grid[x][y];
        int c = x*scale-40;
        int r = height-y*scale-20;
        if (mouseX > (c-scale) && mouseX < (c + scale) && mouseY > (r) && mouseY < (r + 2*scale)) {          
          if (colors[i][j] == color(255)) {
            colors[i][j] = color(#4c4491);
            colorCount+=1;
            //print(colorCount + "   ");
            if (colorCount > 200) {
              mode = 2;
            }
          }
          if (colors[i][j] == color(#4c4491)) {
            z +=10;
          }
        }
       
         vertex(x*scale, height-y*(scale), z);
         vertex(x*(scale), height-(y+1)*(scale), z); 
       }
     endShape();
     } 
    } 
    
  }
}

void popEffect() {
  background(#f15e64);
  float w = 2; // width of reacting area
  float h = 1.7; //height of reacting area
  for (int i=2; i<cols; i++) {
    for (int j=1; j<rows; j++) {
       for (int y = j-1; y < j; y++) {
       beginShape(QUAD_STRIP);
       for (int x = i-2; x < i; x++) {
        fill(#4c4491);
        float z = grid[x][y];
        int c = x*scale-40;
        int r = height-y*scale-20;
        if (mouseX > c && mouseX < (c + w*scale) && mouseY > r && mouseY < (r + h*scale)) {
          still = 20 + 8*sin(PI/2);
          z = still;
          if (mousePressed == true) {
            z += random(20,50);
          }
        }
        //else if (mouseX > (c+scale) && mouseX < (c + w*scale+scale) && mouseY > r && mouseY < (r + h*scale)) {
        //   z += random(20,70);
        //} 
        vertex(x*scale, height-y*(scale), z);
        vertex(x*(scale), height-(y+1)*(scale), z);  
       }
     endShape();
     } 
    } 
    
  }
}


boolean overRect(int xi, int yi, int wi, int hi) {
  if ((mouseX > xi) && (mouseX < xi+wi) && (mouseY > yi) && (mouseY < yi+hi)) {
    return true;
  } else { 
    return false;
  }
}