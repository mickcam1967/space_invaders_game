/*
 * Class: KillPlayerCollisionResponder
 * Desc: Implements Collision Responder by simple AABB collision detection.
 *       On collision, decrements player lives.
 * Authors: Brodie Hicks, Michael Campbell
 * Comments updated: 20/5/18
 */
class KillPlayerCollisionResponder implements CollisionResponder {
  World world;
  
  /*
   * Function: KillPlayerCollisionResponder
   * Parameters: initWorld: World Reference to use.
   * Returns: N/A
   * Desc: Instantiates the responder
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  KillPlayerCollisionResponder(World initWorld) {
    world = initWorld;
  }
  
  /*
   * Function: collide
   * Parameters:
   *          - first: First object to collide
   *          - second: Second object to collide
   * Returns: True on collision, false otherwise.
   * Desc: Tests for collision between two objects.
   *       On collision, decrements player lives and kills them if required.
   * Authors: Brodie Hicks
   * Comments updated: 20/5/18
   */
  boolean collide(PhysicalObject first, PhysicalObject second) {
    //As we don't need the offset for these collisions, we stick to simple AABB
    //instead of minkowski.
    if (first.containsAABB(second)) {
      //Decrement lives, and either kill the player or reset.
      world.playerShip.lives--;
      
      if (world.playerShip.lives <= 0) {
        //Game over!
        world.playerShip.alive = false;
      }
      return true;
    }
    return false;
  }
}
