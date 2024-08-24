void mousePressed(){
  if (maze.isPointOnGrid(new PVector(mouseX, mouseY))){
    PVector p = maze.getSquareIndexes(mouseX, mouseY);
    
    if(mouseMode.equals("Changing End Square")){
      maze.setEndSquareTo(int(p.x), int(p.y));
      resetGrid();
      mouseMode = "None";
    }
    else if (mouseMode.equals("Changing Start Square")){
      maze.setStartSquareTo(int(p.x), int(p.y));
      resetGrid();
      mouseMode = "None";
    }
  }
}
