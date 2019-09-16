import java.util.UUID;

/*
 * Class: PhysicalObject
 * Desc: Represents an AABB with a velocity and rotation.
 * Authors: Brodie Hicks
 * Comments updated: 4/5/18
 */
class PhysicalObject extends AABB{
  PVector velocity; //Speed and direction
  PVector acceleration; //object acceleration (change in velocity)
  
  //Rotation related attributes. Note the number's sign represents direction.
  float rotation; //Rotation angle in radians.
  float rotationVelocity; //Change in rotation angle.
  float rotationAcceleration; //Change in rotational velocity
  
  UUID id; //UUID to uniquely identify this object.
  
  //Reference to the world to retrieve speedMultiplier.
  World world;
  
  /*
   * Function: PhysicalObject
   * Parameters: 
   *          - initWorld: World Reference
   *          - initDimensions: Dimensions
   *          - initPosition: Location
   *          - initVelocity: Speed/Direction
   *          - initAcceleration: Speed/Direction change in velocity.
   *          - initRotation: Rotation in radians.
   *          - initRotationVelocity: Change in rotation in radians per frame.
   *          - initRotationAcceleration: Change in rotation velocity.
   * Returns: N/A
   * Desc: Instantiates a new PhysicalObject.
   * Authors: Brodie Hicks
   * Comments updated: 4/5/18
   */
  PhysicalObject(
     World initWorld
    ,PVector initDimensions
    ,PVector initPosition
    ,PVector initVelocity
    ,PVector initAcceleration
    ,float initRotation
    ,float initRotationVelocity
    ,float initRotationAcceleration
  ) {
    super(initDimensions, initPosition);
    
    world = initWorld;
    velocity = initVelocity;
    acceleration = initAcceleration;
    
    rotation = initRotation;
    rotationVelocity = initRotationVelocity;
    rotationAcceleration = initRotationAcceleration;
    
    //Assign a new random UUID to the object.
    id = UUID.randomUUID();
  }
  
  /*
   * Function: hashCode
   * Parameters: None 
   * Returns: HashCode of id
   * Desc: Used for storing PhysicalObject in HashSet. 
   *       Uniqueness provided by the random UUID.
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  int hashCode() {
    return id.hashCode();
  }
  
  /*
   * Function: display
   * Parameters: None 
   * Returns: None
   * Desc: Draws the object on screen.
   *       The default behaviour is to draw the bounding box and velocity only.
   * Authors: Brodie Hicks
   * Comments updated: 4/5/18
   */
  void display() {
    //Only show if enabled (via TAB key).
    if (showBoundingBoxes) {
      PVector rectStart = topLeft();
      //We extend velocity line by 10 frames to make it more noticable.
      PVector velEnd = PVector.add(centre(), PVector.mult(velocity, 10.0));
      
      stroke(255, 0, 0);
      noFill();
      rectMode(CORNER);
      rect(rectStart.x, rectStart.y, dimensions.x, dimensions.y);
      stroke(0, 255, 0);
      line(centre().x, centre().y, velEnd.x, velEnd.y);
    }
  }
  
  /*
   * Function: update
   * Parameters: None 
   * Returns: None
   * Desc: Alters position and velocity based on current status.
   * Authors: Brodie Hicks
   * Comments updated: 4/5/18
   */
  void update() {
    //Basic motion - note no collision detection
    
    //Second order derivatives first - e.g. apply acceleration.
    velocity = PVector.add(
       velocity
      ,PVector.mult(acceleration, world.speedMultiplier)
    );
    rotationVelocity += rotationAcceleration * world.speedMultiplier;
    
    //First order - apply velocity
    position = PVector.add(
       position
      ,PVector.mult(velocity, world.speedMultiplier)
    );
    rotation += rotationVelocity * world.speedMultiplier;
    
    //Perform screen wrapping.
    if (position.x > screenDimensions.x) {
      position.x = 0;
    }
    if (position.x < 0) {
      position.x = screenDimensions.x;
    }
    if (position.y > screenDimensions.y) {
      position.y = 0;
    }
    if (position.y < 0) {
      position.y = screenDimensions.y;
    }
  }
};
