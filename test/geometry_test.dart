
#library('honey:geometry:test');

#import('dart:math');
#import('package:unittest/unittest.dart');
#import('package:honey/geometry.dart');

#source('geometry/affine_transform_test.dart');
#source('geometry/rectangle_test.dart');
#source('geometry/vector_test.dart');

double tolerance = 0.000000001;

void main() {  
  testRectangle();
  testAffineTransform();
  testVector2();
}
