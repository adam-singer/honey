
/**
 * Represents a QuadTree of type [T].
 *
 * A QuadTree is a structure that is designed to partition space
 * so that it is faster to find items that are inside or outside a given area.
 *
 * This implementation contains items of type [T] which extend [HasRectangle].
 * It will store the item in the smallest quad, bigger than the user-defined 
 * minimum size, which will hold it.  There is no limit to how many items can
 * be added to a given quad.  Quads are created on demand as items are added, 
 * and deleted on item removal if they are empty.
 *
 * This implementation performs best when there are not many large items and 
 * when the size of most items are close to the minimum size passed to the 
 * constructor.  This implementation is optimized for speed and memory. 
 * 
 * This implementation has been inspired by the work of [Michael Coyle]
 * (http://www.codeproject.com/Articles/30535/A-Simple-QuadTree-Implementation-in-C)
 */
class QuadTree<T extends HasRectangle> implements QuadSpace<T> {

  final Rectangle _rectangle;
  final QuadTreeNode<T> _root;
  
  Rectangle get rectangle => _rectangle;  
  int get count => _root.countRecursive;
  
  QuadTree(rectangle, [minWidth = 20, minHeight = 20]) 
  : this._rectangle = rectangle
  , _root = new QuadTreeNode._lazy(rectangle, minWidth, minHeight);
  
  QuadTree.full(rectangle, [minWidth = 20, minHeight = 20]) 
  : this._rectangle = rectangle
  , _root = new QuadTreeNode._full(rectangle, minWidth, minHeight);
  
  void add(T item) => _root.add(item);  
  void query(Rectangle queryRect, void f(T item)) => _root.query(queryRect, f);
  void queryToList(Rectangle queryRect, List<T> matches) 
      => query(queryRect, (item) => matches.add(item));
  bool remove(T item) => _root.remove(item);
  void visit(void f(QuadTreeNode<T> node)) => _root.visit(f);
}

/// Represents a node of type [T] in a [QuadTree].
class QuadTreeNode<T extends HasRectangle> implements HasRectangle {
  
  final Rectangle _rectangle;  
  final num _minWidth, _minHeight;
  final List<QuadTreeNode<T>> _nodes;  
  final List<T> _items;
        
  Rectangle get rectangle => _rectangle;  
  bool get isLeaf => _nodes.isEmpty;
  
  int get countRecursive {
    int count = _items.length;
    _nodes.forEach((node) => count += node.countRecursive);    
    return count;
  }
    
  QuadTreeNode._lazy(this._rectangle, this._minWidth, this._minHeight) 
      : _items = new List<T>()
      , _nodes = new List<QuadTreeNode<T>>();
    
  QuadTreeNode._full(this._rectangle, this._minWidth, this._minHeight) 
      : _items = new List<T>()
      , _nodes = new List<QuadTreeNode<T>>() {
    num halfWidth = _rectangle.width / 2;
    num halfHeight = _rectangle.height / 2;
    if((halfWidth >= _minWidth) && (halfHeight >= _minHeight)) {
      Rectangle topLeft = new Rectangle(_rectangle.left, 
          _rectangle.top, halfWidth, halfHeight);
      Rectangle topRight = new Rectangle(_rectangle.left + halfWidth, 
          _rectangle.top, halfWidth, halfHeight);
      Rectangle bottomLeft = new Rectangle(_rectangle.left, 
          _rectangle.top + halfHeight, halfWidth, halfHeight);
      Rectangle bottomRight = new Rectangle(_rectangle.left + halfWidth, 
          _rectangle.top + halfHeight, halfWidth, halfHeight);
      _nodes.add(new QuadTreeNode._full(topLeft, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._full(topRight, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._full(bottomLeft, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._full(bottomRight, _minWidth, _minHeight));
    }
  }
    
  void add(T item) {    
    assert(_rectangle.contains(item.rectangle));
    
    num halfWidth = _rectangle.width / 2;
    num halfHeight = _rectangle.height / 2;
    
    // if we are at the smallest allowed size then add the item to this node
    if((halfWidth < _minWidth) || (halfHeight < _minHeight)) {
      _items.add(item);        
      return;
    }
    
    // lazily create subnodes
    if(isLeaf) {
      Rectangle topLeft = new Rectangle(_rectangle.left, 
          _rectangle.top, halfWidth, halfHeight);
      Rectangle topRight = new Rectangle(_rectangle.left + halfWidth, 
          _rectangle.top, halfWidth, halfHeight);
      Rectangle bottomLeft = new Rectangle(_rectangle.left, 
          _rectangle.top + halfHeight, halfWidth, halfHeight);
      Rectangle bottomRight = new Rectangle(_rectangle.left + halfWidth, 
          _rectangle.top + halfHeight, halfWidth, halfHeight);
      _nodes.add(new QuadTreeNode._lazy(topLeft, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._lazy(topRight, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._lazy(bottomLeft, _minWidth, _minHeight));
      _nodes.add(new QuadTreeNode._lazy(bottomRight, _minWidth, _minHeight));
    }
    
    // check each subnode; 
    // if it contains the item add the item to that node and return
    for(var node in _nodes) {
      if(node.rectangle.contains(item.rectangle)) {
        node.add(item);
        return;
      }  
    }
    
    // if we get here then there is no subnode that would contain the item, 
    // so add it to this node's items
    _items.add(item);
  }
  
  void forEach(void f(T item)) => _items.forEach(f);
  
  // this method does not free up empty subnodes for gc intentionally, 
  // we don't want to churn the heap
  bool remove(T item) {
    
    // check first if this node has the item
    final index = _items.indexOf(item);
    if(index != -1) {
      _items.removeRange(index, 1);  
      return true;
    }   
    
    // check each subnode; if it has the item remove it and return
    for(var node in _nodes) {
      if(node.remove(item)) {
        return true;
      }
    }
        
    // no subnode has the item
    return false;
  }
  
  void query(Rectangle queryRect, void f(T item)) {
    
    // this node's items are not entirely contained by any of its subnodes; 
    // iterate over items to see if they intersect the query rectangle
    _items.forEach((item) {
      if(queryRect.intersects(item.rectangle)) {
        f(item);
      }
    });
    
    for(var node in _nodes) {
      
      // case 1: search area is completely contained by the subnode
      // if a subnode completely contains the query area, go down that
      // branch and skip the remaining subnodes (break this loop)
      if(node.rectangle.contains(queryRect)) {
        node.query(queryRect, f);
        break;
      }  
      
      // case 2: subnode is completely contained by the search area
      // if the query area completely contains the subnode, just add
      // all of the items of that subnode (recursively) to the results.
      // we need to continue the loop still to test the other subnodes.
      if(queryRect.contains(node.rectangle)) {
        node.visit((n) {
          n._items.forEach((item) { f(item); });
        });
        continue;
      }
      
      // case 3: search area intersects with the subnode
      // go down the branch and continue the loop to test the other subnodes.
      if(node.rectangle.intersects(queryRect)) {
        node.query(queryRect, f);
      }
    }
  }
    
  void visit(void f(QuadTreeNode<T> node)) {
    f(this);    
    _nodes.forEach((node) => node.visit(f));
  }  
}
