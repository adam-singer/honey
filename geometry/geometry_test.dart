
#library('honey:geometry:test');

#import('file:///c:/dart/dart-sdk/pkg/unittest/unittest.dart');

#import('dart:math');
#import('geometry.dart');

#source('affine_transform_test.dart');
#source('rectangle_test.dart');
#source('vector_test.dart');

double tolerance = 0.000000001;

void main() {  
  testRectangle();
  testAffineTransform();
  testVector2();
}
