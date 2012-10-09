#library('honey:quadspace');

#import('package:affinity/affinity.dart');

#source('src/quadspace/quadtree.dart');

abstract class HasRectangle {
  Rectangle get rectangle;
}

abstract class QuadSpace<T extends HasRectangle> implements HasRectangle {
  int get count;
  
  void add(T item);
  bool remove(T item);
  
  void query(Rectangle queryRect, void f(T item));
  void queryToList(Rectangle queryRect, List<T> matches);
}
