//updates if we are animating a maze-generate right now
void genScreenMode(){
  
  //keep doing this until we've reached the end of our mazegen commands
  if (genCommandsIndex < genCommands.size()){
    
    //get the command for this frame
    MazeGenerationCommand command = genCommands.get(genCommandsIndex);
    
    //for each of the parts of a command (visiting square, adding/removing walls)
    //, check if that part contains an instruction and execute it
    if (command.visitedSquare != null){
      PVector squareCovered = command.visitedSquare;
      maze.grid[int(squareCovered.x)][int(squareCovered.y)] = 1;
    }
    if (command.removedHorizontal != null){
      PVector h = command.removedHorizontal;
      maze.horizontalWalls[int(h.x)][int(h.y)] = 0;
    }
    if (command.removedVertical != null){
      PVector v = command.removedVertical;
      maze.verticalWalls[int(v.x)][int(v.y)] = 0;
    }
    if (command.addedHorizontal != null){
      PVector h = command.addedHorizontal;
      maze.horizontalWalls[int(h.x)][int(h.y)] = 1;
    }
    if (command.addedVertical != null){
      PVector v = command.addedVertical;
      maze.verticalWalls[int(v.x)][int(v.y)] = 1;
    }
    
    //after executing the commands, increase the index to the next command for the next frame
    genCommandsIndex ++;
  }
  
  
  //once we've reached the end of our commnads, we can end the generation
  else{
    endGen();
  }
}

//updates
void solveScreenMode(){
  
  //if the solve we are animating is one that gives path instructions (random or right turn)
  if (stringInArray(solveAlgo, algosWithPath)){
    if (solvePathIndex < solvePath.length()){
      maze.grid[int(maze.currentSquare.x)][int(maze.currentSquare.y)] = 1;
      char currentCommand = solvePath.charAt(solvePathIndex);
      maze.turnGuy(currentCommand);
      maze.moveGuyForward();
      solvePathIndex ++;
    }
    else{
      endSolve();
    }
  }
  
  
  //if the solve we are animating is one that provides a snailtrail path (recursive or dijsktra's)
  else{
    
    //stop the solve if the maze wasn't solveable
    if (solvePath.equals("NO SOLVE")){
      endSolve();
    }
    
    //we only need to follow the snailtrail provided
    int row = int(maze.currentSquare.x);
    int col = int(maze.currentSquare.y);
    
    //keep doing so until we've reached the end square from the snailtrail
    if ( !(row == maze.endSquare.x && col == maze.endSquare.y) ){
      //get command, based on if our snailtrail is above, below, left, or to the right of us. 
      //as we move, we keep track of the squares on the snailtrail we visited so we don't retrace our steps back along the snailtrail
      //maze.grid2 contains the original snailtrail (yellow) and maze.grid contains the new snailtrail (purple)
      
      //if we should go up
      if (!maze.isWallAbove(row, col) && maze.grid[row-1][col] == 0 && maze.grid2[row-1][col] == 1){
        maze.direction = 90;
      }
      //if we should go down
      else if (!maze.isWallBelow(row, col) && maze.grid[row+1][col] == 0 && maze.grid2[row+1][col] == 1){
        maze.direction = 270;
      }
      //if we should go left
      else if (!maze.isWallToLeft(row, col)  && maze.grid[row][col-1] == 0 && maze.grid2[row][col-1] == 1){
        maze.direction = 180;
      }
      //if we should go right
      else if (!maze.isWallToRight(row, col) && maze.grid[row][col+1] == 0 && maze.grid2[row][col+1] == 1){
        maze.direction = 0;
      }
      //if none of the above, the maze wasn't solveable
      else{
        endSolve();
      }
      
      //now that we have set the appropriate direction, mark the square we've visisted and drwa the new snailtrail in purple
      maze.grid2[row][col] = 0; //update the original yellow snailtrail
      maze.grid[row][col] = 1; //update the new purple snailtrail
      maze.moveGuyForward(); //move forward
    }
    
    //once we've reached the endsquare, we can end the solve
    else{
      endSolve();
    }
  }
}

//draws a message under the maze (e.g. got stuck or not solveable)
void drawMessage(){
  if (message != ""){
    fill(255);
    textSize(15);
    textAlign(CENTER, CENTER);
    text(message, 235, 548);
    textAlign(LEFT, TOP);
  }
}

//draws the current algo's name and description to the right of the maze
void drawAlgoDescriptions(){
  fill(255);
  textSize(20);
  text(selectedSolveAlgo + ":", 490, 120);
  textSize(12);
  text(algoDescription, 490, 150, 740, 550);
}

//begins a maze generation
void beginGen(String algo){  
  resetGrid(); //reset the grid
  mouseMode = "None"; //reset mouseMode
  
  //use appropraite algo to gather commands for the maze generation
  if (algo.equals("Depth First Generate")){
    genCommands = maze.depthFirstGenerate();
  }
  else{
    println("INVALID GEN ALGO");
    assert false;
  }
  
  //we we want to show the generation steps, setup for the animation
  if (showGenerationSteps){
    screenMode = "Generating";
    genAlgo = algo;
    genCommandsIndex = 0;
    emptyCells(maze.grid);
    maze.fillWalls();
    frameRate(genFrameSpeed);
  }
  //if not, we've already generated the maze and are good to go
}


//stops a generation animation
void endGen(){
  resetGrid();
  screenMode = "None";
  frameRate(60);
}


//begins a solve animation
void beginSolve(String algo){
  endSolve(); //end any solves that are currently running
  message = ""; //reset any previous error messages
  resetGrid(); //reset the grid
  mouseMode = "None"; //stop the mouse from doing anything while we solve
  screenMode = "Solving"; //update screenmode
  
  //instruction-path algos
  if (algo.equals("Right Turn Solver")){
    solvePath = maze.getRightWallSolverPath();
  }
  else if (algo.equals("Random Solver")){
    solvePath = maze.getRandomSolverPath();
  }
  
  //snailtrail highliting algos
  else if (algo.equals("Recursive Solver")){
    if (maze.fillRecursiveSolverPath()){
      solvePath = "";
    }
    else{
      solvePath = "NO SOLVE";
    }
  }
  else if (algo.equals("Dijkstra's Solver")){
    if(maze.fillDijkstrasAlgorithmPath()){
      solvePath = "";
    }
    else{
      solvePath = "NO SOLVE";
    }
  }
  
  else{
    //we were given an invalid solve algorithm
    //just use right follower by default.
    solvePath = maze.getRightWallSolverPath();
  }
  
  //setup for the animation
  solveAlgo = algo;
  solvePathIndex = 0;
  maze.moveGuyToStart();
  frameRate(solveFrameSpeed);
  //end solve right away if the maze wasn't solveable by the higher-algos
  if (solvePath.equals("NO SOLVE")){
    endSolve();
  }
}

//ends a solve animation
void endSolve(){
  screenMode = "None";
  solvePath = "";
  frameRate(60);
}

//resets the grid (clear snailtrails and move guy)
void resetGrid(){
  emptyCells(maze.grid);
  emptyCells(maze.grid2);
  maze.moveGuyToStart();
}
