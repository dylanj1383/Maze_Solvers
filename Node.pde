class Node{
  PVector location; //nodes can be referenced by their location, since each not has a distinct pvector location in thr graph
  PVector[] edges; //edges are really connections to other nodes. 
  //for the purposes of this program, I don't care about weighted edges (they all have a weight of 1)
   
  float distFromStart; //the distance to the startsquare, used for Dijsktra's algo
  PVector cameFrom; //the location of the node we came from
  boolean isDone; //a node is done once we've checked all the edge coming out of it
  
  Node(PVector location, ArrayList<PVector> givenEdges){
    this.location = location;
    
    this.edges = new PVector[givenEdges.size()];
    for (int i = 0; i < givenEdges.size(); i++){
      this.edges[i] = givenEdges.get(i);
    }
    
    this.distFromStart = Float.POSITIVE_INFINITY;
    this.cameFrom = null;
    this.isDone = false;
  }
  
  void finish(){
    this.isDone = true;
  }
}
