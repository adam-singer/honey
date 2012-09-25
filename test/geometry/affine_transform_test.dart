
void testAffineTransform() {  
  group('testAffineTransform', () {      
    test('testCopyOfConstructor', testCopyOfConstructor);
    test('testIdentityConstructor', testIdentityConstructor);
    test('testInverseOfConstructor', testInverseOfConstructor);
    test('testRotationConstructor', testRotationConstructor);
    test('testRotationAnchorConstructor', testRotationAnchorConstructor);
    test('testScalingConstructor', testScalingConstructor);
    test('testShearingConstructor', testShearingConstructor);
    test('testTranslationConstructor', testTranslationConstructor);
    test('testSetToIdentity', testSetToIdentity);
    test('testScaleShearTranslateFactors', testScaleShearTranslateFactors);
    test('testRotate', testRotate);
    test('testRotateAnchor', testRotateAnchor);
    test('testScale', testScale);
    test('testShear', testShear);
    test('testTranslate', testTranslate);
    test('testConcatenate', testConcatenate);
    test('testPreconcatenate', testPreconcatenate);
    test('testAssociativeConcatenate', testAssociativeConcatenate);
    test('testTransform', testTransform);
    test('testLerpTo', testLerpTo);
    test('testDeterminant', testDeterminant);
    test('testIsInvertible', testIsInvertible);
    test('testEquals', testEquals);
    test('testToString', testToString);
  });
}

void testCopyOfConstructor() {
  var from = new AffineTransform(1, 2, 3, 4, 5, 6);
  var to = new AffineTransform.copyOf(from);
  expect(from.m00, equals(to.m00));
  expect(from.m10, equals(to.m10));
  expect(from.m01, equals(to.m01));
  expect(from.m11, equals(to.m11));
  expect(from.m02, equals(to.m02));
  expect(from.m12, equals(to.m12));
}

void testIdentityConstructor() {
  var tx = new AffineTransform.identity();
  expect(tx.m00, equals(1));  
  expect(tx.m10, equals(0));
  expect(tx.m01, equals(0));
  expect(tx.m11, equals(1));
  expect(tx.m02, equals(0));
  expect(tx.m12, equals(0));
}

void testInverseOfConstructor() {
  var tx = new AffineTransform.scaling(2, 3)
      ..translate(5, 10)..rotateAnchor(PI / 4, 5, 10);
  var iv = new AffineTransform.inverseOf(tx);
  expect(iv.m00, closeTo(0.353553390, tolerance));  
  expect(iv.m10, closeTo(-0.353553390, tolerance));  
  expect(iv.m01, closeTo(0.235702260, tolerance));
  expect(iv.m11, closeTo(0.235702260, tolerance));
  expect(iv.m02, closeTo(-16.213203435, tolerance));
  expect(iv.m12, closeTo(2.928932188, tolerance));
}

void testRotationConstructor() {
  var tx = new AffineTransform.rotation(PI / 2);  
  expect(tx.m00, closeTo(0, tolerance));
  expect(tx.m10, closeTo(1, tolerance));
  expect(tx.m01, closeTo(-1, tolerance));
  expect(tx.m11, closeTo(0, tolerance));
  expect(tx.m02, closeTo(0, tolerance));
  expect(tx.m12, closeTo(0, tolerance));
}

void testRotationAnchorConstructor() {
  var tx = new AffineTransform.rotationAnchor(PI / 2, 1, 2);  
  expect(tx.m00, closeTo(0, tolerance));
  expect(tx.m10, closeTo(1, tolerance));
  expect(tx.m01, closeTo(-1, tolerance));
  expect(tx.m11, closeTo(0, tolerance));
  expect(tx.m02, closeTo(3, tolerance));
  expect(tx.m12, closeTo(1, tolerance));
}

void testScalingConstructor() {
  var tx = new AffineTransform.scaling(2, 4);
  expect(tx.m00, equals(2));
  expect(tx.m10, equals(0));
  expect(tx.m01, equals(0));
  expect(tx.m11, equals(4));
  expect(tx.m02, equals(0));
  expect(tx.m12, equals(0));
}

void testShearingConstructor() {
  var tx = new AffineTransform.shearing(2, 4);
  expect(tx.m00, equals(1));
  expect(tx.m10, equals(4));
  expect(tx.m01, equals(2));
  expect(tx.m11, equals(1));
  expect(tx.m02, equals(0));
  expect(tx.m12, equals(0));
}

void testTranslationConstructor() {
  var tx = new AffineTransform.translation(2, 4);
  expect(tx.m00, equals(1));
  expect(tx.m10, equals(0));
  expect(tx.m01, equals(0));
  expect(tx.m11, equals(1));
  expect(tx.m02, equals(2));
  expect(tx.m12, equals(4));
}

