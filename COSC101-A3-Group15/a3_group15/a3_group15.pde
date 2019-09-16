/*
 * File: a3_group15.pde
 * Group: Michael Campbell, Jesse Fitsgerald, Brodie Hicks, Group Number 15.
 * Date: 21/05/2018
 * Course: COSC101 - Software Development Studio 1
 * File desc: Performs set up on the environment and manages player inputs.
 * Usage: Requires sound library to be installed. 
 *        See README.md for further details (open with any text editor).
 */

import java.util.Hashtable;
import processing.sound.*;

//Represents the current world instance.
World gameWorld;

//To catch movement controls. Simpler than managing a long list of booleans...
Hashtable<Integer, Boolean> codedKeyState = new Hashtable<Integer, Boolean>();

/*
 * Function: setup
 * Parameters: None
 * Returns: None
 * Desc: Sets up the environment with default values.
 * Authors: Brodie Hicks, Michael Campbell, Jesse F.
 * Comments updated: 20/5/18
 */
void setup() {
  size(800, 800);
  frameRate(60);
  
  background(0);
  //shipCoord = new PVector(350, 400);
  //direction = new PVector(0, 0);
  
  //Configuring the sound effects
  SoundFile shipSound = new SoundFile(this, "ship_explode.mp3");
  SoundFile laserSound = new SoundFile(this, "shot.mp3");
  SoundFile asteroidSound = new SoundFile(this, "asteroid_explode.mp3");

  //Initialise images
  PImage shipImage = loadImage("alienspaceship.png");
  shipImage.resize((int)shipSize.x, (int)shipSize.y);
     
  PImage asteroidImage = loadImage("asteroid.png");
  asteroidImage.resize((int)asteroidSize.x, (int)asteroidSize.y);
  
  //Finally, instantiate and reset the world.
  gameWorld = new World(
     shipImage
    ,asteroidImage
    ,shipSound
    ,laserSound
    ,asteroidSound
  );
  gameWorld.reset();
}

/*
 * Function: showGameOver
 * Parameters: None
 * Returns: None
 * Desc: Displays the game over message on-screen.
 * Authors: Brodie Hicks, Michael Campbell.
 * Comments updated: 20/5/18
 */
void showGameOver() {
  fill(0 , 0, 0);
  rectMode(CENTER);
  stroke(255, 0, 0);
  rect(screenDimensions.x/2, screenDimensions.y/2, 600, 400, 14);
  
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(55);
  text("Game Over!", screenDimensions.x/2, screenDimensions.y/2 - 140);
  textSize(40);
  text(
     "Try again (Press Enter)?"
    ,screenDimensions.x/2
    ,screenDimensions.y/2 + 140
  );
  textSize(30);
  String s = String.format(
     "Your score is %d\nYour level is %d"
    ,gameWorld.score
    ,gameWorld.currentLevel 
  );
  text(s, screenDimensions.x/2, screenDimensions.y/2);
  //Reset rect mode for next draw.
  rectMode(CORNER);
}

/*
 * Function: showLevelUp
 * Parameters: None
 * Returns: None
 * Desc: Shows the level up message on-screen.
 * Authors: Brodie Hicks
 * Comments updated: 20/5/18
 */
void showLevelUp() {
  fill(0 , 0, 0);
  rectMode(CENTER);
  stroke(0, 155, 0);
  rect(screenDimensions.x/2, screenDimensions.y/2, 400, 100, 14);
  
  fill(0, 155, 0);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("Next Level (Press Enter)!", screenDimensions.x/2, screenDimensions.y/2); 
}

/*
 * Function: showScoreBoard
 * Parameters: None
 * Returns: None
 * Desc: Displays the scoreboard in the top-left corner.
 * Authors: Michael Campbell
 * Comments updated: 20/5/18
 */
