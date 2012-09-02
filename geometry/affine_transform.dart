
/**
 * A representation of an affine transform.  An affine transform performs a 
 * linear mapping from 2D coordinates to other 2D coordinates that preserves
 * the "straightness" and "parallelness" of lines.
 * 
 * Such a coordinate transformation can be represented by a 3 x 3 matrix with
 * an implied last row of [ 0 0 1 ].  This matrix transforms source coordinates
 * (x,y) into destination coordinates (x',y') by considering them to be a
 * column vector and multiplying the coordinate vector by the matrix according
 * to the following process:
 *
 *    [ x']   [  m00  m01  m02  ] [ x ]   [ m00x + m01y + m02 ]
 *    [ y'] = [  m10  m11  m12  ] [ y ] = [ m10x + m11y + m12 ]
 *    [ 1 ]   [   0    0    1   ] [ 1 ]   [         1         ]
 * 
 * The transformation matrix has the form:
 *    
 *  [ m00 m01 m02 ]           [ scaleX shearX translateX ]
 *  [ m10 m11 m12 ]    or     [ shearY scaleY translateY ]
 *  [ 0   0   1   ]           [ 0      0      1          ]
 */
class AffineTransform implements Hashable { 
  
  num m00, m01, m10, m11, m02, m12;
  
  /**
   * Gets the determinant of the matrix representation of this
   * [AffineTransform].  The determinant is useful both to determine if the
   * [AffineTransform] can be inverted and to get a single value representing
   * the combined x and y scaling of the [AffineTransform].  Mathematically,
   * the determinant is calculated using the formula:
   *
   *  [ m00 m01 m02 ]
   *  [ m10 m11 m12 ] = m00 * m11 - m01 * m10
   *  [ m20 m21 m22 ]    
   */
  num get determinant => m00 * m11 - m01 * m10;
  
  /// Gets whether this [AffineTransform] is the identity transform.
  bool get isIdentity 
      => m00 == 1 && m01 == 0 && m02 == 0
      && m10 == 0 && m11 == 1 && m12 == 0;
  
  /**
   * Gets whether this [AffineTransform] is invertible. A transform is not
   * invertible if the [determinant] is 0 or any value is non-finite or NaN.
   */
  bool get isInvertible {
    final det = determinant;
    return !det.isInfinite() && !det.isNaN() && det != 0
        && !m02.isInfinite() && !m02.isNaN() 
        && !m12.isInfinite() && !m12.isNaN();
  }
  
  /// Gets or sets the scale factor in the x-direction (m00).
  num get scaleX => m00;
      set scaleX(num value) { m00 = value; }
  
  /// Gets or sets the scale factor in the y-direction (m11).
  num get scaleY => m11;
      set scaleY(num value) { m11 = value; }
  
  /// Gets or sets the shear factor in the x-direction (m01).
  num get shearX => m01;
      set shearX(num value) { m01 = value; }
  
  /// Gets or sets the shear factor in the y-direction (m10).
  num get shearY => m10;
      set shearY(num value) { m10 = value; }
  
  /// Gets or sets the translation in the x-direction (m02).
  num get translateX => m02;
      set translateX(num value) { m02 = value; }
         
  /// Gets or sets the translation in the y-direction (m12).
  num get translateY => m12;
      set translateY(num value) { m12 = value; }  
           
  /// Constructs a new [AffineTransform] with the given matrix elements.
  AffineTransform(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12);  
  
  /// Constructs a new [AffineTransform] that is a copy of the given [other].
  AffineTransform.copyOf(AffineTransform other) 
      : this(other.m00, other.m10, other.m01, other.m11, other.m02, other.m12);
  
  /// Constructs a new [AffineTransform] that is the identity transform.
  AffineTransform.identity() : this(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);  
  
  /**
   * Constructs a new [AffineTransform] representing the inverse transformation
   * of the given [other] transform.
   */
  factory AffineTransform.inverseOf(AffineTransform other) {
    final inverse = new AffineTransform.identity();
    other.invertTo(inverse);
    return inverse;
  }
  
  /**
   * Constructs a new [AffineTransform] representing a rotation transformation
   * with the given [theta] as the angle of rotation in radians.
   */
  factory AffineTransform.rotation(num theta)
      => new AffineTransform.identity()..rotate(theta);
  
