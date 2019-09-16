/*
 * Class: Ship
 * Desc: Represents the player ship.
 * Authors: Brodie Hicks, Jesse Fitzgerald, Michael Campbell
 * Comments updated: 10/5/18
 */
class Ship extends PhysicalObject {
  PImage shipImage; //Local copy of ship image.
  SoundFile laserSound; //Copy of firing sound.
  
  int lives = 3; //Remaining player lives
  
  boolean alive = true; //Is the player alive?
  boolean firing = false; //Is the ship firing?
  
  float engineSpeed = 0.25; //engineSpeed to modify velocity.
  
  /*
   * Function: Ship
   * Parameters:
   *           - initShipImage: ship image
   *           - initLaserSound: Weapon firing sound
   *           - initWorld: World Reference
   *           - initDimensions: Ship dimensions
   *           - initPostion: Initial Location
   *           - initVelocity: speed/magnitude
   *           - initRotation: Initial Rotation
   *           - initRotationDelta: Rotational Velocity.
   * Returns: None
   * Desc: Rotates the ship to the right.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  Ship(
     PImage initShipImage
    ,SoundFile initLaserSound
    ,World initWorld
    ,PVector initDimensions
    ,PVector initPosition
    ,PVector initVelocity
    ,float initRotation
    ,float initRotationDelta
  ) {
    super(
       initWorld
      ,initDimensions
      ,initPosition
      ,initVelocity
      ,new PVector(0,0)
      ,initRotation
      ,initRotationDelta
      ,0
    );

    shipImage = initShipImage;
    shipImage.resize((int)dimensions.x, (int)dimensions.y);
    
    laserSound = initLaserSound;
  }
  
  /*
   * Function: display
   * Parameters: None
   * Returns: None
   * Desc: Draws the ship.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void display() {
    pushMatrix();
    translate(centre().x, centre().y);
    rotate(rotation);
    image(this.shipImage, -dimensions.x/2, -dimensions.y/2);
    popMatrix();
    
    super.display(); //Draw collision info, if enabled.
  }
  
  /*
   * Function: fire
   * Parameters: None
   * Returns: None
   * Desc: Fires the ship weapons.
   * Authors: Jesse F.
   * Comments updated: 20/5/18
   */
  void fire() {
    firing = true;
    world.laserObjects.add(new Laser(world, laserSize, this));
    laserSound.play();
  }
  
  /*
   * Function: rotateRight
   * Parameters: None
   * Returns: None
   * Desc: Rotates the ship to the right.
   * Authors: Brodie Hicks.
   * Comments updated: 19/5/18
   */
  void enforceRotationBounds() {
    //Helper to rotate bounding box when ship at appropriate rotation
    while (rotation > TWO_PI) {
      rotation = rotation - TWO_PI;
    }
    while (rotation < 0) {
      rotation = rotation + TWO_PI;
    }
  }
  
  /*
   * Function: moveForward
   * Parameters: None
   * Returns: None
   * Desc: Move forwards.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void moveForward() {
    velocity.add(new PVector(
       cos(rotation + radians(270)) * engineSpeed
      ,sin(rotation + radians(270)) * engineSpeed
    ));
  }
  
  /*
   * Function: moveBack
   * Parameters: None
   * Returns: None
   * Desc: Move backwards.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void moveBack() {
    velocity.sub(new PVector(
       cos(rotation + radians(270)) * engineSpeed
      ,sin(rotation + radians(270)) * engineSpeed
    ));
  }
  
  /*
   * Function: rotateLeft
   * Parameters: None
   * Returns: None
   * Desc: Rotates the ship to the left.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void rotateLeft() {
    rotationVelocity -= 0.025;
    enforceRotationBounds();
  }
  
  /*
   * Function: rotateRight
   * Parameters: None
   * Returns: None
   * Desc: Rotates the ship to the right.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void rotateRight() {
    rotationVelocity += 0.025;
    enforceRotationBounds();
  }
   
  /*
   * Function: update
   * Parameters: None
   * Returns: None
   * Desc: Applies inertia and moves the ship.
   * Authors: Brodie Hicks, Michael Campbell, Jesse F.
   * Comments updated: 19/5/18
   */
  void update() {
    //Inertia - slow it up
    acceleration = acceleration.mult(0.95);
    rotationAcceleration = rotationAcceleration * 0.75;    
    velocity = velocity.mult(0.95);
    rotationVelocity = rotationVelocity * 0.75;
    
    //Let PhysicalObject update() deal with the rest.
    super.update();
  }  
}
