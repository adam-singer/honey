#library('honey:quadspace');

#import('../geometry/geometry.dart');

#source('quadtree.dart');

interface HasRectangle {
  Rectangle get rectangle;
}

interface QuadSpace<T extends HasRectangle> extends HasRectangle {
  int get count;
  
  void add(T item);
  bool remove(T item);
  
  void query(Rectangle queryRect, void f(T item));
  void queryToList(Rectangle queryRect, List<T> matches);
}
