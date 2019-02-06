int currentNodeIndex = -1;
ArrayList<Node> nodes;

void addNode(int mx, int my) {
  nodes.add(new Node(nodes.size() + "", mx, my));
}

boolean hasCurrentNode() {
  return (currentNodeIndex > -1);
}

void moveCurrentNode(int dx, int dy) {
  nodes.get(currentNodeIndex).move(dx, dy);
}

void displayCurrentNode() {
  if (hasCurrentNode()) {
    fill(0, 255, 0);
    stroke(0, 255, 0);
    nodes.get(currentNodeIndex).display();
  }
}

void setCurrentNodeZ(int zp) {
  nodes.get(currentNodeIndex).z = zp;
}

int getClickedNode(int mx, int my) {
  for (int i = 0; i < nodes.size(); i++) {
    if (nodes.get(i).mouseOver(mx, my)) {
      return i;
    }
  }
  return -1;
}

void checkEdgeClick(int mx, int my) {
  int prevNodeIndex = currentNodeIndex;
  currentNodeIndex = getClickedNode(mx, my);
  //cout << currentNodeIndex << " " << prevNodeIndex << std::endl;
  // if we actually clicked on a star to create an edge
  if (currentNodeIndex >= 0) {
    // if we've already selected a star
    if (prevNodeIndex >= 0) {
      // oops, clicked on the same star
      if (prevNodeIndex == currentNodeIndex) {
        currentNodeIndex = -1;
      }
      // clicked a new star! let's add an edge
      else {
        // add link in adjacency matrix
        Node n2 = nodes.get(prevNodeIndex);
        Node n1 = nodes.get(currentNodeIndex);
        lines.add(new Line(n1.getX(), n1.getY(), n2.getX(), n2.getY(), prevNodeIndex, currentNodeIndex));
      }
    }
  }
}


void checkNodeClick(int mx, int my) {
  currentNodeIndex = getClickedNode(mx, my);
}

void checkDeleteNodeClick(int mx, int my) {
  currentNodeIndex = getClickedNode(mx, my);
  if (currentNodeIndex > -1) {
    removeNode(currentNodeIndex);
    currentNodeIndex = -1;
  }
}

int getCurrentNode() {
  //cout << currentNodeIndex << std::endl;
  return currentNodeIndex;
}

void setCurrentNode(int num) {
  this.currentNodeIndex = num;
}


void removeNode(int index) {
  nodes.remove(index);
  deleteLines(index);
}

void displayNodes() {
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).display();
  }
}

void displayNodeLabels() {
  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).displayLabel();
  }
}


void drawLineToCurrent(int x, int y) {
  stroke(255);
  if (currentNodeIndex > -1 && currentNodeIndex < nodes.size()) {
    line(nodes.get(currentNodeIndex).getX(), nodes.get(currentNodeIndex).getY(), x, y);
  }
}


void saveLines() {
  processing.data.JSONObject json;
  json = new processing.data.JSONObject();
  json.setInt("linesNum", lines.size());
  saveJSONObject(json, "data/graph/lines.json");

  for (int i = 0; i < lines.size(); i++) {
    processing.data.JSONObject json2;
    json2 = new processing.data.JSONObject();
    Line l = lines.get(i);
    json2.setInt("id1", l.id1);
    json2.setInt("id2", l.id2);
    json2.setInt("x1", l.getX1());
    json2.setInt("y1", l.getY1());
    json2.setInt("x2", l.getX2());
    json2.setInt("y2", l.getY2());
    json2.setInt("z1", l.zIndex);
    json2.setInt("cg", l.constellationG);

    saveJSONObject(json2, "data/graph/line" + i + ".json");
  }
}

