/*
 * Class: Asteroid
 * Desc: Represents an asteroid. Extends PhysicalObject
 * Authors: Brodie Hicks.
 * Comments updated: 10/5/18
 */
class Asteroid extends PhysicalObject {
  //No longer used - local copies of the image lead to performance issues...
  //PImage asteroidImage;

  /*
   * Function: Asteorid
   * Parameters:
               - initWorld: World Reference
               - initDimensions: Dimensions
               - initPosition: Position
               - initVelocity: Velocity
               - initRotation: Rotation
               - initRotationDelta: RotationDelta.
   * Desc: Instantiates an asteroid.
   * Authors: Brodie Hicks.
   * Comments updated: 10/5/18
   */
  Asteroid(
     World initWorld
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
      ,initRotationDelta, 0
    );
    
    //No longer used due to performance issues.
    //asteroidImage = initAsteroidImage;
    //asteroidImage.resize((int)dimensions.x, (int)dimensions.y);
  }

  /*
   * Function: Display
   * Parameters: None
   * Desc: Displays an asteroid.
   * Authors: Brodie Hicks.
   * Comments updated: 10/5/18
   */
  void display() {   
    pushMatrix();
    //Position reflects top left corner of the bounding box;
    //hence center the image to match.
    translate(centre().x, centre().y);
    //Now rotate.
    rotate(rotation);
    image(
       world.asteroidImage
      ,-dimensions.x/2
      ,-dimensions.y/2
      ,dimensions.x
      ,dimensions.y
    );
    popMatrix();
    
    super.display(); //Draw collision info, if enabled.
  }
};
