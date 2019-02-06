//import java.util.*;
//import java.util.LinkedList;
//import java.util.List;
//import java.util.Map;

//class GraphList {

//  //int graphSize;
//  //int currentNodeIndex = -1;
//  //ArrayList<Node> nodes;
//  //Map<Integer, List<Integer>> nodeList;


//  //GraphList(int num) {
//  //  graphSize = num;
//  //  nodes = new ArrayList<Node>();
//  //  nodeList = new HashMap<Integer, List<Integer>>();
//  //  for (int i = 0; i < graphSize; i++) {
//  //    nodeList.put(i, new LinkedList<Integer>());
//  //  }
//  //}


////  public void setEdge(int to, int from) 
////  {
////    if (to > nodeList.size() || from > nodeList.size()) {
////      //System.out.println("The vertices does not exists");
////    } else {
////      List<Integer> sls = nodeList.get(to);
////      sls.add(from);
////      List<Integer> dls = nodeList.get(from);
////      dls.add(to);
////    }
////  }

//  void removeEdges(int index) {
//    List<Integer> adjacentNodes = nodeList.get(index);
//    if (adjacentNodes != null) {
//      for (int j = 0; j < adjacentNodes.size(); j++) {
//        int adjNodeID = adjacentNodes.get(j);
//        List<Integer> secondAdjacentNodes = nodeList.get(adjNodeID);  // list of nodes of an adjacent node (adjacent to one being removed)
//        for (int k = secondAdjacentNodes.size() - 1; k >= 0; k--) {    // go through second list; if one of the items is the original index, remove it
//          if (secondAdjacentNodes.get(k) == index) {
//            nodeList.get(adjNodeID).remove(k);
//            //println("removing " + index + " from " + k);
//          }
//        }
//        //println(adjNodeID + " size: " + nodeList.get(adjNodeID).size());
//      }
//    }
//    // reset node list
//    nodeList.put(index, new LinkedList<Integer>());
//  }

//  // use this for loading graph to prevent duplicates
//  //void setDirectedEdge(int to, int from) {
//  //  //println(to + " " + from);
//  //  if (to > nodeList.size() || from > nodeList.size()) {
//  //    //System.out.println("The vertices does not exists");
//  //  } else {
//  //    List<Integer> sls = nodeList.get(to);
//  //    sls.add(from);
//  //  }
//  //}

//  List<Integer> getEdge(int to) {
//    if (to > nodeList.size()) {
//      //println("The vertices does not exists");
//      return null;
//    }
//    return nodeList.get(to);
//  }

//  void display() {
//    for (int v = 0; v < nodes.size(); ++v) {
//      int x1, y1;
//      Node n = nodes.get(v); // could get to the point where this call isn't necessary- just tmp->x, tmp->y (that x, y is saved 2x)
//      n.display();
//      x1 = n.getX();
//      y1 = n.getY();



//      //fill(255);
//      //stroke(255);
 
//      nodes.get(v).display();
//      // draw lines between nodes

//      List<Integer> edgeList = getEdge(v);
//      if (edgeList != null) {
//        for (int j = 0; j < edgeList.size(); j++) {
//          //println("edge " + j + " " + edgeList.get(j) + " " + edgeList.size());
//          Node n2 = nodes.get(edgeList.get(j));
//          line(x1, y1, n2.getX(), n2.getY());
//        }
//      }
//    }
//  }

//  void displayNodes() {
//    for (int i = 0; i < nodes.size(); i++) {
//      nodes.get(i).display();
//    }
//  }

//  void displayNodeLabels() {
//    for (int i = 0; i < nodes.size(); i++) {
//      nodes.get(i).displayLabel();
//    }
//  }

//  //void printGraph() {
//  //  for (int v = 0; v < nodes.size(); ++v) {
//  //    fill(255);
//  //    // draw lines between nodes
//  //    System.out.print(v + "->");
//  //    List<Integer> edgeList = getEdge(v);
//  //    if (edgeList != null) {
//  //      for (int j = 0; j<edgeList.size(); j++) 
//  //      {
//  //        if (j != edgeList.size() -1) {
//  //          System.out.print(edgeList.get(j) + " -> ");
//  //        } else {
//  //          System.out.print(edgeList.get(j));
//  //          break;
//  //        }
//  //      }
//  //    }
//  //    println();
//  //  }
//  //}

//  //void saveGraph() {
//  //  processing.data.JSONObject json;
//  //  json = new processing.data.JSONObject();
//  //  json.setInt("nodeNum", nodes.size());
//  //  saveJSONObject(json, "data/graph/graph.json");

//  //  int h = 0;

//  //  Iterator<Node> it = nodes.iterator();
//  //  while (it.hasNext()) {
//  //    Node n = it.next();
//  //    processing.data.JSONObject json2;
//  //    json2 = new processing.data.JSONObject();

//  //    json2.setString("ID", n.ID);
//  //    json2.setInt("x", n.x);
//  //    json2.setInt("y", n.y);
//  //    json2.setInt("z", n.z);

