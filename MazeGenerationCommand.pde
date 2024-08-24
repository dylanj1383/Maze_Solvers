class MazeGenerationCommand{
  PVector visitedSquare, removedHorizontal, removedVertical, addedHorizontal, addedVertical;
  
  MazeGenerationCommand(PVector visitedSquare, PVector removedHorizontal, PVector removedVertical){
    this.visitedSquare = visitedSquare;
    this.removedHorizontal = removedHorizontal;
    this.removedVertical = removedVertical;
    this.addedHorizontal = null;
    this.addedVertical = null;
  }
  
  MazeGenerationCommand(PVector addedHorizontal, PVector addedVertical){
    this.visitedSquare = null;
    this.removedHorizontal = null;
    this.removedVertical = null;
    this.addedHorizontal = addedHorizontal;
    this.addedVertical = addedVertical;
  }
}
