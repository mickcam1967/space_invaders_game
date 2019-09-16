import java.util.HashSet;

/*
 * Class: World
 * Desc: Contains world info including objects, the current level and the score.
 * Authors: Brodie Hicks, Michael Campbell 
 * Comments updated: 4/5/18
 */
class World {
  ArrayList<Laser> laserObjects = new ArrayList<Laser>(); //On-screen lasers
  //Container for all "living" asteroids.
  ArrayList<Asteroid> asteroidObjects = new ArrayList<Asteroid>(); 
  
  Ship playerShip; //the player ship
  
  //Level related globals
  int score = 0; //The current score
  int currentLevel = 1; //The current level.

  //The current speed multipler. Increments with each level.
  float speedMultiplier = initialSpeedMultiplier; 

  //When the world was last instantiated (or reset).
  long creationTime; 
  
  //Collision responders. These can be swapped out at runtime.
  CollisionResponder asteroidCollider = new BounceCollisionResponder();
  CollisionResponder shipCollider = new KillPlayerCollisionResponder(this);
  CollisionResponder laserCollider = new DestroyCollisionResponder(this);
  
  //Level counter for level up message.
  boolean isLevelingUp = false;
  
  //Visual Assets
  PImage asteroidImage; //Used for all asteroids.
  
  //Sound Assets
  SoundFile shipSound;
  SoundFile asteroidSound;
  
  /*
   * Function: World
   * Parameters: 
   *  - PImage initShipImage - image for the ship
   *  - PImage initAsteroidImage - asteroid image.
   *  - SoundFile initShipSound - Ship sound played when destroyed.
   *  - SoundFile initLaserSound - Sound played when weapon fired.
   *  - SoundFile initAsteroidSound - Asteroid destruction sound.
   * Returns: N/A
   * Desc: Instantiates the World and calls reset()
   * Authors: Brodie Hicks
   * Comments updated: 4/5/18
   */
  World(
     PImage initShipImage
    ,PImage initAsteroidImage
    ,SoundFile initShipSound
    ,SoundFile initLaserSound
    ,SoundFile initAsteroidSound
  ) {
    asteroidImage = initAsteroidImage;
    shipSound = initShipSound;
    asteroidSound = initAsteroidSound;
    
    playerShip = new Ship(
       initShipImage
      ,initLaserSound
      ,this
      ,shipSize
      ,shipResetPosition
      ,shipResetVelocity
      ,shipResetRotation
      ,0
    );
    
    //Reload the world
    reset();
  }
  
  /*
   * Function: generateNewAsteroids
   * Parameters: asteroidCount - number of asteroids to add. 
   * Desc: Adds new asteroids to the level.
   * Returns: void
   * Authors: Brodie Hicks
   * Comments updated: 4/5/18
   */
  void generateNewAsteroids(int asteroidCount) {
    //Determine a reasonably wide AABB around the player ship. 
    // This is used to prevent asteroids from spawning too close to the 
    // player and gives them time to react.
    AABB shipBounds = new AABB(
       PVector.mult(playerShip.dimensions, 6) //Dimensions
      ,PVector.sub( //top-left position.
        playerShip.position
        ,PVector.mult(playerShip.dimensions, 2)
       )
    );
    
    //Now generate asteroidCount asteroids with a random position and velocity.
    for (int i = 0; i < asteroidCount; ++i) {
      Asteroid next = null;
      //Loop to guarantee the new asteroid does not collide with anything.
      // do..while loop guarantees next has a value before we call collidesAny.
      do {
          //Random resize of asteroid based on configuration
          float xSizeAdjust = random(
             1.0 - asteroidSizeVariance
            ,1.0 + asteroidSizeVariance
          );
          float ySizeAdjust = random(
             1.0 - asteroidSizeVariance
            ,1.0 + asteroidSizeVariance
          );

          PVector nextSize = new PVector(
             (int)(asteroidSize.x * xSizeAdjust)
            ,(int)(asteroidSize.y * ySizeAdjust)
          );
          
          //We align rotation to 90 deg. intervals 
          // as otherwise there's a significant performance impact...
          float startingRotation = floor(random(0,4)) * HALF_PI;
          
          //Random velocity (direction and magnitude)...
          float xVel = random(-1 * maxAsteroidVelocity, maxAsteroidVelocity);
          float yVel = random(-1 * maxAsteroidVelocity, maxAsteroidVelocity);
          
          //Finally - instantiate the asteroid.
          next = new Asteroid(
             this //World instance
            ,nextSize //Size
            ,new PVector( //Position
               random(screenDimensions.x)
              ,random(screenDimensions.y)
            )
            ,new PVector(xVel, yVel) //Velocity
            ,startingRotation //Inital rotaion
            ,PI/1024.0 //Fixed rotation speed - less performance impact.
          );
      } while (
              next.containsAnyAABB(asteroidObjects) 
           || next.containsAABB(shipBounds)
      );
      
      //Add to world asteroids
      asteroidObjects.add((Asteroid)next);
    }
  }
  
