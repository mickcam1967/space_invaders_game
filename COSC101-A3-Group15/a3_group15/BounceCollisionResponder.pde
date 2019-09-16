/*
 * Class: BounceCollisionResponder
 * Desc: Implements a collision responder to bounce (reflect) 
 *       objects off of each other.
 * Authors: Brodie Hicks.
 * Comments updated: 20/5/18
 */
class BounceCollisionResponder implements CollisionResponder {
  //Origin vector for collision detection
  PVector origin = new PVector(0, 0, 0);
  
  /*
   * Function: collide
   * Parameters:
   *          - first: First object to collide
   *          - second: Second object to collide
   * Returns: True on collision, false otherwise.
   * Desc: Tests for collision between two objects and bounces them if so.
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  boolean collide(PhysicalObject first, PhysicalObject second) {
    //Minkowski difference reflects other around the origin 
    //and returns an AABB that bounds all points in the reflection.
    AABB mdiff = first.minkowskiDifference(second);

    //E.g., if the objects share any points then origin (0,0) 
    // will be in mdiff - use this to test for collision.
    if (mdiff.containsPoint(origin)) {
      //We do this by determining the orthogonal point closest to the origin 
      //in the minkowski difference AABB. This works the closest point will 
      //always be axis-aligned in our simple universe.
      PVector offset = mdiff.closestBoundingPoint(origin);
      
      //Move first object back by the offset
      //We multiple 1.01 to help adjust for 
      //rounding errors on floats (likely no longer necessary).
      first.position = PVector.sub(first.position, PVector.mult(offset, 1.01));
        
      //Also adjust velocity.
      //We could determine a normal vector from the relative velocity 
      //and reflect around that however, given all objects have the same mass,
      //we simply swap velocities instead.
      PVector temp = first.velocity;
      first.velocity = second.velocity;
      second.velocity = temp;
      
      return true;
    }
    return false;
  }
}