  /**
   * Constructs a new [AffineTransform] representing a rotation transformation
   * with the given [theta] as the angle of rotation in radians, around the 
   * given anchor point coordinates.
   */
  factory AffineTransform.rotationAnchor(num theta, num anchorX, num anchorY) 
      => new AffineTransform.identity()..rotateAnchor(theta, anchorX, anchorY);
  
  /**
   * Constructs a new [AffineTransform] representing a scaling transformation
   * with the given scale factors.
   */
  AffineTransform.scaling(num scaleX, num scaleY) 
      : this(scaleX, 0.0, 0.0, scaleY, 0.0, 0.0); 
  
  /** 
   * Constructs a new [AffineTransform] representing a shearing transformation
   * with the given shear factors.
   */
  AffineTransform.shearing(num shearX, num shearY) 
      : this(1.0, shearY, shearX, 1.0, 0.0, 0.0);
  
  /**
   * Constructs a new [AffineTransform] representing a translation
   * transformation with the given translation distances.
   */
  AffineTransform.translation(num translateX, num translateY) 
      : this(1.0, 0.0, 0.0, 1.0, translateX, translateY);
  
  bool operator ==(Object other) {
    if(this === other) return true;
    if(other is! AffineTransform) return false; 
    return m00 == other.m00 && m01 == other.m01 && m02 == other.m02
        && m10 == other.m10 && m11 == other.m11 && m12 == other.m12;
  }
  
  int hashCode() => m00.hashCode() ^ m01.hashCode() ^ m02.hashCode()
      ^ m10.hashCode() ^ m11.hashCode() ^ m12.hashCode();
  
