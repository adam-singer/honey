
/**
 * A representation of a [Rectangle].
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
class Rectangle {
  
  num left, top, width, height;
  
  num get right() => left + width;
  num get bottom() => top + height;
  
  Rectangle(this.left, this.top, this.width, this.height);
  
  bool operator ==(Object other) {
    if(this === other) return true;
    if(other is! Rectangle) return false; 
    return left == other.left && top == other.top 
        && width == other.width && height == other.height;
  }
  
  bool contains(Rectangle other) => 
      (left <= other.left) && (right >= other.right) && 
      (top <= other.top) && (bottom >= other.bottom);
  
  void inflate(num w, num h) {
    left -= w;
    top -= h;
    width += w * 2;
    height += h * 2;
  }
  
  bool intersects(Rectangle other) => 
      (right > other.left) && (left < other.right) && 
      (bottom > other.top) && (top < other.bottom);    
      
  void offset(num x, num y) {
    left += x;
    top += y;
  }
  
  String toString() => "rectangle($left,$top,$width,$height)";
}
