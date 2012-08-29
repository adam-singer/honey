
void testVector2() {  
  group('testVector2', () {    
    test('testLength', testLength);
    test('testVector2LerpTo', testVector2LerpTo);
    test('testNormalize', testNormalize);
    test('testVector2Equals', testVector2Equals);
    test('testVector2ToString', testVector2ToString);
  });
}

void testLength() {
  var v = new Vector2(3.0, 4.0);
  expect(v.length, equals(5.0));
  expect(v.lengthSquared, equals(25.0));
}

void testVector2LerpTo() {
  // TODO:
}

void testNormalize() {
  var v = new Vector2(3.14, 3.14); // y = x
  v.normalize();
  expect(v.length, closeTo(1.0, tolerance));
  expect(v.x, closeTo(sqrt(0.5), tolerance));
  expect(v.y, closeTo(sqrt(0.5), tolerance));
  var v2 = new Vector2(1.12345, 2.2469); // y = 2 * x
  v2.normalize();
  expect(v2.length, closeTo(1.0, tolerance));
  expect(v2.x, closeTo(sqrt(0.2), tolerance));
  expect(v2.y, closeTo(2*sqrt(0.2), tolerance));
}

void testVector2Equals() {
  var x = new Vector2(1, 2);
  var y = new Vector2(1, 2);
  var z = new Vector2(1.0, 2.0);
  expect(x, isNot(equals(null)));
  expect(x, equals(x));
  expect(x, equals(y));
  expect(y, equals(x));
  expect(y, equals(z));
  expect(x, equals(z));
  expect(x.hashCode(), equals(y.hashCode()));
  expect(y.hashCode(), equals(z.hashCode()));
  expect(x.hashCode(), equals(z.hashCode()));
  var w = new Vector2(-1, 2);
  expect(x, isNot(equals(w)));
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
  w = new Vector2(1, -2);
  expect(w, isNot(equals(x)));
  expect(w.hashCode(), isNot(equals(x.hashCode())));
}

void testVector2ToString() {
  var v = new Vector2(1, 2);
  expect(v.toString(), equals("vector2(1,2)"));
}
