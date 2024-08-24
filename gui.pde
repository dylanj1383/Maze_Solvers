/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void win_draw2(PApplet appc, GWinData data) { //_CODE_:window1:251052:
  appc.background(230);
} //_CODE_:window1:251052:

public void mazeFullnessSliderDragged(GSlider source, GEvent event) { //_CODE_:mazeFullnessSlider:600623:
  mazeFullness = mazeFullnessSlider.getValueI();
  if (screenMode.equals("None") || screenMode.equals("Generating")){
    beginGen("Depth First Generate");
  }
  message = "";
} //_CODE_:mazeFullnessSlider:600623:

public void moveStartButtonClicked(GButton source, GEvent event) { //_CODE_:moveStartButton:372543:
  if (screenMode.equals("None")){
    if (mouseMode.equals("Changing Start Square")){
      mouseMode = "None";
    }
    else{
      mouseMode = "Changing Start Square";
    }
  }
  message = "";
} //_CODE_:moveStartButton:372543:

public void moveEndButtonClicked(GButton source, GEvent event) { //_CODE_:moveEndButton:456105:
  if (screenMode.equals("None")){
    if (mouseMode.equals("Changing End Square")){
      mouseMode = "None";
    }
    else{
      mouseMode = "Changing End Square";
    }
    
  };
  message = "";
} //_CODE_:moveEndButton:456105:

public void showMazeGenerationChecked(GCheckbox source, GEvent event) { //_CODE_:showMazeGenerationCheckbox:318584:
  showGenerationSteps = !showGenerationSteps;

} //_CODE_:showMazeGenerationCheckbox:318584:

public void generateMazeButtonClicked(GButton source, GEvent event) { //_CODE_:generateMazeButton:326371:
  if (screenMode.equals("None") || screenMode.equals("Generating")){
    beginGen("Depth First Generate");
  }
  message = "";
} //_CODE_:generateMazeButton:326371:

public void randomCheckboxClicked(GCheckbox source, GEvent event) { //_CODE_:randomCheckbox:515695:
  endSolve();
  selectedSolveAlgo = "Random Solver";
  algoDescription = randomDescription;
  rightWallCheckbox.setSelected(false);
  recursiveSolverCheckbox.setSelected(false);
  dijkstraSolverCheckbox.setSelected(false);
  resetGrid();
  message = "";
} //_CODE_:randomCheckbox:515695:

public void rightWallCheckboxClicked(GCheckbox source, GEvent event) { //_CODE_:rightWallCheckbox:230759:
  endSolve();
  selectedSolveAlgo = "Right Turn Solver";
  algoDescription = rightDescription;
  randomCheckbox.setSelected(false);
  //rightWallCheckbox.setSelected(false);
  recursiveSolverCheckbox.setSelected(false);
  dijkstraSolverCheckbox.setSelected(false);
  resetGrid();
  message = "";
} //_CODE_:rightWallCheckbox:230759:

public void recursiveSolverCheckboxClicked(GCheckbox source, GEvent event) { //_CODE_:recursiveSolverCheckbox:304100:
  endSolve();
  selectedSolveAlgo = "Recursive Solver";
  algoDescription = recursiveDescription;
  randomCheckbox.setSelected(false);
  rightWallCheckbox.setSelected(false);
  //recursiveSolverCheckbox.setSelected(false);
  dijkstraSolverCheckbox.setSelected(false);
  resetGrid();
  message = "";
} //_CODE_:recursiveSolverCheckbox:304100:

public void dijkstraSolverCheckboxClicked(GCheckbox source, GEvent event) { //_CODE_:dijkstraSolverCheckbox:932430:
  endSolve();
  selectedSolveAlgo = "Dijkstra's Solver";
  algoDescription = dijkstraDescription;
  randomCheckbox.setSelected(false);
  rightWallCheckbox.setSelected(false);
  recursiveSolverCheckbox.setSelected(false);
  resetGrid();
  message = "";
  //dijkstraSolverCheckbox.setSelected(false);
} //_CODE_:dijkstraSolverCheckbox:932430:

public void solveSpeedSliderDragged(GSlider source, GEvent event) { //_CODE_:solveSpeedSlider:776439:
  solveFrameSpeed = solveSpeedSlider.getValueI();
  frameRate(solveFrameSpeed);
  
} //_CODE_:solveSpeedSlider:776439:

public void solveButtonPressed(GButton source, GEvent event) { //_CODE_:solveButton:561348:
  beginSolve(selectedSolveAlgo);
} //_CODE_:solveButton:561348:

