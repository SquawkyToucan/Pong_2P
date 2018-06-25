import processing.net.*;

Client client;
boolean isLeftSide = false;
boolean isRightSide = false;
int dataIn;
int ballX;
int ballY;
int leftPaddleY;
int rightPaddleY;
int leftPoints;
int rightPoints;

void setup() {
  size(500, 500);
  client = new Client(this, "127.0.0.1", 5204);
  noStroke();
}

void draw() {
  background(0, 136, 102);
  // Actually drawing the stuff
  // Drawing the ball
  fill(255, 255, 255);
  rect(ballX, ballY, 10, 10);
  // Left paddle
  rect(10, leftPaddleY, 10, 50);
  // Right paddle
  rect(480, rightPaddleY, 10, 50);
  // Getting stuff from the server
  if(client.available() > 0) {
     dataIn = client.read();
     if(dataIn == 0) {
       // ball location
       int[] ballLocation = new int[2];
       dataIn = client.read(); // clearing out size
       ballLocation[0] = client.read();
       ballLocation[1] = client.read();
       ballX = ballLocation[0] * 2;
       ballY = ballLocation[1] * 2;
     }
     else if(dataIn == 1) {
       // the x position for the left paddle is 10, it is 10 wide and 50 long
       dataIn = client.read(); // clearing out size
       leftPaddleY = client.read();
     }
     else if(dataIn == 2) {
       // the x position for the right paddle is 480, it is 10 wide and 50 long
       dataIn = client.read();
       rightPaddleY = client.read();
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