void testSetToIdentity() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6);
  expect(tx.m00, equals(1));
  expect(tx.m10, equals(2));
  expect(tx.m01, equals(3));
  expect(tx.m11, equals(4));
  expect(tx.m02, equals(5));
  expect(tx.m12, equals(6));
  expect(tx.isIdentity, isFalse);
  tx.setToIdentity();
  expect(tx.m00, equals(1));
  expect(tx.m10, equals(0));
  expect(tx.m01, equals(0));
  expect(tx.m11, equals(1));
  expect(tx.m02, equals(0));
  expect(tx.m12, equals(0));
  expect(tx.isIdentity, isTrue);
}

void testScaleShearTranslateFactors() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6);
  expect(tx.scaleX, equals(1));
  expect(tx.scaleY, equals(4));
  expect(tx.shearX, equals(3));
  expect(tx.shearY, equals(2));
  expect(tx.translateX, equals(5));
  expect(tx.translateY, equals(6));
}

void testRotate() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)..rotate(PI / 2);
  expect(tx.m00, closeTo(3, tolerance));
  expect(tx.m10, closeTo(4, tolerance));
  expect(tx.m01, closeTo(-1, tolerance));
  expect(tx.m11, closeTo(-2, tolerance));
  expect(tx.m02, closeTo(5, tolerance));
  expect(tx.m12, closeTo(6, tolerance));
}

void testRotateAnchor() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)
      ..rotateAnchor(PI / 2, 1, 1);
  expect(tx.m00, closeTo(3, tolerance));
  expect(tx.m10, closeTo(4, tolerance));
  expect(tx.m01, closeTo(-1, tolerance));
  expect(tx.m11, closeTo(-2, tolerance));
  expect(tx.m02, closeTo(7, tolerance));
  expect(tx.m12, closeTo(10, tolerance));
}

void testScale() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)..scale(2, 3);
  expect(tx.m00, equals(2));
  expect(tx.m10, equals(4));
  expect(tx.m01, equals(9));
  expect(tx.m11, equals(12));
  expect(tx.m02, equals(5));
  expect(tx.m12, equals(6));
}

void testShear() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)..shear(2, 3);
  expect(tx.m00, equals(10));
  expect(tx.m10, equals(14));
  expect(tx.m01, equals(5));
  expect(tx.m11, equals(8));
  expect(tx.m02, equals(5));
  expect(tx.m12, equals(6));
}

void testTranslate() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)..translate(2, 3);
  expect(tx.m00, equals(1));
  expect(tx.m10, equals(2));
  expect(tx.m01, equals(3));
  expect(tx.m11, equals(4));
  expect(tx.m02, equals(16));
  expect(tx.m12, equals(22));
}

/**
 *  | 1 3 5 |   | 2 6 4 |   | 5 21 18 |
 *  | 2 4 6 | x | 1 5 3 | = | 8 32 26 |
 *  | 0 0 1 |   | 0 0 1 |   | 0 0  1  |
 */
void testConcatenate() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)
      ..concatenate(new AffineTransform(2, 1, 6, 5, 4, 3));
  expect(tx.m00, equals(5));
  expect(tx.m10, equals(8));
  expect(tx.m01, equals(21));
  expect(tx.m11, equals(32));
  expect(tx.m02, equals(18));
  expect(tx.m12, equals(26));
}

/**
 *  | 2 6 4 |   | 1 3 5 |   | 14 30 50 |
 *  | 1 5 3 | x | 2 4 6 | = | 11 23 38 |
 *  | 0 0 1 |   | 0 0 1 |   | 0  0  1  |
 */
void testPreconcatenate() {
  var tx = new AffineTransform(1, 2, 3, 4, 5, 6)
      ..preconcatenate(new AffineTransform(2, 1, 6, 5, 4, 3));
  expect(tx.m00, equals(14));
  expect(tx.m10, equals(11));
  expect(tx.m01, equals(30));
  expect(tx.m11, equals(23));
  expect(tx.m02, equals(50));
  expect(tx.m12, equals(38));
}

void testAssociativeConcatenate() {
  var a = new AffineTransform(2, 3, 5, 7, 11, 13)
    ..concatenate(new AffineTransform(17, 19, 23, 29, 31, 37));
  var b = new AffineTransform(17, 19, 23, 29, 31, 37)
    ..preconcatenate(new AffineTransform(2, 3, 5, 7, 11, 13));
  expect(a.m00, equals(b.m00));
  expect(a.m01, equals(b.m01));
  expect(a.m10, equals(b.m10));
  expect(a.m11, equals(b.m11));
  expect(a.m02, equals(b.m02));
  expect(a.m12, equals(b.m12));
}

