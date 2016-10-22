int maxRegionCount = 64;
boolean splited = true;
boolean previousFailed = false;
ArrayList<pts> R = new ArrayList<pts>();
ArrayList<pts> R_ghost = new ArrayList<pts>();
ArrayList<pts> R2 = new ArrayList<pts>();
ArrayList<pts> R_copy = new ArrayList<pts>();
ArrayList<pts> R_redo = new ArrayList<pts>();
ArrayList<pts> R_whatever = new ArrayList<pts>();
ArrayList<pts> buffer;

ArrayList<pt> edge1 = new ArrayList<pt>();
ArrayList<pt> edge2 = new ArrayList<pt>();
pt end1 = new pt();
pt end2 = new pt();
boolean selected = false;

boolean match = true;
boolean collide = false;
boolean loaded = false;
int counter = 0;

void savePieces(String dir) {
  //int i = 0;
  for (int i = 0; i < R.size(); i++) {
    File f = new File(dir + str(i));
    if (f.exists()) {
      f.delete();
    }
    R.get(i).savePts(dir + str(i));
  }
  saveCounter(dir, R.size());
}

void saveCounter(String dir, int counter) {
  String [] input = new String[1];
  input[0] = str(counter);
  File f = new File(dir);
  if (f.exists()) {f.delete();}
  saveStrings(dir, input);
}

int loadCounter(String dir) {
  String [] read = new String[1];
  read = loadStrings(dir);
  return int(read[0]);
}

void loadPieces(String dir, ArrayList<pts> R) {
  //R.clear();
  //ArrayList<pts> newR = new ArrayList<>();
  println("load"+dir);
  counter = loadCounter(dir);
  println(counter);
  if (counter <= 1) {
    pts poly = new pts();
    poly.declare();
    poly.loadPts(dir);
    R.add(poly);
  }
  for (int i = 0; i < counter; i++) {
    pts poly = new pts();
    poly.declare();
    poly.loadPts(dir + str(i));
    R.add(poly);
    }

}

void loadPieces2(String dir, String countDir) {
  //R.clear();
  //ArrayList<pts> newR = new ArrayList<>();
  counter = loadCounter(countDir);
  println(counter);
    pts poly = new pts();
    poly.declare();
    poly.loadPts(dir);
    R_copy.add(poly);

}