void showScoreBoard() {
  stroke(0, 155, 0);
  strokeWeight(4);
  fill(0, 0);
  rectMode(CORNER);
  rect(0, 0, 230, 215, 14, 14, 14, 14);

  fill(0, 155, 0);
  textSize(24);
  textAlign(LEFT, BASELINE);
  text("Score : " + gameWorld.score, 40, 40);
  text("Lives : " + gameWorld.playerShip.lives, 40, 75);
  text("Level : " + gameWorld.currentLevel, 40, 110);
  //Round speed to 2 decimal places
  float speedRounded = ((int)(gameWorld.speedMultiplier * 10.00) / 10.00);
  text("Speed : " + speedRounded + "x", 40, 145);
  //Similar with time
  float currentSeconds = (millis() - gameWorld.creationTime)/1000.0; 
  text("Time : " + ((int)(currentSeconds * 10.0) / 10.0) + "s", 40, 180);
}

/*
 * Function: draw
 * Parameters: None
 * Returns: None
 * Desc: Called each frame - performs:
 *      - Keyboard command responses
 *      - Collision detection and response
 *      - Rendering
 * Authors: Brodie Hicks, Michael Campbell, Jesse F.
 * Comments updated: 20/5/18
 */ 
void draw() { 
  //First enable turbo if shift is held down
  if (codedKeyState.getOrDefault(SHIFT, false)) {
    gameWorld.playerShip.engineSpeed = 1.0;
  }
  else {
    //Set to default speed.
    gameWorld.playerShip.engineSpeed = 0.25;
  }
  
  //Enact movement controls...
  if (codedKeyState.getOrDefault(UP, false)) {
    gameWorld.playerShip.moveForward();  
  }
  if (codedKeyState.getOrDefault(DOWN, false)) {
    gameWorld.playerShip.moveBack();
  }
  if (codedKeyState.getOrDefault(RIGHT, false)) {
    gameWorld.playerShip.rotateRight();
  }
  if (codedKeyState.getOrDefault(LEFT, false)) {
    gameWorld.playerShip.rotateLeft();
  }
  
  //Update positions, velocities, collisions etc.
  gameWorld.update();
  
  //Start drawing to screen.
  background(0);
  
  //Draw all lasers first
  for (int i = 0; i < gameWorld.laserObjects.size(); ++i) {
    gameWorld.laserObjects.get(i).display();
  }
  //Now asteroids
  for (int i = 0; i < gameWorld.asteroidObjects.size(); ++i) {
    gameWorld.asteroidObjects.get(i).display();
  }
  //Now the ship
  gameWorld.playerShip.display();
  
  //draw score board
  showScoreBoard();

  //Overlay leveling up message
  if (gameWorld.isLevelingUp) {
    showLevelUp();
  }
  //Overlay game over message, if required.
  if (!gameWorld.playerShip.alive) {
    showGameOver();
  }
}

/*
 * Function: keyPressed
 * Parameters: None
 * Returns: None
 * Desc: Invoked for every key press, and:
 *      - Stores key code in codedKeyState for processing.
 *      - Fires the ship weapon.
 *      - Allows for respawn on death
 *      - Allows for progression to next level.
 * Authors: Brodie Hicks, Michael Campbell, Jesse F.
 * Comments updated: 20/5/18
 */
void keyPressed() {
    if (key == CODED) {
      codedKeyState.put(keyCode, true);
    }
    else {
      if (key == ' ' && gameWorld.playerShip.firing == false
       && !gameWorld.isLevelingUp && gameWorld.playerShip.alive) {
        gameWorld.playerShip.fire();
      }
      //Allow for game reset when not alive
      if (key == ENTER || key == RETURN) {
        if (!gameWorld.playerShip.alive) {       
          gameWorld.respawn();
        }
        if (gameWorld.isLevelingUp) {
          gameWorld.increaseLevel();
        }
        loop();      
      }
  }
}

/*
 * Function: keyReleased
 * Parameters: None
 * Returns: None
 * Desc: Invoked for every key release, and:
 *      - Stores key code in codedKeyState for processing.
 *      - Stops firing the ship weapon when released.
 *      - Toggles display of bounding boxes.
 * Authors: Brodie Hicks, Michael Campbell, Jesse F.
 * Comments updated: 20/5/18
 */
void keyReleased() {
  if (key == CODED) {
    codedKeyState.put(keyCode, false);
  }
  else {
    if (key == ' ' && gameWorld.playerShip.firing == true) {
      gameWorld.playerShip.firing = false;
    }
    if (key == TAB) {
      showBoundingBoxes = !showBoundingBoxes;
    }
  }
}