void testTransform() {
  var srcPts = [0, 0, 1, 0, 1, 1, 0, 1];
  var dstPts = new List(8);
  AffineTransform tx = new AffineTransform.scaling(2, 3)
      ..translate(5, 10)..rotateAnchor(PI / 4, 5, 10);
  tx.transform(srcPts, 0, dstPts, 0, 4);
  expect(dstPts[0], closeTo(27.071067811, tolerance));
  expect(dstPts[1], closeTo(28.180194846, tolerance));
  expect(dstPts[2], closeTo(28.485281374, tolerance));
  expect(dstPts[3], closeTo(30.301515190, tolerance));
  expect(dstPts[4], closeTo(27.071067811, tolerance));
  expect(dstPts[5], closeTo(32.422835533, tolerance));
  expect(dstPts[6], closeTo(25.656854249, tolerance));
  expect(dstPts[7], closeTo(30.301515190, tolerance));
}

void testLerpTo() {
  var a = new AffineTransform(1, 2, 3, 4, 5, 6);
  var b = new AffineTransform(2, 1, 6, 5, 4, 3);
  var result = new AffineTransform.identity();
  a.lerpTo(b, 0, result);
  expect(result.m00, equals(1));
  expect(result.m10, equals(2));
  expect(result.m01, equals(3));
  expect(result.m11, equals(4));
  expect(result.m02, equals(5));
  expect(result.m12, equals(6));
  a.lerpTo(b, 1, result);
  expect(result.m00, equals(2));
  expect(result.m10, equals(1));
  expect(result.m01, equals(6));
  expect(result.m11, equals(5));
  expect(result.m02, equals(4));
  expect(result.m12, equals(3));
  a.lerpTo(b, 0.5, result);
  expect(result.m00, equals(1.5));
  expect(result.m10, equals(1.5));
  expect(result.m01, equals(4.5));
  expect(result.m11, equals(4.5));
  expect(result.m02, equals(4.5));
  expect(result.m12, equals(4.5));
}

void testDeterminant() {
  var tx = new AffineTransform.scaling(2, 3)
      ..translate(5, 10)..rotateAnchor(PI / 4, 5, 10);
  expect(tx.determinant, equals(6));
}

void testIsInvertible() {
  expect(new AffineTransform(2, 3, 4, 5, 6, 7).isInvertible, isTrue);
  expect(new AffineTransform(1, 0, 0, 1, 0, 0).isInvertible, isTrue);  
  expect(new AffineTransform(double.NAN, 0, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, double.NAN, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, double.NAN, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, double.NAN, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, double.NAN, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, 0, double.NAN).isInvertible, isFalse);
  expect(new AffineTransform(double.INFINITY, 0, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, double.INFINITY, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, double.INFINITY, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, double.INFINITY, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, double.INFINITY, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, 0, double.INFINITY).isInvertible, isFalse);
  expect(new AffineTransform(double.NEGATIVE_INFINITY, 0, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, double.NEGATIVE_INFINITY, 0, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, double.NEGATIVE_INFINITY, 1, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, double.NEGATIVE_INFINITY, 0, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, double.NEGATIVE_INFINITY, 0).isInvertible, isFalse);
  expect(new AffineTransform(1, 0, 0, 1, 0, double.NEGATIVE_INFINITY).isInvertible, isFalse);
  expect(new AffineTransform(0, 0, 0, 0, 1, 0).isInvertible, isFalse);
}

void testEquals() {  
  var x = new AffineTransform(1, 2, 3, 4, 5, 6);
  var y = new AffineTransform(1, 2, 3, 4, 5, 6);
  var z = new AffineTransform(1, 2, 3, 4, 5, 6);
  expect(x, isNot(equals(null)));
  expect(x, equals(x));
  expect(x, equals(y));
  expect(y, equals(x));
  expect(y, equals(z));
  expect(x, equals(z));
  expect(x.hashCode(), equals(y.hashCode()));
  expect(y.hashCode(), equals(z.hashCode()));
  expect(x.hashCode(), equals(z.hashCode()));
  var w = new AffineTransform(-1, 2, 3, 4, 5, 6);
  expect(x, isNot(equals(w)));
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new AffineTransform(1, -2, 3, 4, 5, 6);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new AffineTransform(1, 2, -3, 4, 5, 6);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new AffineTransform(1, 2, 3, -4, 5, 6);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new AffineTransform(1, 2, 3, 4, -5, 6);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new AffineTransform(1, 2, 3, 4, 5, -6);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
}

void testToString() {
  var tx = new AffineTransform(1, 2.0, 3, 4.0, 5, 6.0);
  expect(tx.toString(), equals("transform(1,2.0,3,4.0,5,6.0)"));
}
