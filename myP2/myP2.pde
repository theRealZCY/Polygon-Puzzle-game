//****************************************************************//
//*****                AUTHOR: CONGYAO ZHENG                 *****//
//*****                  CLASS: CS 3451                      *****//  
//*****                    PROJECT NO.2                      *****//  
//****************************************************************//
import controlP5.*;
ControlP5 cp5;
pts P = new pts(), ghostPoly = new pts(), thisPoly = new pts();
pt A=P(100,100), B=P(300,300), C = P(100,100), D=P(300,300), O=P(100,100);
int startGame = 0, gameScreen = 0, polyInd = 0;
float t = 0, f= 0;
Button b1, b2, home;
boolean cutted = false, forward = true;
PFont font, defalt;
PImage myface;

void setup() {
  size(800, 800);
  frameRate(50);
  cp5 =  new ControlP5(this);
  cp5.setColorBackground(peach).setColorForeground(cyan).setColorActive(cyan);
  b1 = cp5.addButton("designer - polygon splitting").setValue(0).setPosition(300, 600).setSize(200,50).onPress(btnAction1);
  b2 = cp5.addButton("player - match edges").setValue(0).setPosition(300, 660).setSize(200,50).onPress(btnAction2);

  font  = loadFont("Chalkduster-48.vlw");
  defalt = loadFont("Avenir-Heavy-48.vlw");

  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  P.loadPts("data/pts");  // loads points form file saved with this program
  R.add(P);
  myFace = loadImage("pic.jpg");
  loadPieces2("data/orig", "data/poly");
}
void draw(){
  background(black);
  if (startGame == 0) {
    initscreen();
  }
  if (startGame == 1) {
    gameScreen1();
  } else if (startGame == 2) {
    gameScreen2();
  }
}

void initscreen(){
  
  
  textFont(font, 40);
  fill(white);

  text("WHOM DO YOU WANT", 200, 400);
  text("To BE?", 300, 450);
  
  textFont(defalt, 17);
  displayHeader();
  println("init");
  b1.setVisible(true);
  b2.setVisible(true);
}

void gameScreen1(){
  
  //text(menu, 10,  height-10-1*20);
  b1.setVisible(false);
  b2.setVisible(false);
  
  textFont(defalt, 17);
  background(white); // clear screen and paints white background
  fill(0);
  text(menu, 10, 700);
  text(guide, 10, 720);
  text(guide2, 10, 740);
  displayHeader();
  pen(black,3); fill(yellow); // P.drawCurve(); P.IDs(); // shows polyloop with vertex labels
  stroke(red); pt G=P.Centroid(); show(G,10); // shows centroid
  pen(green,5); //arrow(A,B);            // defines line style wiht (5) and color (green) and draws starting arrow from A to B

  boolean goodSplit = false, currSplit = false;
  for(int poly = 0; poly < R.size(); poly++){
    currSplit = R.get(poly).splitBy(A, B);
    if (currSplit && !splited) {
      R.remove(poly);
      splited = true;
      cutted = true;
    }
    goodSplit |= currSplit;
      
  }
  
  if (goodSplit) {previousFailed = false;}
  else {previousFailed = true;}
      for(int poly = 0; poly < R_whatever.size(); poly++){
      pen(black, 5);
      fill(allColor[poly%allColor.length]);
      R_whatever.get(poly).drawCurve();
  }
  
  for(int poly = 0; poly < R.size(); poly++){
      pen(black, 5);
      fill(allColor[poly%allColor.length]);
      R.get(poly).drawCurve();
  }

  if(key == 's') {
  if (goodSplit) pen(green,5);
  else pen(red, 7);
  arrow(A, B);
  }


}

