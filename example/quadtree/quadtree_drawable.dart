
// TODO: this should no longer be a library, but rather a part
// of a standalone example application (that builds and renders a quadtree!)
#library('honey:quadtree:drawable');

#import('package:honey/graphics2d.dart');
#import('package:honey/quadspace.dart');

class QuadTreeDrawable implements Drawable2d {
  
  final QuadTree _tree;
  final Color _itemColor;
  final Color _borderColor;
  
  QuadTreeDrawable(this._tree)
  : _itemColor = new Color(0, 0, 255, 0.2)
  , _borderColor = new Color(200, 200, 200, 1);
  
  void draw(Graphics2d graphics) {
    graphics.save();
    
    _tree.forEach((node) {
   
      // draw the items of the node
      node._items.forEach((item) {
        graphics.setFillColor(_itemColor);
        graphics.fillRectangle(item.rectangle);        
      });
      
      // draw the inside of the node's rectangle      
      graphics.setStrokeColor(_borderColor);            
      node.rectangle.inflate(-1,-1);
      graphics.strokeRectangle(node.rectangle);
      node.rectangle.inflate(1,1);      
      
    });
    
    graphics.restore();
  }
}
