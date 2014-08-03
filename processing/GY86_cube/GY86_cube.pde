

import processing.serial.*;
import processing.opengl.*;

Serial myPort;  
final String serialPort = "/dev/vmodem"; // replace this with your serial port. On windows you will need something like "COM1".
float [] Euler = new float [3]; 
float [] position = new float [3];
PFont font;
final int VIEW_SIZE_X = 800, VIEW_SIZE_Y = 600;
String title="testing";

void setup() 
{
  size(VIEW_SIZE_X, VIEW_SIZE_Y, OPENGL);
  myPort = new Serial(this, serialPort, 115200);
  // The font must be located in the sketch's "data" directory to load successfully
  font = loadFont("CourierNew36.vlw"); 
  myPort.clear();
}

void serialEvent(Serial p) {
   
    String inputString = p.readStringUntil('\r');
    if (inputString != null && inputString.length() > 0) {
      //println(inputString);
      String [] inputStringArr = split(inputString, "|");
      if(inputStringArr.length >= 7) {
        title=inputStringArr[0];
        Euler[0]=Float.parseFloat(inputStringArr[1]);
        Euler[1]=Float.parseFloat(inputStringArr[2]);
        Euler[2]=Float.parseFloat(inputStringArr[3]);
        position[0]=Float.parseFloat(inputStringArr[4]);
        position[1]=Float.parseFloat(inputStringArr[5]);
        position[2]=Float.parseFloat(inputStringArr[6]);
      }
    }
}

void buildBoxShape() {
  //box(60, 10, 40);
  noStroke();
  beginShape(QUADS);
  
  //Z+ (to the drawing area)
  fill(#00ff00);
  vertex(-30, -5, 20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  //Z-
  fill(#0000ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, 5, -20);
  vertex(-30, 5, -20);
  
  //X-
  fill(#ff0000);
  vertex(-30, -5, -20);
  vertex(-30, -5, 20);
  vertex(-30, 5, 20);
  vertex(-30, 5, -20);
  
  //X+
  fill(#ffff00);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(30, 5, -20);
  
  //Y-
  fill(#ff00ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(-30, -5, 20);
  
  //Y+
  fill(#00ffff);
  vertex(-30, 5, -20);
  vertex(30, 5, -20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  endShape();
}


void drawCube() {  
  pushMatrix();
    translate(VIEW_SIZE_X/2 - position[0], VIEW_SIZE_Y/2 + position[2], position[1]);
    scale(5,5,5);
   
   //x=x
   //y=z
   //z=y
    rotateX(-Euler[0]);
    rotateY(Euler[2]);
    rotateZ(Euler[1]);
    
    buildBoxShape();
    
  popMatrix();
}


void draw() {
  background(#000000);
  fill(#ffffff);
  textFont(font, 20);
  textAlign(LEFT, TOP);
  text(title+"\nPitch (degrees): " + degrees(Euler[0]) + "\nRoll (degrees): " + degrees(Euler[1])+"\nYaw (degrees): " + degrees(Euler[2])+ "\nPosition X (cm): "+position[0]+ "\nPosition Y (cm): "+position[1]+ "\nPosition Z (cm): "+position[2], 20, 20);
  drawCube();
}


