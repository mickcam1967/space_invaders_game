/*
 * Class: DestroyCollisionResponder
 * Desc: Implements CollisionResponder by 
 *       removing asteroids and lasers when they collide.
 * Authors: Brodie Hicks.
 * Comments updated: 20/5/18
 */
class DestroyCollisionResponder implements CollisionResponder {
  World world;
  
  /*
   * Function: DestroyCollisionResponder
   * Parameters: initWorld: World Reference to use.
   * Returns: N/A
   * Desc: Instantiates the responder
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  DestroyCollisionResponder(World initWorld) {
    world = initWorld;
  }
  
  /*
   * Function: collide
   * Parameters:
   *          - first: First object to collide
   *          - second: Second object to collide
   * Returns: True on collision, false otherwise.
   * Desc: Tests for collision between two objects
   *       and removes them from the world.
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  boolean collide(PhysicalObject first, PhysicalObject second) {
    //As we don't need the offset for these collisions, we stick to simple AABB
    if (first.containsAABB(second)) {
      if (first instanceof Asteroid) {
        world.asteroidObjects.remove(first);
      }
      else if (first instanceof Laser) {
        world.laserObjects.remove(first);
      }
      
      if (second instanceof Asteroid) {
        world.asteroidObjects.remove(second);
      }
      else if (second instanceof Laser) {
        world.laserObjects.remove(second);
      }
      return true;
    }
    //Return a non-event when no overlap is found.
    return false;
  }
}
