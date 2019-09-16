/*
 * Class: Laser
 * Desc: Represents a ship laser. Extends PhysicalObject
 * Authors: Brodie Hicks, Jesse Fitzgerald.
 * Comments updated: 4/5/18
 */
class Laser extends PhysicalObject {
  PhysicalObject parent; //Parent Object (e.g. the ship)
  
  /*
   * Function: Laser
   * Parameters: 
   *            - initWorld: Reference to the world
   *            - initDimensions: Size of the laser.
   *            - initParent: Parent ship spawning the laser.
   * Returns: N/A
   * Desc: Instantiates a new laser
   * Authors: Brodie Hicks, Jesse Fitzgerald.
   * Comments updated: 4/5/18
   */
  Laser(World initWorld, PVector initDimensions, PhysicalObject initParent) {
    super(
       initWorld //World Reference
      ,initDimensions //Laser size
      ,PVector.add( //Laser position
         //First centre the laser on the ship
         PVector.add(initParent.centre(), PVector.mult(initDimensions, -0.5))
         //Then move to top-middle of parent and rotate with ship rotation.
        ,(new PVector(
           0
          ,-1 * initParent.dimensions.y/2
         )).rotate(initParent.rotation)
      )
      ,PVector.add( //Velocity
        //Take the parent ship velocity
        initParent.velocity
        //And add a velocity relative to the parent ship rotation.
        ,PVector.mult(
           new PVector(cos(initParent.rotation - HALF_PI)
          ,sin(initParent.rotation - HALF_PI)), 4 * initWorld.speedMultiplier
        )
      )
      ,new PVector(0, 0) //No Acceleration
      ,0 //No rotation
      ,0 //No rotation velocity
      ,0 //No rotation acceleration,
    );
    parent = initParent;
  }

  /*
   * Function: display
   * Parameters: None.
   * Returns: None.
   * Desc: Displays a laser on-screen.
   * Authors: Brodie Hicks, Jesse Fitzgerald.
   * Comments updated: 4/5/18
   */
  void display() {
    pushMatrix();
    translate(centre().x, centre().y);
    stroke(255, 0, 0);
    fill(0, 255, 0);
    rotate(rotation);
    ellipse(0, 0, dimensions.x, dimensions.y);
    popMatrix();
    
    super.display(); //Draw collision info, if enabled.
  }

  /*
   * Function: update
   * Parameters: None.
   * Returns: None.
   * Desc: Moves a laser. We override PhysicalObject update() 
   *       to remove screen wrapping.
   * Authors: Brodie Hicks, Jesse Fitzgerald.
   * Comments updated: 4/5/18
   */
  void update() {
    //Second order derivatives first - e.g. apply acceleration.
    velocity = PVector.add(
       velocity
      ,PVector.mult(acceleration, world.speedMultiplier)
    );
    rotationVelocity = rotationAcceleration * world.speedMultiplier;

    //First order - apply velocity
    position = PVector.add(
       position
      ,PVector.mult(velocity, world.speedMultiplier)
    );
    rotation = rotationVelocity * world.speedMultiplier;
  }
}
