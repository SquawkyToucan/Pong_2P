import processing.net.*;

Client client;
boolean isLeftSide = false;
boolean isRightSide = false;
int dataIn;
// A D D V A R I A B L E S F R O M T H E S E R V E R S O I T W O R K S A N D D O E S N T F L I C K E R Y O U I D I O T

void setup() {
  size(500, 500);
  client = new Client(this, "127.0.0.1", 5204);
  noStroke();
}

void draw() {
  background(0, 136, 102);
  // Getting stuff from the server
  if(client.available() > 0) {
     dataIn = client.read();
     if(dataIn == 0) {
       // ball location
       int[] ballLocation = new int[2];
       dataIn = client.read(); // clearing out size
       ballLocation[0] = client.read();
       ballLocation[1] = client.read();
       fill(255, 255, 255);
       rect(ballLocation[0] * 2, ballLocation[1] * 2, 10, 10);
     }
     else if(dataIn == 1) {
       // the x position for the left paddle is 10, it is 10 wide and 50 long
       dataIn = client.read(); // clearing out size
       rect(10, client.read(), 10, 50);
     }
     else if(dataIn == 2) {
       // the x position for the right paddle is 480, it is 10 wide and 50 long
     }
     else if(dataIn == 3) {
       
     }
     else if(dataIn == 4) {
       // assigning to side
       dataIn = client.read(); // waste the 1 because we don't need it
       dataIn = client.read(); // now at the last one
       if(dataIn == 0) {
         // on the left side
         System.out.println("You're playing on the left side!");
         isLeftSide = true;
       }
       else if(dataIn == 1) {
         // on the right side
         System.out.println("You're playing on the right side!");
         isRightSide = true;
       }
       else {
         if(isLeftSide || isRightSide) {
           // won't lose access because they're already playing
           System.out.println("Continue playing, someone tried to join the game.");
         }
         else {
           System.out.println("Sorry, but the game you're trying to join is full right now. Please try again later."); 
         }
       }
     }
     else {
       System.err.println("Pong couldn't recognize the data type!"); 
     }
  }
}
