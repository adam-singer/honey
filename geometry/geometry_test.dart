
#library('honey:geometry:test');

#import('file:///c:/dart/dart-sdk/lib/unittest/unittest.dart');

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