  /**
   * Concatenates the given [other] [AffineTransform] to this [AffineTransform].
   *
   *    this = this x other
   */
  void concatenate(AffineTransform other) {    
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
      other.m00, other.m10, other.m01, other.m11, other.m02, other.m12, this);
  }
  
  /**
   * Calculates the inverse transformation of this [AffineTransform] and 
   * writes it out to the [result] [AffineTransform].
   */
  void invertTo(AffineTransform result) {
    assert(isInvertible);
    assert(this != result);
    final det = determinant;
    result.m00 = m11 / det;
    result.m10 = -m10 / det;
    result.m01 = -m01 / det;
    result.m11 = m00 / det;
    result.m02 = (m01 * m12 - m11 * m02) / det;
    result.m12 = (m10 * m02 - m00 * m12) / det;
  }
  
  /**
   * Performs a linear interpolation between this [AffineTransform] and the 
   * [other].  The given [amount] must be a value between [:0:] and [:1:] that
   * indicates the weight of [other]; [:0:] will cause [this] to be written to
   * [result], and [:1:] will cause [other] to be written to [result].
   * 
   *    [result] = [this] + ([amount] * ([other] - [this]))
   */
  void lerpTo(AffineTransform other, num amount, AffineTransform result)
  {
    assert(amount >= 0 && amount <= 1);
    result.m00 = m00 + (amount * (other.m00 - m00));
    result.m10 = m10 + (amount * (other.m10 - m10));
    result.m01 = m01 + (amount * (other.m01 - m01));    
    result.m11 = m11 + (amount * (other.m11 - m11));
    result.m02 = m02 + (amount * (other.m02 - m02));
    result.m12 = m12 + (amount * (other.m12 - m12));
  }
  
  /**
   * Concatenates this [AffineTransform] to the given [other] [AffineTransform].
   *
   *    this = other x this
   */
  void preconcatenate(AffineTransform other) {
    _multiply(other.m00, other.m10, other.m01, other.m11, other.m02, other.m12,
        this.m00, this.m10, this.m01, this.m11, this.m02, this.m12, this);
  }
  
  /**
   * Concatenates this [AffineTransform] with a rotation transformation, using
   * the given angle [theta] in radians.  This is equivalent to calling 
   * concatenate(R), where R is an [AffineTransform] represented by the 
   * following matrix:
   *
   *  [ cos(theta)  -sin(theta)   0
   *    sin(theta)  cos(theta)    0
   *    0           0             1 ]
   *
   * Rotating with a positive angle [theta] rotates points on the positive x 
   * axis towards the positive y axis.
   */
  void rotate(num theta) {
    final sin = sin(theta);
    final cos = cos(theta);
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
        cos, sin, -sin, cos, 0.0, 0.0, this);
  }
  
  /**
   * Concatenates this [AffineTransform] with a transform that rotates
   * coordinates around an anchor point.  This is equivalent to the following
   * sequence of calls:
   *
   *  translate(anchorX, anchorY);
   *  rotate(theta);
   *  translate(-anchorX, -anchorY); 
   *
   * This is also equivalent to calling concatenate(RA), where RA is an
   * [AffineTransform] represented by the following matrix:
   *
   *  [ cos(theta)  -sin(theta) anchorX-anchorX*cos(theta)+anchorY*sin(theta) ]
   *  [ sin(theta)  cos(theta)  anchorY-anchorX*sin(theta)-anchorY*cos(theta) ]
   *  [ 0           0           1                                             ]
   */
  void rotateAnchor(num theta, num anchorX, num anchorY) {
    final sin = sin(theta);
    final cos = cos(theta);
    final dx = anchorX - (anchorX * cos) + (anchorY * sin);
    final dy = anchorY - (anchorX * sin) - (anchorY * cos);
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
        cos, sin, -sin, cos, dx, dy, this);
  }
  
  /**
   * Concatenates this [AffineTransform] with a scaling transformation,
   * using the given scale factors for the x and y axes. This is equivalent to
   * calling concatenate(S), where S is an [AffineTransform] represented by the
   * following matrix:
   *
   *  [ scaleX  0       0 ]
   *  [ 0       scaleY  0 ]
   *  [ 0       0       1 ]
   */
  void scale(num scaleX, num scaleY) {
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
        scaleX, 0.0, 0.0, scaleY, 0.0, 0.0, this);
  }
  
  /// Resets this [AffineTransform] to the Identity transform.
  void setToIdentity() {
    m00 = 1.0;  m01 = 0.0;  m02 = 0.0;
    m10 = 0.0;  m11 = 1.0;  m12 = 0.0;          
    //    0         0        1
  }
    
  /**
   * Concatenates this [AffineTransform] with a shearing transformation, using
   * the given shear factors for the x and y axes.  The shear factor is the
   * multiplier by which coordinates are shifted in the direction of the
   * positive axis as a factor of their coordinate in that axis. This is 
   * equivalent to calling concatenate(SH), where SH is an [AffineTransform]
   * represented by the following matrix:
   *
   *  [ 1       shearX    0 ]
   *  [ shearY  1         0 ]
   *  [ 0       0         1 ]
   */
  void shear(num shearX, num shearY) {
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
        1.0, shearY, shearX, 1.0, 0.0, 0.0, this);
  }
  
  String toString() => "transform($m00,$m10,$m01,$m11,$m02,$m12)";
  
  /**
   * Transforms a given [src] list of point coordinates by this
   * [AffineTransform] and stores the results into the given [dst] list,
   * starting at the specified offsets for the given [count] of points.
   * The coordinates are stored in the lists starting at the specified offset
   * in the order [x0, y0, x1, y1, ...]
   */
  void transform(List<num> src, int srcOff, List<num> dst, int dstOff,
                 int count) {
    for(int i = 0; i < count; i++) {
      final x = src[srcOff++];
      final y = src[srcOff++];
      dst[dstOff++] = (m00 * x) + (m01 * y) + m02;
      dst[dstOff++] = (m10 * x) + (m11 * y) + m12;
    }
  }
  
  /**
   * Concatenates this [AffineTransform] with a translation transformation,
   * using the given offsets for the x and y axes.  This is equivalent to
   * calling concatenate(T), where T is an [AffineTransform] represented by the
   * following matrix:
   *
   *  [ 1     0   offsetX ]
   *  [ 0     1   offsetY ]
   *  [ 0     0   1       ]
   */
  void translate(num offsetX, num offsetY) {
    _multiply(this.m00, this.m10, this.m01, this.m11, this.m02, this.m12,
        1.0, 0.0, 0.0, 1.0, offsetX, offsetY, this);
  }
  
  static void _multiply(
      num am00, num am10, num am01, num am11, num am02, num am12,
      num bm00, num bm10, num bm01, num bm11, num bm02, num bm12,
      AffineTransform result) {
    result.m00 = (am00 * bm00) + (am01 * bm10);
    result.m10 = (am10 * bm00) + (am11 * bm10);
    result.m01 = (am00 * bm01) + (am01 * bm11);    
    result.m11 = (am10 * bm01) + (am11 * bm11);    
    result.m02 =  (am00 * bm02)  + (am01 * bm12) + am02;
    result.m12 =  (am10 * bm02)  + (am11 * bm12) + am12;
   }
}
