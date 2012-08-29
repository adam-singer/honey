
/**
 * Defines a vector with 2 components.
 */
class Vector2 implements Hashable {
  
  /** Ges or sets the x-component of the vector. */
  num x;
  
  /** Gets or sets the y-component of the vector. */
  num y;
  
  /** Calculates the length of the vector. */
  num get length() => sqrt(x * x + y * y);
  
  /** Calculates the length of the vector squared. */
  num get lengthSquared() => (x * x + y * y);
  
  Vector2(this.x, this.y);
  
  factory Vector2.unitX() => new Vector2(1.0, 0.0);  
  factory Vector2.unitY() => new Vector2(0.0, 1.0);
  
  factory Vector2.normalOf(Vector2 other) {    
    num len = other.length;
    assert(len > 0);    
    return new Vector2(other.x/len, other.y/len);
  }
  
  bool operator ==(Object other) {
    if(this === other) return true;
    if(other is! Vector2) return false; 
    return x == other.x && y == other.y;
  }
  
  int hashCode() => x.hashCode() ^ y.hashCode();
  
  /** Calculates the distance between [this] vector and the given [other]. */
  num distance(Vector2 other)
  {
    final dx = x - other.x;
    final dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
  
  /**
   * Performs a linear interpolation between [this] [Vector2] and the [other].
   * The given [amount] must be a value between [:0:] and [:1:] that indicates
   * the weight of [other]; [:0:] will cause [this] to be written to [result],
   * and [:1:] will cause [other] to be written to [result].
   */
  void lerpTo(Vector2 other, num amount, Vector2 result)
  {
    assert(amount >= 0 && amount <= 1);
    result.x = x + (amount * (other.x - x));
    result.y = y + (amount * (other.y - y));
  }
  
  /** Normalizes this vector in place. */
  void normalize() => normalizeTo(this);
  
  /** Normalizes this vector into [result]. */
  void normalizeTo(Vector2 result) {
    final len = length;
    assert(len > 0);    
    result.x = x/len;
    result.y = y/len;
  }
  
  String toString() => "vector2($x,$y)";
}
