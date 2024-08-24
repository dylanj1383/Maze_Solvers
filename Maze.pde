//maze class
class Maze{
  int numRows, numCols; //rows and cols of the maze
  PVector startSquare, endSquare;  //squares are given as PVector(row, col)
    //by default, startSquare is (0, 0) and endSquare is (numRows-1, numCols-1)

  int[][] grid, grid2; //grid 2 is needed for the path-highlighting (snailtrail) algos
  
  PVector currentSquare; //coordinates of our "guy" solving the maze
  float direction; //the direction the guy is facing in degrees. 0 degrees is facing right
  
  //here, a value of 0 => no wall; 1 => wall
  int[][] verticalWalls; //has numRows rows and numCols-1 columns
  int[][] horizontalWalls; //has numRows-1 rows and numCols columns
  
  PVector pos; //coords of the top left corner when we draw the maze on screen
  float squareSize; //size of the squares when we draw the maze
  
  //the points used to show squares if there is no wall between them
  SnapPoint[][] snapPoints; //haps numRows+1 rows and numCols+1 cols
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///CONSTRUCTOR
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  Maze(PVector pos, int numRows, int numCols, float squareSize){
    //set num rows and cols
    this.numRows = numRows;
    this.numCols = numCols;

    //initialize arrays
    this.grid = new int[numRows][numCols];
    this.grid2 = new int[numRows][numCols];
    this.verticalWalls = new int[numRows][numCols-1];
    this.horizontalWalls = new int[numRows-1][numCols];
    
    //set starting direction to be 0
    this.direction = 0;
    
    //set the start and endsquares. By default startsquare is top left and endsquare is bottom right
    //user can change these with the gui
    this.startSquare = new PVector(0, 0);
    this.endSquare = new PVector(numRows-1, numCols-1);
    this.currentSquare = startSquare; //set the guy to be at the startsquare    
    
    //set the drawing values 
    this.pos = pos; //position of our maze on screen
    this.squareSize = squareSize;
    
    //initialize snapPoints array to the appropriate values to cover the grid
    this.snapPoints = new SnapPoint[numRows+1][numCols+1];
    for (int r = 0; r <= this.numRows; r++){
      for (int c = 0; c <= this.numCols; c++){
        SnapPoint p = new SnapPoint(this.pos.x+c*this.squareSize, this.pos.y+r*this.squareSize);
        this.snapPoints[r][c] = p;
      }
    }
    
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///MAZE-SOLVING METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //1. Random maze solver----------------------------------------------------------------------------------------------
  String getRandomSolverPath(){
    //set everythign up before running the solve
    this.moveGuyToStart();
    emptyCells(this.grid);
    
    String path = randSolve(""); //returns an string of instructions that solves the maze based on what the algorithm found
    
    //empty the cells we've filled and return the path the algo took
    emptyCells(this.grid);
    return path;
  }
  
  //randSolve recursive function 
  String randSolve(String movesSoFar){
    int row = int(this.currentSquare.x);
    int col = int(this.currentSquare.y);
    
    //keep track of which squares we've visited
    this.grid[row][col] ++;
    
    //base case if we've exceeded the recursion cap;
    if (this.grid[row][col] >= recursionCap){
      println("Random solver couldn't solve");
      message = "Random solver couldn't solve in time";
      return movesSoFar;
    }
    
    //base case if we've reached the end
    if (this.currentSquare.x == this.endSquare.x && this.currentSquare.y == this.endSquare.y){
      return movesSoFar;
    }
    
    //get our possible options from this square
    int[] options = this.possibleMovesFrom(row, col, this.direction);
    
    //for each of the options, add an encoding character to a list of choices
    String choices = "";
    if (options[0] == 1){
      choices += "f";
    }
    if (options[1] == 1){
      choices += "r";
    }
    if (options[2] == 1){
      choices += "b";
    }
    if (options[3] == 1){
      choices += "l";
    }
    
    //handle getting stuck
    if (choices.length() <= 0){
      println("No possible moves");
      message = "No possible moves";
      return movesSoFar;
    }
    
    //choose a direction at random from the choices
    int i = int(random(choices.length()));
    char move = choices.charAt(i);
    
    //move in that direction and keep track of the move we made
    this.turnGuy(move);
    movesSoFar += move; //add it to our moves so far
    
    //move forward
    this.currentSquare = this.moveForward(row, col, this.direction);
    
    //recursively call randSolve from our new position
    return randSolve(movesSoFar);
  }
  
  //2. Right turn solver-----------------------------------------------------------------------------------------------
  String getRightWallSolverPath(){
    //set up everything before running the solve
    this.moveGuyToStart();
    emptyCells(this.grid);
    
    String path = rwSolve(""); //returns an string of instructions that solves the maze based on what the algorithm found
    
    //empty any cell values we changed and return the path the right turn solver took
    emptyCells(this.grid);
    return path;
  }
  
  //recursive right turn solver function
  String rwSolve(String movesSoFar){
    int row = int(this.currentSquare.x);
    int col = int(this.currentSquare.y);
    
    //keep track of which squares we've visited
    this.grid[row][col] ++;
    
    //base case if we exceed the recursion cap
    if (this.grid[row][col] >= recursionCap){
      println("Right turn follower couldn't solve");
      message = "Right turn follower got stuck in a loop or couldn't solve";
      return movesSoFar;
    }
    
    //base case if we've reached the end
    if (this.currentSquare.x == this.endSquare.x && this.currentSquare.y == this.endSquare.y){
      return movesSoFar;
    }
    
    //get the possible moves from this square
    int[] options = this.possibleMovesFrom(row, col, this.direction);


    //check, in order, if we can go right, forward, left, and then back. Make the appropriate turn:
    //right
    if (options[1] == 1){
      this.direction = turnRight(this.direction);
      movesSoFar = movesSoFar + 'r';
    }
    
    //forward
    else if (options[0] == 1){
      //do nothing
      movesSoFar = movesSoFar + 'f';
    }
    
    //left
    else if (options[3] == 1){
      this.direction = turnLeft(this.direction);
      movesSoFar = movesSoFar + 'l';
    }
    
    //back
    else if (options[2] == 1){
      this.direction = turnAround(this.direction);
      movesSoFar = movesSoFar + 'b';
    }
    
    //else - there are no possible moves from this square
    else{
      println("No Possible Moves");
      message = "No Possible Moves";
      return movesSoFar;
    }
    
    //now that we have turned in the right direction, move forward
    this.currentSquare = this.moveForward(row, col, this.direction);
    //recursively call rwSolve from our new position
    return rwSolve(movesSoFar);
  }
  
  //3. Recursive maze solver-------------------------------------------------------------------------------------------
  //this algo finds a path more efficiently than right wall solver (depending on the maze) 
  //but it isn't necessarily the most efficient path possible
  //it never gets trapped in a loop and can tell you if the maze is not solvable
  boolean fillRecursiveSolverPath(){
    //returns whether or not the maze was solveable
    
    //set up everything before running the solve
    emptyCells(this.grid);
    emptyCells(this.grid2);
    
    //the recursive solver returns a boolean of whether or not it made it to the end
    boolean success = recursiveSolve(int(this.startSquare.x), int(this.startSquare.y));
    
    //if success is false, we know the maze is not solveable
    if (!success){
      println("This maze is not solveable");
      message = "This maze is not solveable";
    }
    
    //empty the cells in grid (but not in grid2, since that contains our path)
    emptyCells(this.grid);
    
    //move the guy to the start and return whether we were successful
    this.moveGuyToStart();
    return success;
  }
  
  //recursive solve function
  boolean recursiveSolve(int row, int col){
    //base case if we've reached the edge
    if (row == endSquare.x && col == endSquare.y){
      this.grid2[row][col] = 1;
      return true;
    }
    
    //base case if we've backtracked to a square we already visited
    if (this.grid[row][col] != 0){
      return false;
    }
    
    //no need for a basecase for exceeding recursion depth - this algo never gets stuck in a loop and won't cause stackoverflows
    
    //keep track of the square we've visited
    this.grid[row][col] = 1;
    
    //get all the squares we can go to
    //using recursion, solve the maze from each of our options
    //we will keep track of the squares of the correct path in this.grid 
    //(the order we discover a path in is not from start to end and because we may end up changing directions or positions spontaneously if there is dead end)
    
    
    boolean result; //the result of our recursive function call from each of our possible options
    //we only return true if a given decision leads to a solved maze (i.e. result is true)
    
    //if we can go up
    if (row>0 && !this.isWallAbove(row, col) && this.grid[row-1][col] == 0){
      result = recursiveSolve(row-1, col); //recursively solve from the square above
      if(result){
        this.grid2[row][col] = 1;
        return true;
      }
    }
    
    //if we can go down
    if (row+1 < numRows && !this.isWallBelow(row, col) && this.grid[row+1][col] == 0){
      result = recursiveSolve(row+1, col); //recursively solve from the square below
      if(result){
        this.grid2[row][col] = 1;
        return true;
      }
    }
    
    //if we can go left
    if (col>0 && !this.isWallToLeft(row, col) && this.grid[row][col-1] == 0){
      result = recursiveSolve(row, col-1); //recursively solve from the square to the left
      if(result){
        this.grid2[row][col] = 1;
        return true;
      }
    }
    
    //if we can go right
    if(col+1<numCols && !this.isWallToRight(row, col) && this.grid[row][col+1] == 0){
      result = recursiveSolve(row, col+1); //recursively solve from the square to the right
      if(result){
        this.grid2[row][col] = 1;
        return true;
      }
    }
    
    //if weve recursively gone through all our options and haven't returned, the maze is not solvable
    return false;
  }
  
  
  //4. Dijkstra's algorithm implemented for mazes----------------------------------------------------------------------------------
  //we can think of a maze as a graph, with each square being a node and having edges betweeen squares you can move to
  //the weights on the edges will all be 1, since each square on the grid is only connected to adjacent squares
  //we can run dijkstra's algorithm on it to find the shortest path from the start to the end. We know if the maze is unsolveable if the endNodes distFromStart is still infinity
  
  //returns wheather the maze is solveable
  boolean fillDijkstrasAlgorithmPath(){
    //setup grids
    emptyCells(this.grid);
    emptyCells(this.grid2);
    this.moveGuyToStart();
    
    //create a graph out of this maze
    Graph graph = this.toGraph();
    
    //keep repeating the algorithm until all the nodes are done
    while (!graph.areAllNodesDone()){
      
      //1. Find the node with the lowest distFromStart value
      int nodeIndex = graph.lowestUnfinishedNodeIndex(); //at the very start, this will be the starting square since it's dist will be 0
      Node currentNode = graph.nodes[nodeIndex];
      
      
      //2. Go through each of this node's edges, updating the destinations distance and pointer if applicable
      for (int i = 0; i < currentNode.edges.length; i++){
        //destination is what is on the other end of the edge
        PVector destinationLocation = currentNode.edges[i];
        Node destinationNode = graph.findNodeGivenLocation(destinationLocation);
        
        //we know it takes currentNode.distanceFromStart steps to get here
        //it therefore takes currentNode.distanceFromStart + 1 to get to destinationNode (when coming through currentNode)
          //we add 1 since each edge has a value of 1
        
        //if the path to destination node through currentnode is faster than whatever exists previously, we want to update it
        //that is, if currentNode.distanceFromStart + 1 < destinationNode.distanceFromStart
          // then, we want to update destinationNode's distance and its pointer
        
        if (currentNode.distFromStart + 1 < destinationNode.distFromStart){
          destinationNode.distFromStart = currentNode.distFromStart + 1;
          destinationNode.cameFrom = currentNode.location;
        }
      }
      
      //3. Mark this node as done after going through all it's edges
      currentNode.finish();
      graph.numNodesDone++;
    }
    
    //now we have gathered the correct path, stored in the nodes and their pointers
    
    //go through the nodes from back to front, highlighting their path as we do so
    Node pathNode = graph.findNodeGivenLocation(this.endSquare);
    
    
    //first, check if the maze is solvable by checking that the distFromStart of the endNode is not infinity
    Float distVal = pathNode.distFromStart;
    if (distVal.isInfinite()){
      println("This maze is not solvable");
      message = "This maze is not solveable";
      return false;
    }
      
    //if the maze is solveable, go through the pointers of the nodes, highlighting our path as we go
    while ( !(pathNode.location.x == this.startSquare.x && pathNode.location.y == this.startSquare.y) ){
      this.grid2[int(pathNode.location.x)][int(pathNode.location.y)] = 1;
      PVector pathNodeLocation = pathNode.cameFrom;
      pathNode = graph.findNodeGivenLocation(pathNodeLocation);
    }
    
    //we can safely return true, since we would've previously returned false if the maze wasn't solveable
    return true;
  }
  
  //Converts this maze to a graph, which we can run Dijkstra's algorithm on
  Graph toGraph(){
    //Nodes are equiped with fields so that dijkstra's algo can be run on the graph produced
    
    //for an m by n maze, there will be a total of m*n nodes
    Node[] nodes = new Node[this.numRows * this.numCols];
    
    //go through every square in the maze and make it a node, since each square is a node
    int i = 0;
    for (int r = 0; r < this.numRows; r++){
      for (int c = 0; c < this.numRows; c++){
        
        
        //we need to make a node out of the square at grid[r][c]
        PVector location = new PVector(r, c);
        
        ArrayList<PVector> edges = new ArrayList<PVector>(); //this keeps track of the edegs from this node
        
        //if we can move to a square in any direction, that is an edge to this node. Add the new square to our edges
        if (!this.isWallAbove(r, c)){
          edges.add(new PVector(r-1, c));
        }
        if(!this.isWallToRight(r, c)){
          edges.add(new PVector(r, c+1));
        }
        if(!this.isWallBelow(r, c)){
          edges.add(new PVector(r+1, c));
        }
        if(!this.isWallToLeft(r, c)){
          edges.add(new PVector(r, c-1));
        }
        
        //create a new node given our location and all it's edges
        Node n = new Node(location, edges);
        
        //set the distFromStart to be 0 if this node is the start node
        if (this.startSquare.x == r && this.startSquare.y == c){
          n.distFromStart = 0;
        }
        //otherwise, the default distFromStart is infinity
        
        //add this node to our list of nodes
        nodes[i] = n;
        i++; //incremend the index
      }
    }
    //return a new graph of all the nodes we just created
    return new Graph(nodes);
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///MAZE-GENERATION METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //returns an arraylist of commands that were used to generate the maze
  ArrayList<MazeGenerationCommand> depthFirstGenerate(){
    //first fill the maze with walls
    //starting from the start square, pick a direction at random. Destroy the wall in that direction, and note that we visited that square.
    //keep doing this until all the squares are visited.
    
    //empty the grid and fill the walls
    emptyCells(this.grid);
    this.fillWalls();
        
    //use recursion and remove only as many walls as needed to generate the solvable maze
    ArrayList<MazeGenerationCommand> commands = this.dfgSearch(int(this.startSquare.x), int(this.startSquare.y), new ArrayList<MazeGenerationCommand>());
    emptyCells(this.grid);

    //from here, we can add or remove additional walls
    //adding walls makes it possible for the maze to be unsolveable
    //removing walls makes it possible for the right turn solver to get stuck, and for there to be multipile paths to the end (where Dijsktra's algorithm would find the shortest)
    
    //as we remove or add walls, make sure to make commands out of them and add the command to the list
    
    //remove walls if fullness is less than 10
    if (mazeFullness < 10){
      int numExtraWallsRemoved = int(this.numRows*this.numCols/(mazeFullness+0.01));
      
      //remove some random additional walls to add multiple paths
      for (int i = 0; i < numExtraWallsRemoved/2; i++){
        int row = int(random(this.verticalWalls.length));
        int col = int(random(this.verticalWalls[0].length));
        this.verticalWalls[row][col] = 0;
        commands.add(new MazeGenerationCommand(null, null, new PVector(row, col)));
      }
      for (int i = 0; i < numExtraWallsRemoved/2; i++){
        int row = int(random(this.horizontalWalls.length));
        int col = int(random(this.horizontalWalls[0].length));
        this.horizontalWalls[row][col] = 0;
        commands.add(new MazeGenerationCommand(null, new PVector(row, col), null));
      }
    }
    
    //add walls if fullness is greater than 10
    else if (mazeFullness > 10){
      int numExtraWallsAdded = int(this.numRows * this.numCols*(mazeFullness-10)/1000);
      
      //add some random additional walls to add multiple paths
      for (int i = 0; i < numExtraWallsAdded/2; i++){
        int row = int(random(this.verticalWalls.length));
        int col = int(random(this.verticalWalls[0].length));
        this.verticalWalls[row][col] = 1;
        commands.add(new MazeGenerationCommand(null, new PVector(row, col)));
      }
      for (int i = 0; i < numExtraWallsAdded/2; i++){
        int row = int(random(this.horizontalWalls.length));
        int col = int(random(this.horizontalWalls[0].length));
        this.horizontalWalls[row][col] = 1;
        commands.add(new MazeGenerationCommand(new PVector(row, col), null));
      }
    }
    
    //return the list of commands for generating this maze
    return commands;
  }
  
  //recursive maze generation function
  ArrayList<MazeGenerationCommand> dfgSearch(int r, int c, ArrayList<MazeGenerationCommand> commandsSoFar){
    //grid contains 0s and 1s. 1 if we have visited the cell
    //r, c and the rows of the current cell
    
    //mark this square as visited
    this.grid[r][c] = 1;
    
    //if we haven't removed a horizontal or vertical wall, those pvectors will remain as null
    PVector visitedSquare, removedHorizontal, removedVertical;
    visitedSquare = new PVector(r, c);
    removedHorizontal = null;
    removedVertical = null;
    
    //get a list of our unvisited neighbours
    ArrayList<PVector> unvisitedNeighbours = getUnvisitedNeighbours(r, c);

    //while current cell has any unvisited neighbours, keep running the algorithm recursively
    while (unvisitedNeighbours.size() > 0){
      
      //chose a neighbour at random
      PVector chosenNeighbour = unvisitedNeighbours.get(int(random(0, unvisitedNeighbours.size())));
      int nr = int(chosenNeighbour.x); //neighbour row
      int nc = int(chosenNeighbour.y); //neighbour col
      
      //remove the wall between the grid[r][c] and grid[nr][nc]
      
      if (r == nr){
        //we need to remove the vertical wall between (r, c,) and (nr, nc)
        this.verticalWalls[r][(c+nc)/2] = 0;
        removedVertical = new PVector(r, (c+nc)/2);
      }
      else if (c == nc){
        //we need to remove the horizontal wall between (r, c,) and (nr, nc)
        this.horizontalWalls[(r+nr)/2][c] = 0;
        removedHorizontal = new PVector((r+nr)/2, c);
      }
      
      //keep track of the commands used to make the grid so far
      commandsSoFar.add(new MazeGenerationCommand(visitedSquare, removedHorizontal, removedVertical));
      
      //add to the commands, using the recursive call to dfgSearch on our new square
      commandsSoFar = dfgSearch(nr, nc, commandsSoFar);
      
      //re-check for unvisited neighbours
      unvisitedNeighbours = getUnvisitedNeighbours(r, c);
    }
    
    //once all the squares have no unvisited neighbours, we can return the commands
    return commandsSoFar;
  }
  
  //gets the unvisited neighbours from a given square (r,c)
  ArrayList<PVector> getUnvisitedNeighbours(int r, int c){
    ArrayList<PVector> unvisitedNeighbours = new ArrayList<PVector>();
    
    //check down neighbour
    if (r+1 < this.numRows && this.grid[r+1][c] == 0){
      unvisitedNeighbours.add(new PVector(r+1, c));
    }
    
    //check up neighbour
    if (r-1 >= 0 && this.grid[r-1][c] == 0){
      unvisitedNeighbours.add(new PVector(r-1, c));
    }
    
    //check right neighbour
    if (c+1 < this.numCols && this.grid[r][c+1] == 0){
      unvisitedNeighbours.add(new PVector(r, c+1));
    }
    
    //check left neighbour
    if (c-1 >= 0 && this.grid[r][c-1] == 0){
      unvisitedNeighbours.add(new PVector(r, c-1));
    }
    
    //return the arraylist of unvisited neighbours we discovered
    return unvisitedNeighbours;
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///DRAWING METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  //draws the maze
  void drawMaze(){
    this.drawSquares();
    this.drawStartEndSquares();
    this.drawWalls();
    this.drawSnapPoints();
    this.drawGuy();
  }
  
  //draw the squares of the maze
  void drawSquares(){
    
    //highlight any squares from this.grid in purple
    for(int r = 0; r < numRows; r++){
      for (int c = 0; c < numCols; c++){
        if (this.grid[r][c] == 1){
          this.highlightSquare(r, c, color(255, 0, 255, 60));
        }
      }
    }
    
    //highlight any squares from this.grid2 in yellow
    for(int r = 0; r < numRows; r++){
      for (int c = 0; c < numCols; c++){
        if (this.grid2[r][c] == 1){
          this.highlightSquare(r, c, color(255, 255, 0, 60));
        }
      }
    }
    
    //draw the previews of the start/end squares in green/red respectively
    if (this.isPointOnGrid(new PVector(mouseX, mouseY))){
      PVector s = this.getSquareIndexes(mouseX, mouseY);
      if (mouseMode.equals("Changing End Square")){
        this.highlightSquare(int(s.x), int(s.y), color(255, 0, 0, 70));
      }
      else if (mouseMode.equals("Changing Start Square")){
        this.highlightSquare(int(s.x), int(s.y), color(0, 255, 0, 70));
      }
    }
  }
  
  //draws the walls of the maze
  void drawWalls(){
    float x = this.pos.x;
    float y = this.pos.y;
    
    //draw outer the border walls as a rectangle
    stroke(255);
    fill(0, 0, 0, 0);
    rect(x, y, this.numCols*this.squareSize, this.numRows*this.squareSize);
    
    
    //draw vertical walls (int[][] verticalWalls; //has numRows rows and numCols-1 columns)
    //vertical walls will be purple
    for (int r = 0; r < numRows; r++){
      for (int c = 0; c < numCols-1; c++){
        if (this.verticalWalls[r][c] != 0){
          //there is a wall at the square given by getSquareCoords[r][c], on its right
          PVector sc = getSquareCoords(r, c); //sc = square coords
          float p1y = sc.y - this.squareSize/2.0;
          float p2y = sc.y + this.squareSize/2.0;
          float px = sc.x + this.squareSize/2.0;
          stroke(255, 0, 255);
          strokeWeight(2);
          line(px, p1y, px, p2y);
        }
      }
    }
    
    //draw horizontal walls (int[][] horizontalWalls; //has numRows-1 rows and numCols columns)
    //horizontal walls will be turquoise
    for (int r = 0; r < numRows-1; r++){
      for (int c = 0; c < numCols; c++){
        if (this.horizontalWalls[r][c] != 0){
          //there is a wall at the square given by getSquareCoords[r][c], underneath the square
          PVector sc = getSquareCoords(r, c); //sc = square coords
          float py = sc.y + this.squareSize/2.0;
          float p1x = sc.x - this.squareSize/2.0;
          float p2x = sc.x + this.squareSize/2.0;
          stroke(0, 255, 255);
          strokeWeight(2);
          line(p1x, py, p2x, py);
        }
      }
    }
  }

  //draw the snapPoints, so that it is clear that two squares are distinct even if there is no wall between them
  void drawSnapPoints(){
    for (SnapPoint[] ps : this.snapPoints){
      for (SnapPoint p : ps){
        p.drawSnapPoint();
      }
    }
  }
  
  //draw the start and end squares themselves (different from the previous drawn earlier)
  void drawStartEndSquares(){
    this.highlightSquare(int(this.startSquare.x), int(this.startSquare.y), color(0, 255, 0, 150));
    this.highlightSquare(int(this.endSquare.x), int(this.endSquare.y), color(255, 0, 0, 150));
  }
  
  //draw the guy in our maze and the direction he's pointing
  void drawGuy(){
    PVector gCoords = this.getSquareCoords(this.currentSquare.x, this.currentSquare.y); ///guy coords
    float r = this.squareSize/2;
    noStroke();
    fill(0, 255, 255);
    circle(gCoords.x, gCoords.y, r);
    stroke(0, 255, 255);
    strokeWeight(2);
    line(gCoords.x, gCoords.y, gCoords.x + r*cos(this.direction* PI/180), gCoords.y - r*sin(this.direction * PI/180));
  }
  
  //highlihgts the square at (row)(col) with color c
  void highlightSquare(int row, int col, color c){
    PVector p = getSquareCoords(row, col);
    noStroke();
    fill(c);
    rect(p.x - this.squareSize/2.0, p.y - this.squareSize/2.0, this.squareSize, this.squareSize);
  }
  
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //GENERAL METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void clearWalls(){
    emptyCells(this.horizontalWalls);
    emptyCells(this.verticalWalls);
  }
  
  void fillWalls(){
    fillCells(this.horizontalWalls);
    fillCells(this.verticalWalls);
  }
  
  PVector getSquareCoords(float row, float col){
    float x = this.pos.x + (col+0.5)*this.squareSize;
    float y = this.pos.y + (row+0.5)*this.squareSize;
    return new PVector(x, y);
  }
  
  PVector getSquareIndexes(float x, float y){
    int deltaX = int(x - this.pos.x);
    int deltaY = int(y - this.pos.y);
    int colNum = int(deltaX/this.squareSize);
    int rowNum = int(deltaY/this.squareSize);
    return new PVector(rowNum, colNum);
  }
 
  boolean isPointOnGrid(PVector p){
    return (this.pos.x < p.x && p.x < this.pos.x + this.numCols*this.squareSize) && (this.pos.y < p.y && p.y < this.pos.y+this.numRows*this.squareSize);
  }
  
  boolean isWallBelow(int row, int col){
    return (row >= this.numRows-1 || this.horizontalWalls[row][col] == 1);
  }
  
  boolean isWallAbove(int row, int col){
    return (row <= 0 || this.horizontalWalls[row-1][col] == 1);
  }
  
  boolean isWallToLeft(int row, int col){
    return (col <= 0 || this.verticalWalls[row][col-1] == 1);
  }
  
  boolean isWallToRight(int row, int col){
    return (col >= this.numCols-1 || this.verticalWalls[row][col] == 1);
  }
  int[] possibleMovesFrom(int row, int col, float direction){
    int r = 0; int l = 0; int u = 0; int d = 0;

    //check right wall
    if ( !this.isWallToRight(row, col) ){
      //there is no wall to our right
      r = 1;
    }
    
    //check left wall
    if ( !this.isWallToLeft(row, col) ){
      //there is no wall to our left
      l = 1;
    }
    
    //check up
    if ( !this.isWallAbove(row, col) ){
      //there is no wall above us
      u = 1;
    }
    
    //check down
    if ( !this.isWallBelow(row, col) ){
      //there is no wall below us
      d = 1;
    }
    
   
    //up:
    if (direction % 360 == 90){
      int[] moves = {u, r, d, l};
      return moves;
    }
    //right
    else if (direction %360 == 0){
      int[] moves = {r, d, l, u};
      return moves;
    }
    //down
    else if (direction %360 == 270){
      int[] moves = {d, l, u, r};
      return moves;
    }
    //left
    else if (direction %360 == 180){
      int[] moves = {l, u, r, d};
      return moves;
    }
    else{
      println("Invalid Direction:", direction);
      return null;
    }
  }
  
  void setStartSquareTo(int r, int c){
    this.startSquare = new PVector(r, c);
  }
  
  void setEndSquareTo(int r, int c){
    this.endSquare = new PVector(r, c);
  }
  
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///MAZE-NAVIGATION METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void turnGuy(char c){
    if (c == 'f'){
    }
    else if (c=='r'){
      this.direction = this.turnRight(this.direction);
    }
    else if (c=='b'){
      this.direction = this.turnAround(this.direction);
    }
    else if (c=='l'){
      this.direction = this.turnLeft(this.direction);
    }
    else{
      println("Invalid direction");
      assert false;
    }
  }
  
  void moveGuyForward(){
    PVector newPos = this.moveForward(int(this.currentSquare.x), int(this.currentSquare.y), this.direction);
    this.currentSquare = newPos;
  }
  
  void moveGuyToStart(){
    this.currentSquare = this.startSquare;
    this.direction = 0;
  }
  
  float turnRight(float direction){
    return (direction +270)%360;
  }
  
  float turnLeft(float direction){
    return (direction + 90)%360;
  }
  
  float turnAround(float direction){
    return (direction + 180)%360;
  }
  
  PVector moveForward(int r, int c, float direction){
    //assumes you are able to move forward
    
    if (direction%360 == 0){
      return new PVector(r, c+1);
    }
    else if (direction%360 == 90){
      return new PVector(r-1, c);
    }
    else if (direction%360 == 180){
      return new PVector(r, c-1);
    }
    else if (direction%360 == 270){
      return new PVector(r+1, c);
    }
    
    println("invalid direction");
    assert false;
    return null;
    
  }
}
