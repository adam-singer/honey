
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
  });
}

void testRectangleContainsItself() {
  Rectangle r = new Rectangle(10.1, 3.14, 7, 19);
  Expect.isTrue(r.contains(r));  
  Rectangle ri = new Rectangle<int>(10, 10, 7, 19);  
  Expect.isTrue(ri.contains(ri));  
  Rectangle rd = new Rectangle<double>(10.1, 3.14, 17.9, 6.0);
  Expect.isTrue(rd.contains(rd));
}

void testRectangleIntersectsItself() {
  Rectangle r = new Rectangle(0.12345, 0, 20.678, 99);
  Expect.isTrue(r.intersects(r));
  Rectangle ri = new Rectangle<int>(0, 0, 11, 9);
  Expect.isTrue(ri.intersects(ri));
  Rectangle rd = new Rectangle<double>(10.1, 3.14, 17.9, 6.0);
  Expect.isTrue(rd.intersects(rd));
}

void testRectangleWithOnePixelLessHeightDoesNotContain() {
  Rectangle r1 = new Rectangle(0, 0, 10, 10);
  Rectangle r2 = new Rectangle(0, 0, 10, 9);
  Expect.isFalse(r2.contains(r1));
}

void testRectangleWithSubPixelLessHeightDoesNotContain() {
  Rectangle r1 = new Rectangle<double>(0.0, 0.0, 10.0, 10.0);
  Rectangle r2 = new Rectangle<double>(0.0, 0.0, 10.0, 9.9999);
  Expect.isFalse(r2.contains(r1));
}

void testRectangleWithOnePixelLessWidthDoesNotContain() {
  Rectangle r1 = new Rectangle(14, 60, 1000000, 2000);
  Rectangle r2 = new Rectangle(14, 60, 999999, 2000);
  Expect.isFalse(r2.contains(r1));
}

void testRectangleWithSubPixelLessWidthDoesNotContain() {
  Rectangle r1 = new Rectangle<double>(14.0, 60.0, 1000000.0, 2000.0);
  Rectangle r2 = new Rectangle<double>(14.0, 60.0, 999999.9999, 2000.0);
  Expect.isFalse(r2.contains(r1)); 
}

void testRectanglesWithOnePixelOverlapIntersect() {
  Rectangle r1 = new Rectangle(0, 0, 9, 9);
  Rectangle r2 = new Rectangle(8, 8, 100, 100);
  Expect.isTrue(r1.intersects(r2));
  Expect.isTrue(r2.intersects(r1));
}

void testRectanglesWithSubPixelOverlapIntersect() {
  Rectangle r1 = new Rectangle<double>(0.0, 0.0, 9.0, 9.0);
  Rectangle r2 = new Rectangle<double>(8.9999, 8.9999, 100.0, 100.0);
  Expect.isTrue(r1.intersects(r2));
  Expect.isTrue(r2.intersects(r1));
}

void testRectanglesLeftRightTouchingDoNotIntersect() {
  Rectangle r1 = new Rectangle(10, 0, 10, 10);
  Rectangle r2 = new Rectangle(20, 0, 10, 10);
  Expect.isFalse(r1.intersects(r2));
  Expect.isFalse(r2.intersects(r1));
  Rectangle rd1 = new Rectangle<double>(10.12345, 0.0, 10.0, 10.0);
  Rectangle rd2 = new Rectangle<double>(20.12345, 0.0, 10.0, 10.0);
  Expect.isFalse(rd1.intersects(rd2));
  Expect.isFalse(rd2.intersects(rd1));
}

void testRectanglesTopBottomTouchingDoNotIntersect() {
  Rectangle r1 = new Rectangle(0, 0, 10, 10);
  Rectangle r2 = new Rectangle(0, 10, 10, 10);
  Expect.isFalse(r1.intersects(r2));
  Expect.isFalse(r2.intersects(r1));
  Rectangle rd1 = new Rectangle<double>(0.0, 0.0, 10.0, 10.413);
  Rectangle rd2 = new Rectangle<double>(0.0, 10.413, 10.0, 10.0);
  Expect.isFalse(rd1.intersects(rd2));
  Expect.isFalse(rd2.intersects(rd1));
}
