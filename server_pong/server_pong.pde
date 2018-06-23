import processing.net.*;

Server server;
boolean leftSideIsTaken = false;
boolean rightSideIsTaken = false;
int ballX = 125;
int ballY = 125;
int leftPaddleY;
int rightPaddleY;
int leftPoints;
int rightPoints;

void setup() {
 size(500, 500);
 server = new Server(this, 5204);
}

// Protocol: {type, length, [information]}
/**
Type: 
0 = ball location ([0, 2, x, y]), 
1 = left paddle ([1, 1, y]),
2 = right paddle ([2, 1, y]),
3 = points, 
4 = assigning to side ([4, 1, 0] is left, [4, 1, 1] is right, [4, 1, 2] is fully occupied game)
~ Receiving types: ~
5 = set, used for left and right paddle ([5, {0L/1R}, {0UP/1DOWN}])
**/

void draw() {
  // SENDING DATA
  server.write(new byte[]{0, 2, (byte)ballX, (byte)ballY});
  server.write(new byte[]{1, 1, (byte)leftPaddleY});
}

void serverEvent(Server server, Client someClient) {
  println("We have a new client: " + someClient.ip() + " on server " + server);
  if(leftSideIsTaken && rightSideIsTaken) {
    server.write(new byte[]{4, 1, 2});
  }
  else if(leftSideIsTaken) {
    server.write(new byte[]{4, 1, 1});
  }
  else if(!leftSideIsTaken) {
    server.write(new byte[]{4, 1, 0}); 
  }
}
