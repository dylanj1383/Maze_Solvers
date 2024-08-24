//fills all the cells in a 2d array of ints with 1s
void fillCells(int[][] A){
  for (int i = 0; i < A.length; i++){
    for (int j = 0; j < A[0].length; j++){
      A[i][j] = 1;
    }
  }
}

//fills all the cells in a 2d array with 0s
void emptyCells(int[][] A){
  for (int i = 0; i < A.length; i++){
    for (int j = 0; j < A[0].length; j++){
      A[i][j] = 0;
    }
  }
}

//checks if a given string is in an string array
boolean stringInArray(String s, String[] all){
  for (String test : all){
    if (test.equals(s)){
      return true;
    }
  }
  return false;
}

//prints a pvector (for debugging purposes)
void printPVector(PVector p){
  println(getVectorString(p));
}

//gets a pvector as a string (for debugging purposes)
String getVectorString(PVector p){
  return "(" + p.x + ", " + p.y + ")";
}