//  //    // adjacent node names
//  //    processing.data.JSONArray adjacentNodes = new processing.data.JSONArray();      
//  //    List<Integer> edgeList = getEdge(h);
//  //    if (edgeList != null) {
//  //      for (int j = 0; j < edgeList.size(); j++) 
//  //      {
//  //        adjacentNodes.setString(j, edgeList.get(j) + "");
//  //      }
//  //    }
//  //    json2.setJSONArray("adjacentNodes", adjacentNodes);
//  //    saveJSONObject(json2, "data/graph/" + n.ID + ".json");
//  //    h++;
//  //  }
//  //  saveLines();
//  //}

//  //void createNewLines() {
//  //  lines = new ArrayList<Line>();
//  //  addLines();
//  //}

//  void loadGraph() {

//    processing.data.JSONObject graphJson;
//    graphJson = loadJSONObject("data/graph/graph.json");
//    int numNodes = graphJson.getInt("nodeNum");
//    //println(numNodes);
//    resetList();

//    // create the nodes from JSON file
//    ArrayList<Node> tempNodes = new ArrayList<Node>();
//    for (int i = 0; i < numNodes; i++) {
//      processing.data.JSONObject nodeJson = loadJSONObject("data/graph/" + i + ".json");
//      String name = nodeJson.getString("ID");
//      int x = nodeJson.getInt("x");
//      int y = nodeJson.getInt("y");
//      int z = nodeJson.getInt("z");
//      tempNodes.add(new Node(name, x, y, z));
//      //tempNodes.add(new Node(name, x, y));
//    }

//    // create the edges from JSON file
//    for (int i = 0; i < tempNodes.size(); i++) {
//      processing.data.JSONObject nodeJson = loadJSONObject("data/graph/" + i + ".json");
//      processing.data.JSONArray adjNodes = nodeJson.getJSONArray("adjacentNodes");
//      for (int j = 0; j < adjNodes.size(); j++) {
//        setDirectedEdge(i, parseInt(adjNodes.getString(j)));
//      }
//    }

//    for (int i = 0; i < tempNodes.size(); i++) {
//      nodes.add(tempNodes.get(i));
//    }
//    //addLines();
//    loadLines();
//    bubbleSortDescending();
//  }

//  //void addNode(int mx, int my) {
//  //  nodes.add(new Node(nodes.size() + "", mx, my));
//  //}


//  //void removeNode(int index) {
//  //  removeEdges(index);
//  //  nodes.get(index).move(-100, -100);
//  //  deleteLines(index);
//  //  printGraph();
//  //}


//  //boolean hasCurrentNode() {
//  //  return (currentNodeIndex > -1);
//  //}

//  //void moveCurrentNode(int dx, int dy) {
//  //  nodes.get(currentNodeIndex).move(dx, dy);
//  //}

//  //void displayCurrentNode() {
//  //  if (hasCurrentNode()) {
//  //    fill(0, 255, 0);
//  //    stroke(0, 255, 0);
//  //    nodes.get(currentNodeIndex).display();
//  //  }
//  //}

//  //void setCurrentNodeZ(int zp) {
//  //  nodes.get(currentNodeIndex).z = zp;
//  //}

//  //int getClickedNode(int mx, int my) {
//  //  for (int i = 0; i < nodes.size(); i++) {
//  //    if (nodes.get(i).mouseOver(mx, my)) {
//  //      return i;
//  //    }
//  //  }
//  //  return -1;
//  //}

//  //void checkEdgeClick(int mx, int my) {
//  //  int prevNodeIndex = currentNodeIndex;
//  //  currentNodeIndex = getClickedNode(mx, my);
//  //  //cout << currentNodeIndex << " " << prevNodeIndex << std::endl;
//  //  // if we actually clicked on a star to create an edge
//  //  if (currentNodeIndex >= 0) {
//  //    // if we've already selected a star
//  //    if (prevNodeIndex >= 0) {
//  //      // oops, clicked on the same star
//  //      if (prevNodeIndex == currentNodeIndex) {
//  //        currentNodeIndex = -1;
//  //      }
//  //      // clicked a new star! let's add an edge
//  //      else {
//  //        // add link in adjacency matrix
//  //        setEdge(prevNodeIndex, currentNodeIndex);
//  //        Node n2 = nodes.get(prevNodeIndex);
//  //        Node n1 = nodes.get(currentNodeIndex);
//  //        lines.add(new Line(n1.getX(), n1.getY(), n2.getX(), n2.getY(), prevNodeIndex, currentNodeIndex));
//  //      }
//  //    }
//  //  }
//  //}


//  //void checkNodeClick(int mx, int my) {
//  //  currentNodeIndex = getClickedNode(mx, my);
//  //}

//  //void checkDeleteNodeClick(int mx, int my) {
//  //  currentNodeIndex = getClickedNode(mx, my);
//  //  if (currentNodeIndex > -1) {
//  //    removeNode(currentNodeIndex);
//  //    currentNodeIndex = -1;
//  //  }
//  //}

