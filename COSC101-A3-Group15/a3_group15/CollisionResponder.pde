/*
 * Class: CollisionResponder
 * Desc: Interface for detecting and responding to a collision event
 * Authors: Brodie Hicks.
 * Comments updated: 20/5/18
 */
interface CollisionResponder {
  /*
   * Function: collide
   * Parameters:
   *          - first: First object to collide
   *          - second: Second object to collide
   * Returns: Should return True on collision, false otherwise.
   * Desc: Abstract method to detect and respond to a collision. 
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  boolean collide(PhysicalObject first, PhysicalObject second);
}