void loadLines() {
  processing.data.JSONObject json;
  json = loadJSONObject("data/graph/lines.json");
  int linesNum = json.getInt("linesNum");

  for (int i = 0; i < linesNum; i++) {
    processing.data.JSONObject lineJson = loadJSONObject("data/graph/line" + i + ".json");
    int id1 = lineJson.getInt("id1");
    int id2 = lineJson.getInt("id2");
    int x1 = lineJson.getInt("x1");
    int y1 = lineJson.getInt("y1");
    int x2 = lineJson.getInt("x2");
    int y2 = lineJson.getInt("y2");
    int z1 = lineJson.getInt("z1");
    int z2 = lineJson.getInt("z2");
    int cg = lineJson.getInt("cg");

    lines.add(new Line(x1, y1, z1, x2, y2, z2, id1, id2));
    //lines.get(i).zIndex = z;
    lines.get(i).constellationG = cg;
  }
}



class Line {

  PVector p1;
  PVector p2;
  int zIndex = 0;
  int z1 = 0;
  int z2 = 0;
  float zAve = 0;
  float ang;
  int id1, id2;
  int constellationG = 0;
  int twinkleT;
  int twinkleRange = 0;
  long lastChecked = 0;
  int rainbowIndex = int(random(255));

  Line(PVector p1, PVector p2, int id1, int id2) {
    this.p1 = p1;
    this.p2 = p2;
    initLine();
    this.id1 = id1;
    this.id2 = id2;
    //updateZ();
  }

  Line(Node n1, Node n2, int id1, int id2) {
    this.p1.set(n1.getX(), n1.getY());
    this.p2.set(n2.getX(), n2.getY());
    initLine();
    this.id1 = id1;
    this.id2 = id2;
    //updateZ();
  }

  Line(int x1, int y1, int x2, int y2, int id1, int id2) {
    this(x1, y1, 0, x2, y2, 0, id1, id2);
  }

  Line(int x1, int y1, int z1, int x2, int y2, int z2, int id1, int id2) {
    this.p1 = new PVector(x1, y1);
    this.p2 = new PVector(x2, y2);
    initLine();
    this.id1 = id1;
    this.id2 = id2;
    this.z1 = z1;
    this.z2 = z2;
    //updateZ();
  }

  //void updateZ() {
  //  z1 = graphL.nodes.get(id1).z;
  //  z2 = graphL.nodes.get(id2).z;
  //  zAve = (z1 *1.0 + z2)/2.0;
  //}

  void initLine() {
    leftToRight();
    ang = atan2(this.p1.y - this.p2.y, this.p1.x - this.p2.x);
    if (ang > PI/2) ang -= 2*PI;
    twinkleT = int(random(50, 255));
    twinkleRange = int(dist(p1.x, p1.y, p2.x, p2.y)/100);
  }

  void display(color c) {
    stroke(c);
    fill(c);
    display();
  }

  void display() {
    line(p1.x, p1.y, p2.x, p2.y);
  }

  void displayCenterPulse(float per) {
    per = constrain(per, 0, 1.0);
    float midX = (p1.x + p2.x)/2;
    float midY = (p1.y + p2.y)/2;
    float x1 = map(per, 0, 1.0, midX, p1.x);
    float x2 = map(per, 0, 1.0, midX, p2.x);
    float y1 = map(per, 0, 1.0, midY, p1.y);
    float y2 = map(per, 0, 1.0, midY, p2.y);
    line(x1, y1, x2, y2);
  }



  void moveP1(int x, int y) {
    p1.x += x;
    p1.y += y;
  }

  void moveP2(int x, int y) {
    p2.x += x;
    p2.y += y;
  }

  void displayZDepth() {
    colorMode(HSB, 255);
    stroke(map(zAve, 0, 9, 0, 255), 255, 255);
    display();
    colorMode(RGB, 255);
  }

  void leftToRight() {
    if (p1.x > p2.x) {
      PVector temp = new PVector(p1.x, p1.y);
      p1.set(p2);
      p2.set(temp);
    }
  }

  void rightToLeft() {
    if (p1.x < p2.x) {
      PVector temp = p1;
      p1.set(p2);
      p2.set(temp);
    }
  }

  void displayPercent(float per) {
    per*= 2;
    float p = constrain(per, 0, 1.0);
    PVector pTemp = PVector.lerp(p1, p2, p);
    line(p1.x, p1.y, pTemp.x, pTemp.y);
  }

