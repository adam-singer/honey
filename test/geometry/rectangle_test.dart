
void testRectangle() {  
  group('testRectangle', () {    
    test('testRectangleContainsItself', testRectangleContainsItself);    
    test('testRectangleIntersectsItself', testRectangleIntersectsItself);    
    test('testRectangleWithOnePixelLessHeightDoesNotContain', testRectangleWithOnePixelLessHeightDoesNotContain);  
    test('testRectangleWithSubPixelLessHeightDoesNotContain', testRectangleWithSubPixelLessHeightDoesNotContain);
    test('testRectangleWithOnePixelLessWidthDoesNotContain', testRectangleWithOnePixelLessWidthDoesNotContain);
    test('testRectangleWithSubPixelLessWidthDoesNotContain', testRectangleWithSubPixelLessWidthDoesNotContain);
    test('testRectanglesWithOnePixelOverlapIntersect', testRectanglesWithOnePixelOverlapIntersect);   
    test('testRectanglesWithSubPixelOverlapIntersect', testRectanglesWithSubPixelOverlapIntersect);
    test('testRectanglesLeftRightTouchingDoNotIntersect', testRectanglesLeftRightTouchingDoNotIntersect);
    test('testRectanglesTopBottomTouchingDoNotIntersect', testRectanglesTopBottomTouchingDoNotIntersect);
    test('testRectangleInflate', testRectangleInflate);
    test('testRectangleTranslate', testRectangleTranslate);
    test('testRectangleEquals', testRectangleEquals);
    test('testRectangleToString', testRectangleToString);
  });
}

void testRectangleContainsItself() {
  var r = new Rectangle(10.1, 3.14, 7, 19);
  expect(r.contains(r), isTrue);
}

void testRectangleIntersectsItself() {
  var r = new Rectangle(0.12345, 0, 20.678, 99);
  expect(r.intersects(r), isTrue);
}

void testRectangleWithOnePixelLessHeightDoesNotContain() {
  var r1 = new Rectangle(0, 0, 10, 10);
  var r2 = new Rectangle(0, 0, 10, 9);
  expect(r2.contains(r1), isFalse);
}

void testRectangleWithSubPixelLessHeightDoesNotContain() {
  var r1 = new Rectangle(0.0, 0.0, 10.0, 10.0);
  var r2 = new Rectangle(0.0, 0.0, 10.0, 9.9999);
  expect(r2.contains(r1), isFalse);
}

void testRectangleWithOnePixelLessWidthDoesNotContain() {
  var r1 = new Rectangle(14, 60, 1000000, 2000);
  var r2 = new Rectangle(14, 60, 999999, 2000);
  expect(r2.contains(r1), isFalse);
}

void testRectangleWithSubPixelLessWidthDoesNotContain() {
  var r1 = new Rectangle(14.0, 60.0, 1000000.0, 2000.0);
  var r2 = new Rectangle(14.0, 60.0, 999999.9999, 2000.0);
  expect(r2.contains(r1), isFalse);
}

void testRectanglesWithOnePixelOverlapIntersect() {
  var r1 = new Rectangle(0, 0, 9, 9);
  var r2 = new Rectangle(8, 8, 100, 100);
  expect(r1.intersects(r2), isTrue);
  expect(r2.intersects(r1), isTrue);
}

void testRectanglesWithSubPixelOverlapIntersect() {
  var r1 = new Rectangle(0.0, 0.0, 9.0, 9.0);
  var r2 = new Rectangle(8.9999, 8.9999, 100.0, 100.0);
  expect(r1.intersects(r2), isTrue);
  expect(r2.intersects(r1), isTrue);
}

void testRectanglesLeftRightTouchingDoNotIntersect() {
  var r1 = new Rectangle(10, 0, 10, 10);
  var r2 = new Rectangle(20, 0, 10, 10);
  expect(r1.intersects(r2), isFalse);
  expect(r2.intersects(r1), isFalse);
  var rd1 = new Rectangle(10.12345, 0.0, 10.0, 10.0);
  var rd2 = new Rectangle(20.12345, 0.0, 10.0, 10.0);
  expect(rd1.intersects(rd2), isFalse);
  expect(rd2.intersects(rd1), isFalse);
}

void testRectanglesTopBottomTouchingDoNotIntersect() {
  var r1 = new Rectangle(0, 0, 10, 10);
  var r2 = new Rectangle(0, 10, 10, 10);
  expect(r1.intersects(r2), isFalse);
  expect(r2.intersects(r1), isFalse);
  var rd1 = new Rectangle(0.0, 0.0, 10.0, 10.413);
  var rd2 = new Rectangle(0.0, 10.413, 10.0, 10.0);
  expect(rd1.intersects(rd2), isFalse);
  expect(rd2.intersects(rd1), isFalse);
}

void testRectangleInflate() {
  var r = new Rectangle(1, 2, 3, 4);
  r.inflate(2, 3.14);
  expect(r.left, equals(-1));
  expect(r.right, equals(6));
  expect(r.width, equals(7));
  expect(r.top, closeTo(-1.14, tolerance));
  expect(r.bottom, closeTo(9.14, tolerance));
  expect(r.height, closeTo(10.28, tolerance)); 
}

void testRectangleTranslate() {
  var r = new Rectangle(1, 2, 3, 4);
  r.translate(5, 3.14);
  expect(r.left, equals(6));
  expect(r.right, equals(9));
  expect(r.width, equals(3));
  expect(r.top, closeTo(5.14, tolerance));
  expect(r.bottom, closeTo(9.14, tolerance));
  expect(r.height, closeTo(4, tolerance)); 
}

void testRectangleEquals() {
  var x = new Rectangle(1, 2, 3, 4);
  var y = new Rectangle(1, 2, 3, 4);
  var z = new Rectangle(1.0, 2.0, 3.0, 4.0);
  expect(x, isNot(equals(null)));
  expect(x, equals(x));
  expect(x, equals(y));
  expect(y, equals(x));
  expect(y, equals(z));
  expect(x, equals(z));
  expect(x.hashCode(), equals(y.hashCode()));
  expect(y.hashCode(), equals(z.hashCode()));
  expect(x.hashCode(), equals(z.hashCode()));
  var w = new Rectangle(-1, 2, 3, 4);
  expect(x, isNot(equals(w)));
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new Rectangle(1, -2, 3, 4);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new Rectangle(1, 2, -3, 4);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new Rectangle(1, 2, 3, -4);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
}

void testRectangleToString() {
  var r = new Rectangle(1, 2, 3.0, 4.0);
  expect(r.toString(), equals("rectangle(1,2,3.0,4.0)"));
}
