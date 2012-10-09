
#library('honey:quadtree:test');

#import('package:unittest/unittest.dart');
#import('package:affinity/affinity.dart');
#import('package:honey/quadspace.dart');

void main() {
  testQuadTree();
}

class TestQuad implements HasRectangle {
  Rectangle rectangle;
  TestQuad(this.rectangle);
}

void testQuadTree() {
  group('QuadTreeTest', () {    
    test('testSimpleLazyQuadTree', testSimpleLazyQuadTree);    
  });
}

/**
 * The QuadTree in this test case has dimensions of 240x240 and minimum 
 * quad size of 40x40, which means that a 6x6 matrix of 40x40 nodes represents
 * a 'full' tree:
 *
 * ----------------------> x
 * 0       120       240 |
 * ___________________   | 0
 * |__|__|__|__|__|__|   |
 * |__|__|__|__|__|__|   |
 * |__|__|__|__|__|__|   | 120
 * |__|__|__|__|__|__|   |
 * |__|__|__|__|__|__|   | 
 * |__|__|__|__|__|__|   | 240
 *                       V
 *                         y
 */
void testSimpleLazyQuadTree() {
  
  var tree = new QuadTree(new Rectangle(0, 0, 240, 240), 40, 40);

  var quad1 = new TestQuad(new Rectangle(40, 40, 40, 40));
  var quad2 = new TestQuad(new Rectangle(20, 15, 30, 50));
  var quad3 = new TestQuad(new Rectangle(201, 199, 39, 41));
  var quad4 = new TestQuad(new Rectangle(130, 0, 100, 1));
  var quad5 = new TestQuad(new Rectangle(100, 1, 50, 77));
  tree.add(quad1);  
  tree.add(quad2);
  tree.add(quad3);
  tree.add(quad4);
  tree.add(quad5);
  
  expect(tree.count, equals(5));
    
  List results = new List();
  
  tree.queryToList(new Rectangle(0, 0, 240, 240), results);
  expect(results.length, equals(5));
  
  results.clear();
  tree.queryToList(new Rectangle(0, 0, 40, 40), results);
  expect(results.length, equals(1));
  expect(results[0], same(quad2));
  
  results.clear();
  tree.queryToList(new Rectangle(100, 1, 100, 100), results);
  expect(results.length, equals(1));
  expect(results[0], same(quad5));
  
  results.clear();
  tree.queryToList(new Rectangle(100, 0, 100, 100), results);
  expect(results.length, equals(2));
  Expect.notEquals(-1, results.indexOf(quad4));
  Expect.notEquals(-1, results.indexOf(quad5));
  
  results.clear();
  tree.queryToList(new Rectangle(200, 160, 40, 40), results);
  expect(results.length, equals(1));
  expect(results[0], same(quad3));
  
  results.clear();
  tree.queryToList(new Rectangle(40, 65, 1, 1), results);
  expect(results.length, equals(1));
  expect(results[0], same(quad1));
  
  tree.remove(quad1);
  tree.remove(quad2);
  tree.remove(quad3);
  tree.remove(quad4);
  tree.remove(quad5);
  
  expect(tree.count, equals(0));
  
  results.clear();    
  tree.queryToList(new Rectangle(0, 0, 240, 240), results);
  expect(results.length, equals(0));
}