  void displayPercentWid(float per) {
    per = constrain(per, 0, 1.0);
    int sw = int(map(per, 0, 1.0, 0, 5));
    strokeWeight(sw);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  void fftConstellation(float c, float per) {
    per = constrain(per, 0, 1.0);
    int sw = int(map(per, 0, 1.0, 0, 5));
    sw = constrain(sw, 0, 5);
    if (sw < 1) noStroke();
    else {
      strokeWeight(sw);
    }
    if (constellationG == c)line(p1.x, p1.y, p2.x, p2.y);
  }

  void twinkle(int wait) {
    int num = int(dist(p1.x, p1.y, p2.x, p2.y)/100);

    if (millis() - lastChecked > wait) {
      twinkleT = int(random(100, 255));
      lastChecked = millis();
      //if (twinkleT > 220) twinkleRange = num + int(random(3));
    }

    noStroke();
    fill(twinkleT);
    for (int i = 0; i < num; i++) {
      float x = map(i, -.5, twinkleRange, p1.x, p2.x);
      float y = map(i, -.5, twinkleRange, p1.y, p2.y);
      ellipse(x, y, 4, 10);
    }
  }

  void displayBandX(int start, int end, color c) {
    if (p1.x > start && p1.x < end) {
      display(c);
    }
  }

  void randomSegment() {
    //float len = random(
  }

  void displayBandX(int start, int end) {
    if (p1.x > start && p1.x < end) {
      display(color(255));
    } else {
      displayNone();
    }
  }

  void displayBandY(int start, int end, color c) {
    if (p1.y > start && p1.y < end) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayBandZ(int start, int end, color c) {
    if (z1 >= start && z1 < end) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayBandZ(int band, color c) {
    if (z1 == band) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayNone() {
    //strokeWeight(18);
    display(color(0));
    //strokeWeight(2);
  }

  void displayConstellation(int num, color c) {
    if (constellationG == num) {
      display(c);
    } else {
      displayNone();
    }
  }

  void displayAngle(int start, int end, color c) {
    if (end < -360) {
      if (ang >= radians(start) || ang < end + 360) {
        display(c);
      }
    } else if (ang >= radians(start) && ang < radians(end)) {
      display(c);
    } else {
      displayNone();
    }
  }


  void displayEqualizer(int[] bandH, color c) {
    if (p1.x >= 0 && p1.x < width/4) {
      displayBandY(0, bandH[0], c);
    } else if (p1.x >= width/4 && p1.x < width/2) {
      displayBandY(0, bandH[1], c);
    } else if (p1.x >= width/2 && p1.x < width*3.0/4) {
      displayBandY(0, bandH[2], c);
    } else {
      displayBandY(0, bandH[3], c);
    }
  }

  void displayPointX(int x) {
    float ym;

    if (x > p1.x && x < p2.x) {
      ym = map(x, p1.x, p2.x, p1.y, p2.y);
      ellipse(x, ym, 10, 10);
    } else if (x > p2.x && x < p1.x) {
      ym = map(x, p2.x, p1.x, p2.y, p1.y);
      ellipse(x, ym, 10, 10);
    }
  }

  void displayPointY(int y) {
    float xm;
    if ( (y > p1.y && y < p2.y) ) {
      xm = map(y, p1.y, p2.y, p1.x, p2.x);
      ellipse(xm, y, 10, 10);
      //println(y + " " + xm);
    } else if (y > p2.y && y < p1.y) {
      xm = map(y, p2.y, p1.y, p2.x, p1.x);
      ellipse(xm, y, 10, 10);
      //println(y + " " + xm);
    }
  }

  // www.jeffreythompson.org/collision-detection/line-point.php
  boolean mouseOver() {
    float x1 = p1.x;
    float y1 = p1.y;
    float x2 = p2.x;
    float y2 = p2.y;
    float px = mouseX;
    float py = mouseY;
    float d1 = dist(px, py, x1, y1);
    float d2 = dist(px, py, x2, y2);
    float lineLen = dist(x1, y1, x2, y2);
    float buffer = 0.2;    // higher # = less accurate
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      return true;
    }
    return false;
  }

  void setConstellationG(int k) {
    constellationG = k;
    println("constellation of " + id1 + "" + id2 + " is now " + k);
  }

  void setZIndex(int k) {
    zIndex = k;
    println("zIndex of " + id1 + "" + id2 + " is now " + k);
  }

  void displayByIDs(int id1, int id2) {
    if (findByID(id1, id2)) {
      display();
    }
  }

  void displayZIndex() {
    colorMode(HSB, 255);
    display(color(map(zIndex, 0, numRectZ-1, 0, 255), 255, 255));
  }

  void displayByIDsPercent(int id1, int id2, float per) {
    if (findByID(id1, id2)) {
      displayPercent(per);
    }
  }

  void displayRainbowCycle(int pulse) {
    //color c =  color(((i * 256 / lines.size()) + pulseIndex) % 255, 255, 255);
    colorMode(HSB, 255);
    for (float i = 0; i < 50; i++) {
      if (z1 <= z2) {
        float z = map(i, 0, 50, z1, z2);
        float s = map(z, 0, 9, 0, 255);
        stroke((s+pulse)%255, 255, 255);

        PVector pTemp = PVector.lerp(p1, p2, i/50.0);
        PVector pTempEnd = PVector.lerp(pTemp, p2, (i+1)/50.0);
        line(pTemp.x, pTemp.y, pTempEnd.x, pTempEnd.y);
      }
    }
    colorMode(RGB, 255);
  }

  void displayRainbowRandom() {
    rainbowIndex++;
    if (rainbowIndex > 255) rainbowIndex = 0;
    colorMode(HSB, 255);
    display(color(rainbowIndex, 255, 255));
    colorMode(RGB, 255);
  }

  void handLight(float x, float y, int rad, color c) {
    float i = 0.0;
    float startX = p1.x;
    float startY = p1.y;
    boolean started = false;
    while (i < 1.0) {
      i+= .1;
      if (!started) {
        float dx = map(i, 0, 1.0, p1.x, p2.x);
        float dy = map(i, 0, 1.0, p1.y, p2.y);
        float dis = dist(x, y, dx, dy);
        if (dis < rad) {
          startX = dx;
          startY = dy;
          started = true;
        }
      } else {
        float dx = map(i, 0, 1.0, p1.x, p2.x);
        float dy = map(i, 0, 1.0, p1.y, p2.y);
        float dis = dist(x, y, dx, dy);
        if (dis > rad) {
          stroke(c);
          line(startX, startY, dx, dy);
          break;
        }
      }
    }
  }

  void displaySegment(float startPer, float sizePer) {
    PVector pTemp = PVector.lerp(p1, p2, startPer);
    PVector pTempEnd = PVector.lerp(pTemp, p2, startPer + sizePer);
    line(pTemp.x, pTemp.y, pTempEnd.x, pTempEnd.y);
  }

  boolean findByID(int id1, int id2) {
    return (this.id1 == id1 && this.id2 == id2) || (this.id2 == id1 && this.id1 == id2);
  }

  boolean findByID(int id) {
    return (this.id1 == id || this.id2 == id);
  }

  int getX1() {
    return int(p1.x);
  }

  int getX2() {
    return int(p2.x);
  }

  int getY1() {
    return int(p1.y);
  }

  int getY2() {
    return int(p2.y);
  }

  void setGradientZ(color c1, color c2, int jump) {
    colorMode(HSB, 255);
    int colhue = (frameCount%255) + zIndex*jump;
    if (colhue < 0) colhue += 255;
    else if (colhue > 255) colhue -= 255;
    colorMode(RGB, 255);
    float m;
    if (colhue < 127) {
      m = constrain(map(colhue, 0, 127, 0, 1), 0, 1);
      display(lerpColor(c1, c2, m));
    } else {
      m = constrain(map(colhue, 127, 255, 0, 1), 0, 1);
      display(lerpColor(c2, c1, m));
    }
  }
}