void gameScreen2(){
  
  b1.setVisible(false);
  b2.setVisible(false);
  background(white);
  fill(black);
  textFont(defalt, 17);
  text(playMenu, 10, 700);
  text(Instruction, 10, 720);
  //text(guide2, 10, 740);
  displayHeader();
  for(int poly = 0; poly < R_copy.size(); poly++){
    pen(black, 5);
    fill(allColor[poly%allColor.length]);
    R_copy.get(poly).drawCurve();
  }

  for(int poly = 0; poly < R2.size(); poly++){
      if (R2.get(poly).collision) {
        pen(black, 5);
        fill(red);
      } else {
        pen(black, 5);
        fill(allColor[poly%allColor.length]);
      }
    R2.get(poly).drawCurve();
  }
  println(R_ghost.size());
  for(int poly = 0; poly < R_ghost.size(); poly++){
    noFill();
    noStroke();
    R_ghost.get(poly).drawCurve();
  }
  
  if(loaded && R_ghost.size() == 0) {
      textFont(font, 40);
    fill(orange);
    text("CONGRATULATIONS!", 200, 400);
  }
  
  if (keyPressed && key == 'r') {
    if(collide == false) {
     for (int poly = 0; poly < R2.size(); poly++) {
       if(d(R2.get(poly).G[0], thisPoly.G[0])==0) {
       pts p = new pts();
        p.declare();
        p.loadPts("data/poly" + str(poly));
        R2.remove(thisPoly);
        R2.add(polyInd, p);
        edge1.clear();
        edge2.clear();
       }
     }
      } else {
      for (int poly = 0; poly < R2.size(); poly++) {
        if (R2.get(poly).collision) {
          pts p = new pts();
          p.declare();
          p.loadPts("data/poly" + str(poly));
          R2.remove(poly);
          R2.add(poly, p);
          edge1.clear();
          edge2.clear();
        }
      }
      collide = false;
      }
  }

  
  float angle, scale;
  if(edge1.size()>0) {
    pen(grass, 5);
    line(edge1.get(0).x, edge1.get(0).y, edge1.get(1).x, edge1.get(1).y);
    if(edge2.size()>0 && !collide) {
      line(edge2.get(0).x, edge2.get(0).y, edge2.get(1).x, edge2.get(1).y);
      angle = spiralAngle(edge1.get(0), edge1.get(1), edge2.get(0), edge2.get(1));
      scale = spiralScale(edge1.get(0), edge1.get(1), edge2.get(0), edge2.get(1));
      pt center = spiralCenter(angle, scale, edge1.get(0), edge2.get(0));
      O = spiralPt(edge1.get(0),center,scale,angle,t);
      pt P = spiralPt(edge1.get(1),center,scale,angle,t);
      edge(O,P);
      ghostPoly = getPoly(R_ghost, edge2.get(0));
      int c = -1;
      for(pts poly : R2) {
        c++;
        if (poly.containPt(edge1.get(0)) && abs(angle) > 0.001) {
              thisPoly = (poly.doLERP(poly, ghostPoly, t));
              polyInd = c;
              occurCollision(poly);
       } else if (poly.containPt(edge1.get(0))) {
            thisPoly = poly.parallelLERP(poly, ghostPoly, t);
            occurCollision(poly);
          }
          if(t > 1 && !match(poly, ghostPoly)) {
            textFont(font, 100);
            text("wrong", 300, 400);
          }
          if(!match) {
            textFont(font, 100);
            text("wrong", 300, 400);
          }
      if(forward)
      t += .0005;
      else
        t -= .0005;
      if(t > 1)
        forward = false;
      if(t < 0)
        forward = true;
      }
      
    }
  }

}

  
final CallbackListener btnAction1 = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    startGame = 1;
  }
};

final CallbackListener btnAction2 = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    startGame = 2;
  }
};

pts getPoly(ArrayList<pts> R, pt Q) {
  for(pts poly : R) {
    if (poly.containPt(Q)) return poly;
  }
  return null;
}

void occurCollision(pts poly) {
  for (int i = poly.nv - 1, j = 0; j < poly.nv; i = j++) {
      for (pts p: R2) {
          if (d(p.G[0], poly.G[0]) != 0 && p != poly) {
              for (int x=p.nv -1, y = 0; y < p.nv; x = y++) {
                if(!p.goal && collide(poly.G[i], poly.G[j], p.G[x], p.G[y])) {
                  collide = true;
                  poly.collision = true;
                  p.collision = true;
                  //if (p.goal) { collide = false; poly.collision = false; p.collision = false;}
                }
            }
          }
        }
      }
}

//boolean edgeMatch(pts poly, pts ghostPoly, ArrayList<pt> edge1, ArrayList<pt> edge2) {
//  ArrayList<pt> poly1 = new ArrayList<pt>(Arrays.asList(poly.G)); 
//  int i1 = poly.indexOf(edge1.get(0));
//  int i2 = poly.indexOf(edge1.get(1));
  
//}

boolean match(pts poly, pts ghostPoly) {
  if (R2.indexOf(poly) != R_ghost.indexOf(ghostPoly)) return false;
  boolean ret = true;
  for (int i = 0; i < poly.nv; i++) {
    if (d(poly.G[i], ghostPoly.G[i]) > 0.01){
      ret = false;
    } 
  }
  poly.goal = ret;
  match = ret;
  return ret;
}