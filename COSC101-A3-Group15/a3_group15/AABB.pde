import java.lang.Iterable;
import java.util.Iterator;

/*
 * Class: AABB
 * Desc: Represents an Axis-Aligned Bounding Box.
 * Authors: Brodie Hicks
 * Comments updated: 10/5/18
 */
class AABB {
  //Position and dimension vectors.
  PVector position; //Represents top-left.
  PVector dimensions;
  
  /*
   * Function: AABB Constructor
   * Parameters:
   * - initDimensions - the dimensions of the AABB
   * - initPosition - the top-left corner position of the AABB.
   * Desc: Instantiates an AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  AABB(PVector initDimensions, PVector initPosition) {
    dimensions = initDimensions;
    position = initPosition;
  }
  
  /*
   * Function: topLeft
   * Parameters: None
   * Returns: PVector
   * Desc: Returns top-left corner of the AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector topLeft() {
    return position;
  }
  
  /*
   * Function: bottomRight
   * Parameters: None
   * Returns: PVector
   * Desc: Returns bottom-right corner of the AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector bottomRight() {
    return PVector.add(position,dimensions);
  }
  
  /*
   * Function: topRight
   * Parameters: None
   * Returns: PVector
   * Desc: Returns top-right corner of the AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector topRight() {
    return new PVector(position.x + dimensions.x, position.y);
  }
  
  /*
   * Function: bottomLeft
   * Parameters: None
   * Returns: PVector
   * Desc: Returns bottom-left corner of the AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector bottomLeft() {
    return new PVector(position.x, position.y + dimensions.y);
  }
  
  /*
   * Function: centre
   * Parameters: None
   * Returns: PVector
   * Desc: Returns the centre of the AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector centre() {
    return new PVector(
       position.x + dimensions.x/2
      ,position.y + dimensions.y/2
    );
  }
  
  /*
   * Function: containsAABB
   * Parameters: AABB other
   * Returns: boolean
   * Desc: Returns true if this AABB overlaps with the other AABB
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  boolean containsAABB(AABB other) {
    PVector thisMax = this.bottomRight();
    PVector otherMax = other.bottomRight();
    PVector thisMin = this.topLeft();
    PVector otherMin = other.topLeft();
    
    boolean collideX = thisMax.x > otherMin.x
                    && thisMin.x < otherMax.x;
    
    boolean collideY = thisMax.y > otherMin.y
                    && thisMin.y < otherMax.y;
                    
    return collideX && collideY;
  }
  
  /*
   * Function: containsPoint
   * Parameters: PVector point - point to test
   * Returns: boolean
   * Desc: Returns true if this AABB contains the point PVector.
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  boolean containsPoint(PVector point) {
    PVector max = bottomRight();
    PVector min = topLeft();
    
    return min.x <= point.x
        && max.x >= point.x
        && min.y <= point.y
        && max.y >= point.y;
  }
  
  /*
   * Function: containsAnyAABB
   * Parameters: others: Iterable collection of AABB's
   * Returns: boolean
   * Desc: Returns true if this AABB overlaps with any AABB in the collection.
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  boolean containsAnyAABB(Iterable<? extends AABB> others) {
    Iterator<? extends AABB> it = others.iterator();
    
    while (it.hasNext()) {
      AABB other = it.next();
      if (this.containsAABB(other)) {
        return true;
      }
    }
    return false;
  }
  
  /*
   * Function: minkowskiDifference
   * Parameters: AABB other - the AABB to test against.
   * Returns: AABB
   * Desc: Calculates the minkowski difference between two AABB's.
   *       This allows for efficient collision detection and allows 
   *       for swept AABB detection (if required).
   *       See: https://en.wikipedia.org/wiki/Minkowski_addition
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  AABB minkowskiDifference(AABB other) {
    PVector topLeft = PVector.sub(this.topLeft(), other.bottomRight());
    PVector newDimensions = PVector.add(this.dimensions, other.dimensions);
    
    return new AABB(newDimensions, topLeft);
  }
  
  /*
   * Function: closestBoundingPoint
   * Parameters: PVector insidePoint
   * Returns: AABB
   * Desc: Finds the point on the bounding edge of the AABB 
   *       closest to insidePoint.
   * Authors: Brodie Hicks
   * Comments updated: 10/5/18
   */
  PVector closestBoundingPoint(PVector insidePoint) {
    //For simplicity, consider the 4 edges of the AAB separately.
    
    PVector[] edges = {
      new PVector(topLeft().x, insidePoint.y), //left-side edge
      new PVector(topRight().x, insidePoint.y), //right-side edge
      new PVector(insidePoint.x, topLeft().y), //top edge
      new PVector(insidePoint.x, bottomLeft().y) //Bottom edge
    };
    
    PVector point = null;
    float pointDist = 0;
       
    for (PVector e : edges) {
      if (abs(PVector.dist(insidePoint, e)) < pointDist || point == null) {
        point = e;
        pointDist = abs(PVector.dist(insidePoint, e));
      }
    }
    
    return point;
  }
}
