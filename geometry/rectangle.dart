
interface HasRectangle {
  Rectangle get rectangle();
}

/**
 * A generic rectangle class.
 * 
 * Rectangles are endpoint-exclusive. The following reasoning for this is 
 * derived from Raymond Chen's blog 'The Old New Thing':
 * 
 * http://blogs.msdn.com/b/oldnewthing/archive/2004/02/18/75652.aspx
 * 
 * Endpoint-exclusive rectangles are much easier to work with.
 * 
 * For example, the width of a rectangle is (right - left).  If rectangles
 * were endpoint-inclusive, then the width would be (right - left + 1).
 * 
 * Endpoint-exclusive rectangles also scale properly. 
 * 
 * For example, suppose you have two rectangles (0,0)-(100,100) and 
 * (100,100)-(200,200). These two rectangles barely touch at the corner. 
 * Now suppose you magnify these rectangles by 2, so they are now 
 * (0,0)-(200,200) and (200,200)-(400,400). Notice that they still barely 
 * touch at the corner. Also the length of each edge doubled from 100 to 200.
 */
class Rectangle<T extends num> {
  
  T left, top, width, height;
  
  T get right() => left + width;
  T get bottom() => top + height;
  
  Rectangle(this.left, this.top, this.width, this.height);
  
  bool contains(Rectangle other) => 
      (left <= other.left) && (right >= other.right) && 
      (top <= other.top) && (bottom >= other.bottom);
  
  void inflate(T w, T h) {
    left -= w;
    top -= h;
    width += w * 2;
    height += h * 2;
  }
  
  bool intersects(Rectangle other) => 
      (right > other.left) && (left < other.right) && 
      (bottom > other.top) && (top < other.bottom);    
      
  void offset(T x, T y) {
    left += x;
    top += y;
  }
  
  String toString() => "l: $left, t: $top, w: $width, h: $height";
}