  /*
   * Function: manageAsteroids
   * Parameters: None. 
   * Returns: void
   * Desc: Ensures asteroidObjects is always the correct size.
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  void manageAsteroids() {
    //Score % levelAsteroidCount will return 
    //number of asteroids destroyed for this level
    //Hence remainingAsteroids will be how many asteroids are left. 
    int remainingAsteroids = levelAsteroidCount - (score % levelAsteroidCount);
    
    if (remainingAsteroids > asteroidObjects.size()
     && asteroidObjects.size() < screenAsteroidCount) {
      //Only add up to screenAsteroidCount asteroids at a time
      //e.g. prevent the game from getting too 'busy'.
      int maxAsteroidsToAdd = min(screenAsteroidCount, remainingAsteroids);
      int toAdd = maxAsteroidsToAdd - asteroidObjects.size();  
      generateNewAsteroids(toAdd);
    }
  }
  
  /*
   * Function: manageLasers
   * Parameters: None. 
   * Returns: void
   * Desc: Updates all lasers and removes any that fly off screen.
   * Authors: Brodie Hicks, Jesse F.
   * Comments updated: 20/5/18
   */
  void manageLasers() {
    for (int i = 0; i < laserObjects.size(); ++i) {
      Laser l = laserObjects.get(i);
      l.update();
      //Remove lasers that have moved off-screen.
      if (l.position.x > screenDimensions.x || l.position.x < 0
       || l.position.y > screenDimensions.y || l.position.y < 0) {
         laserObjects.remove(i);
       }
    }
  }
  
  /*
   * Function: reset
   * Parameters: None 
   * Desc: Resets the world to initial values.
   * Authors: Brodie Hicks, Michael Campbell
   * Comments updated: 14/5/18
   */
  void reset() {
    //Reset ship position and rotation to defaults
    playerShip.position = shipResetPosition;
    playerShip.velocity = shipResetVelocity;
    playerShip.acceleration = shipResetAcceleration;
    
    playerShip.rotation = shipResetRotation;
    playerShip.rotationVelocity = shipResetRotationVelocity;
    playerShip.rotationAcceleration = shipResetRotationAcceleration;
    
    //Reset objects on screen. Asteroid instantiation is handled by main loop.
    laserObjects.clear();
    asteroidObjects.clear();
  }
  
  /*
   * Function: respawn
   * Parameters: None 
   * Desc: Respawns the player and resets the world.
   * Authors: Brodie Hicks, Michael Campbell
   * Comments updated: 14/5/18
   */
  void respawn() {
    playerShip.lives = 3;
    score = 0;
    currentLevel = 1;
    speedMultiplier = initialSpeedMultiplier;
    playerShip.alive = true;
    creationTime = millis();
    
    reset();
  }
  
  /*
   * Function: increaseLevel
   * Parameters: None 
   * Desc: Increments the world level by 1 and updates the speed multiplier.
   * Authors: Brodie Hicks, Michael Campbell
   * Comments updated: 14/5/18
   */
  void increaseLevel() {
    speedMultiplier = speedMultiplier + levelSpeedMultiplierIncrease;
    currentLevel++;
    //Leave player in current position.
    //reset();
    isLevelingUp = false;
  }
  
  /*
   * Function: increaseScore
   * Parameters: None 
   * Desc: Increments the world score by 1 and triggers a level up, if required.
   * Authors: Brodie Hicks, Michael Campbell
   * Comments updated: 14/5/18
   */
  void increaseScore() {
    score++; //Increment score.
    //Increase level, if appropriate. The call to increaseLevel is handled
    //after the player presses enter.
    if (score > 0 && score % levelAsteroidCount == 0) {
      isLevelingUp = true;
      noLoop();
      redraw();          
    }
  }
  
  /*
   * Function: update
   * Parameters: None. 
   * Returns: void
   * Desc: Updates the world. Should be called once per frame.
   * Authors: Brodie Hicks, Michael Campbell.
   * Comments updated: 4/5/18
   */
  void update() {
    //First re-fill asteroids object.
    manageAsteroids();
    
    //We need to track which objects have collided this frame.
    HashSet<PhysicalObject> collided = new HashSet<PhysicalObject>();
    
    //Loop through asteroids.
    for (int i = 0; i < asteroidObjects.size(); ++i) {    
      Asteroid a = asteroidObjects.get(i);
      
      //Ship to asteroid collision
      if (shipCollider.collide(playerShip, a))
      {
        collided.add(playerShip);
        collided.add(a);
        
        shipSound.play();
        
        if (!playerShip.alive) {
          //Pause the game until the user presses enter.
          noLoop();
          redraw();
        }
        else {
          reset();
        }
      }
      
      //Asteroid to other asteroid collisions.
      for (int j = i+1; j < asteroidObjects.size(); ++j) {
        Asteroid b = asteroidObjects.get(j);
        
        if (asteroidCollider.collide(a, b)) {
          collided.add(a);
          collided.add(b);
        }
      }
      
      //Laser to asteroid collision.
      for (int j = 0; j < laserObjects.size(); ++j) {
        Laser l = laserObjects.get(j);
        if (laserCollider.collide(a, l)) {
          collided.add(a); //No need to add l as it is not referenced again.
          asteroidSound.play(); //play asteriod sound effect
          
          increaseScore();
          break; //Break the loop as the asteroid no longer exists.
        }
      }

      //Update the asteroid if it hasn't already moved.
      if (!collided.contains(a)) {
        a.update();
      }
    }
    
    //Update all lasers.
    manageLasers();
    
    //Finally - move the player.
    if (!collided.contains(playerShip)) {
      playerShip.update();
    }
  }
};