public void stopButtonClicked(GButton source, GEvent event) { //_CODE_:stopButton:604981:
  endSolve();
  resetGrid();
} //_CODE_:stopButton:604981:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  window1 = GWindow.getWindow(this, "GUI Controls", 0, 0, 400, 300, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw2");
  mazeFullnessSlider = new GSlider(window1, 238, 132, 120, 50, 10.0);
  mazeFullnessSlider.setShowValue(true);
  mazeFullnessSlider.setLimits(8, 1, 20);
  mazeFullnessSlider.setNbrTicks(11);
  mazeFullnessSlider.setShowTicks(true);
  mazeFullnessSlider.setNumberFormat(G4P.INTEGER, 0);
  mazeFullnessSlider.setOpaque(false);
  mazeFullnessSlider.addEventHandler(this, "mazeFullnessSliderDragged");
  mazeFullnessLabel = new GLabel(window1, 250, 173, 100, 20);
  mazeFullnessLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  mazeFullnessLabel.setText("Maze Fullness");
  mazeFullnessLabel.setOpaque(false);
  moveStartButton = new GButton(window1, 216, 224, 80, 40);
  moveStartButton.setText("Change Start Square");
  moveStartButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  moveStartButton.addEventHandler(this, "moveStartButtonClicked");
  moveEndButton = new GButton(window1, 307, 223, 80, 40);
  moveEndButton.setText("Change End Square");
  moveEndButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  moveEndButton.addEventHandler(this, "moveEndButtonClicked");
  showMazeGenerationCheckbox = new GCheckbox(window1, 253, 81, 130, 30);
  showMazeGenerationCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  showMazeGenerationCheckbox.setText("Show Maze Generation");
  showMazeGenerationCheckbox.setOpaque(false);
  showMazeGenerationCheckbox.addEventHandler(this, "showMazeGenerationChecked");
  generateMazeButton = new GButton(window1, 250, 21, 100, 40);
  generateMazeButton.setText("GENERATE NEW MAZE");
  generateMazeButton.addEventHandler(this, "generateMazeButtonClicked");
  randomCheckbox = new GCheckbox(window1, 40, 99, 120, 20);
  randomCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  randomCheckbox.setText("Random Solver");
  randomCheckbox.setOpaque(false);
  randomCheckbox.addEventHandler(this, "randomCheckboxClicked");
  randomCheckbox.setSelected(true);
  rightWallCheckbox = new GCheckbox(window1, 40, 120, 120, 20);
  rightWallCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  rightWallCheckbox.setText("Right Turn Solver");
  rightWallCheckbox.setOpaque(false);
  rightWallCheckbox.addEventHandler(this, "rightWallCheckboxClicked");
  recursiveSolverCheckbox = new GCheckbox(window1, 40, 141, 120, 20);
  recursiveSolverCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  recursiveSolverCheckbox.setText("Recursive Solver");
  recursiveSolverCheckbox.setOpaque(false);
  recursiveSolverCheckbox.addEventHandler(this, "recursiveSolverCheckboxClicked");
  dijkstraSolverCheckbox = new GCheckbox(window1, 40, 161, 120, 20);
  dijkstraSolverCheckbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  dijkstraSolverCheckbox.setText("Dijkstra's Solver");
  dijkstraSolverCheckbox.setOpaque(false);
  dijkstraSolverCheckbox.addEventHandler(this, "dijkstraSolverCheckboxClicked");
  AlgoChooserLabel = new GLabel(window1, 40, 78, 120, 20);
  AlgoChooserLabel.setText("Maze-Solving Algo:");
  AlgoChooserLabel.setOpaque(false);
  solveSpeedSlider = new GSlider(window1, 38, 204, 120, 50, 10.0);
  solveSpeedSlider.setShowLimits(true);
  solveSpeedSlider.setLimits(50, 5, 60);
  solveSpeedSlider.setNbrTicks(10);
  solveSpeedSlider.setStickToTicks(true);
  solveSpeedSlider.setShowTicks(true);
  solveSpeedSlider.setNumberFormat(G4P.INTEGER, 0);
  solveSpeedSlider.setOpaque(false);
  solveSpeedSlider.addEventHandler(this, "solveSpeedSliderDragged");
  solveSpeedLabel = new GLabel(window1, 59, 245, 80, 20);
  solveSpeedLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  solveSpeedLabel.setText("Solve-Speed");
  solveSpeedLabel.setOpaque(false);
  solveButton = new GButton(window1, 18, 19, 80, 40);
  solveButton.setText("SOLVE MAZE");
  solveButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  solveButton.addEventHandler(this, "solveButtonPressed");
  stopButton = new GButton(window1, 103, 19, 70, 40);
  stopButton.setText("STOP SOLVE");
  stopButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  stopButton.addEventHandler(this, "stopButtonClicked");
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow window1;
GSlider mazeFullnessSlider; 
GLabel mazeFullnessLabel; 
GButton moveStartButton; 
GButton moveEndButton; 
GCheckbox showMazeGenerationCheckbox; 
GButton generateMazeButton; 
GCheckbox randomCheckbox; 
GCheckbox rightWallCheckbox; 
GCheckbox recursiveSolverCheckbox; 
GCheckbox dijkstraSolverCheckbox; 
GLabel AlgoChooserLabel; 
GSlider solveSpeedSlider; 
GLabel solveSpeedLabel; 
GButton solveButton; 
GButton stopButton; 
