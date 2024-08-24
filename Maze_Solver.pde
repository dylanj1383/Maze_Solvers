/***
FINAL G12 CS PROJECT
MAZE SOLVER
DYLAN JAYABAHU
***/

//IMPORTS
import g4p_controls.*;

//GLOBAL VARIABLES & PARAMETERS
Maze maze; //the maze for our code
String screenMode; // None, Generating, Solving
String selectedSolveAlgo, algoDescription, message; //texts that are displayed on the window
String randomDescription, rightDescription, recursiveDescription, dijkstraDescription; //descriptions for each of the algos
String[] algosWithPath = {"Right Turn Solver", "Random Solver"}; //the algos without paths are recursive and dijkstra's 
String mouseMode; //None, Changing Start Square, Changing End Square
String solvePath; //for algosWithPath, a string containing characters coding the path the algo takes
int solvePathIndex; //the index we are at in solvePath
String solveAlgo; //the name of the algo we solved with (not necessarily the one we have selected)
ArrayList<MazeGenerationCommand> genCommands; //a list of commands that we used to generate the current maze
int genCommandsIndex; //the index we are at in genCommands
String genAlgo; //the algo we used to generate the maze
int solveFrameSpeed = 5; //framerate when solving
int genFrameSpeed = 60; //framerate when generating
boolean showGenerationSteps = false; //whether or not we show the steps taken to generate the maze
int mazeFullness = 8; //how full the maze is; more full = more walls
int recursionCap = 50; //if a solving algorithm visits the same square more than 50 times, stop the recursion and assume we couldn't solve the maze
//^ 50 is a bit overkill, but we want to be able to show the random algo's moving around for a bit longer


//SETUP AND DRAW
void setup(){
  size(800, 600); //create screen
  createGUI(); //create gui
  
  //gather info from sliders
  mazeFullness = mazeFullnessSlider.getValueI();
  solveFrameSpeed = solveSpeedSlider.getValueI();
  
  
  maze = new Maze(new PVector(50, 100), 20, 20, 20); //create our maze
  maze.depthFirstGenerate(); //generate an initial maze
  
  //set screen and mouse modes
  screenMode = "None";
  mouseMode = "None";
  
  //set solve messages and algos
  solvePath = "";
  solvePathIndex = 0;
  solveAlgo = "";
  message = "";
  selectedSolveAlgo = "Random Solver";
  
  //set algorithm descriptions
  randomDescription =  "Attempts to solve the maze by choosing a random \ndirection out of the possible options and going one \nstep in that direction. It repeats this until it \nhas solved the maze or gives up. One of the \nless good algorithms that basically never \nsolves the maze in time for my patience.";
  rightDescription = "Solves the maze by always turning right whenever \nit can - essentially keeping one hand on the right \nwall. If the maze is not very full and the start \nsquare is not on the edge, this algorithm easily \ngets stuck in a loop and won't be able \nto solve the maze.";
  recursiveDescription = "This algorithm uses recursion to solve the maze. \nFrom a given square, it gathers the possible \nmoves and recursively calls itself on all those \nnew squares. It is guaranteed to solve the maze \nif it has a solution, and can tell you if \nthere is no solution as well. However, it doesn't \nnecesssarily produce the fastest way out of the \nmaze.";
  dijkstraDescription = "This uses Dijkstra's shortest path algorithm \n(used for google maps). It interprets the maze \nas a graph with each square being a node and \npaths between adjacent squares as edges. It then \nruns Dikjstra's algorithm on the graph with \nequal edge weightings to find the shortest path \nfrom the given start to end squares, if it exists.";
  algoDescription = randomDescription;
 
}

//draw
void draw(){
  background(0); //drawbackground
  maze.drawMaze(); //draw maze

  //update if we are currently animating a solve or a generate
  if (screenMode.equals("Solving")){
    solveScreenMode();
  }
  else if (screenMode.equals("Generating")){
    genScreenMode();
  }
  
  //draw the algo decriptions and any message to be displayed
  drawAlgoDescriptions();
  drawMessage();
}