//  //int getCurrentNode() {
//  //  //cout << currentNodeIndex << std::endl;
//  //  return currentNodeIndex;
//  //}

//  //void setCurrentNode(int num) {
//  //  this.currentNodeIndex = num;
//  //}

//  //void drawLineToCurrent(int x, int y) {
//  //  stroke(255);
//  //  if (currentNodeIndex > -1 && currentNodeIndex < nodes.size()) {
//  //    line(nodes.get(currentNodeIndex).getX(), nodes.get(currentNodeIndex).getY(), x, y);
//  //  }
//  //}

//  //void resetList() {
//  //  nodes = new ArrayList<Node>();
//  //  lines = new ArrayList<Line>();
//  //  nodeList = new HashMap<Integer, List<Integer>>();
//  //  for (int i = 0; i < graphSize; i++) {
//  //    nodeList.put(i, new LinkedList<Integer>());
//  //  }
//  //}



//  //float getAngle(int x0, int y0, int x1, int y1) {
//  //  return atan2((y1 - y0)*1.0, (x1 - x0)*1.0);
//  //}

//  //void addLines() {
//  //  int l = 0;
//  //  for (int i = 0; i < nodes.size(); i++) {
//  //    Node n = nodes.get(i);
//  //    List<Integer> edgeList = getEdge(i);
//  //    if (edgeList != null) {
//  //      for (int j = 0; j < edgeList.size(); j++) 
//  //      {
//  //        int nextEdge = edgeList.get(j);
//  //        if (nextEdge > i) {
//  //          //println(i + " " + nextEdge);
//  //          Node n2 = nodes.get(nextEdge);
//  //          // i, nextEdge
//  //          lines.add(new Line(n.getX(), n.getY(), n2.getX(), n2.getY(), i, nextEdge));
//  //          l++;
//  //        }
//  //      }
//  //    }
//  //    // only add adjnodes if they have a greater id than the current node (nodes.get(i).hasAdjacent
//  //  }
//  //}

//  // returns the ID of the edge that is closest in distance to starting (index)
//  // node; returns -1 if the current node is closer than its edges to the goal
//  //int getClosestNode(int index, PVector goal) {
//  //  int closest = -1;
//  //  Node n = nodes.get(index);
//  //  float dis = n.getDistance(goal);
//  //  List<Integer> edgeList = getEdge(index);
//  //  if (edgeList != null) {
//  //    for (int j = 0; j < edgeList.size(); j++) {
//  //      Node n2 = nodes.get(edgeList.get(j));
//  //      float dis2 = n2.getDistance(goal);
//  //      if (dis2 < dis) {
//  //        dis = dis2;
//  //        closest = edgeList.get(j);
//  //      }
//  //    }
//  //  }
//  //  return closest;
//  //}


//  //void saveLines() {
//  //  processing.data.JSONObject json;
//  //  json = new processing.data.JSONObject();
//  //  json.setInt("linesNum", lines.size());
//  //  saveJSONObject(json, "data/graph/lines.json");

//  //  for (int i = 0; i < lines.size(); i++) {
//  //    processing.data.JSONObject json2;
//  //    json2 = new processing.data.JSONObject();
//  //    Line l = lines.get(i);
//  //    json2.setInt("id1", l.id1);
//  //    json2.setInt("id2", l.id2);
//  //    json2.setInt("x1", l.getX1());
//  //    json2.setInt("y1", l.getY1());
//  //    json2.setInt("x2", l.getX2());
//  //    json2.setInt("y2", l.getY2());
//  //    json2.setInt("z1", l.zIndex);
//  //    json2.setInt("cg", l.constellationG);

//  //    saveJSONObject(json2, "data/graph/line" + i + ".json");
//  //  }
//  //}

//  //void loadLines() {
//  //  processing.data.JSONObject json;
//  //  json = loadJSONObject("data/graph/lines.json");
//  //  int linesNum = json.getInt("linesNum");

//  //  for (int i = 0; i < linesNum; i++) {
//  //    processing.data.JSONObject lineJson = loadJSONObject("data/graph/line" + i + ".json");
//  //    int id1 = lineJson.getInt("id1");
//  //    int id2 = lineJson.getInt("id2");
//  //    int x1 = lineJson.getInt("x1");
//  //    int y1 = lineJson.getInt("y1");
//  //    int x2 = lineJson.getInt("x2");
//  //    int y2 = lineJson.getInt("y2");
//  //    //int z = lineJson.getInt("z");
//  //    int cg = lineJson.getInt("cg");

//  //    lines.add(new Line(x1, y1, x2, y2, id1, id2));
//  //    //lines.get(i).zIndex = z;
//  //    lines.get(i).constellationG = cg;
//  //  }
//  //}


//  void bubbleSortDescending() {
//    int n = lines.size();

//    for (int i=0; i < n; i++) {
//      for (int j=1; j < (n-i); j++) {

//        if (lines.get(j-1).zAve < lines.get(j).zAve) {
//          //swap the elements!
//          Collections.swap(lines, j, j-1);
//        }
//      }
//    }
//  }
//}