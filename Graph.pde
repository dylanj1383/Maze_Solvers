//graph class used for dijkstra's algo
class Graph{
  Node[] nodes; //a graph is just a collection of nodes. The edges are built into the node class
  int numNodesDone; //how many nodes we have "finished" as we go through dijkstra's algo
  
  Graph(Node[] givenNodes){
    this.nodes = givenNodes;
    this.numNodesDone = 0;
  }
  
  //checks if all the nodes of the graph are done
  boolean areAllNodesDone(){
    return this.numNodesDone >= nodes.length;
  }
  
  //this finds the next node we should finish, by finding the lowest distFromStart value of all the unfinished nodes in the graph
  int lowestUnfinishedNodeIndex(){
    int lowestNodesIndex = 0;
    float minStartVal = Float.POSITIVE_INFINITY;
    
    //iterate through th list keeping track of our minVal and the index of the node containing that val
    for (int i = 0; i < this.nodes.length; i++){
      if (this.nodes[i].distFromStart < minStartVal && !this.nodes[i].isDone){
        minStartVal = this.nodes[i].distFromStart;
        lowestNodesIndex = i;
      }
    }
    
    return lowestNodesIndex; //return the index of the unfinished node with the lowest val
  }
  
  //given a node's location, return the actual node object
  Node findNodeGivenLocation(PVector l){
    
    //iterate through all the nodes until we find a match
    for (Node n : this.nodes){
      if (n.location.x == l.x && n.location.y == l.y){
        return n;
      }
    }
    
    //if for some reason it doesn't exist, print a message and return none
    println("Node with location", getVectorString(l), "not found");
    return null;
  }
}
