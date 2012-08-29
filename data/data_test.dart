
#library('honey:data:test');

#import('file:///c:/dart/dart-sdk/pkg/unittest/unittest.dart');

#import('data.dart');

void main() {
  testData();
}

class Foo extends Data {    
  // TODO: this boilerplate is not necessary other than to appease the static checker :S
  int get x => this['x'];
  set x(value) { this['x'] = value; }
  String get y => this['y'];
  set y(value) { this['y'] = value; }
  List<Bar> get l => this['l'];
  set l(value) { this['l'] = value; }
  // TODO: throws in checked mode if I use Bar, not sure how to resolve..
  // HMMM well the resolution might be if Data implements HasTypeId, and then we serialize the typeId
  // to the JSON.  On a deserialize, we use a DataFactory to construct the Data.
  // that sounds too complicated, better to embrace the Dynamic nature of this I think..
  Dynamic/*Bar*/ get b => this['b']; 
  set b(value) { this['b'] = value; }
  
  Foo()
  : super() {
    l = new List<Bar>();
    b = new Bar(0);
  }
}

class Bar extends Data {  
  int get n => this['n'];
  set n(value) { this['n'] = value; }
  
  Bar(int n)
  : super() {
    this.n = n;
  }
}

var testJson = 
"""
{
  "y" : "you buy posters",
  "x" : 42,
  "l" : [{"n":12}, {"n":17}, {"n":1000}],
  "b" : {"n":7}
}
""";

void testData() {  
  group('testData', () {    
    // serialization tests
    test('testToJson', testToJson);    
    test('testFromJson', testFromJson);    
    
    // equality / hashCode tests    
    test('testReflexiveBarEquals', testReflexiveBarEquals);
    test('testSymmetricBarEquals', testSymmetricBarEquals);
    test('testTransitiveBarEquals', testTransitiveBarEquals);
    test('testBarNotEqualsNull', testBarNotEqualsNull);
    test('testReflexiveFooEquals', testReflexiveFooEquals);
    test('testSymmetricFooEquals', testSymmetricFooEquals);
    test('testTransitiveFooEquals', testTransitiveFooEquals);
    test('testFooNotEqualsNull', testFooNotEqualsNull);    
    test('testEmptyDataNotEquals', testEmptyDataNotEquals);
    
    // Map test cases
    test('testMapAdd', testMapAdd);
    test('testMapChange', testMapChange);
    test('testMapPutIfAbsent', testMapPutIfAbsent);
    test('testMapRemove', testMapRemove);
    test('testMapClear', testMapClear);    
  });
}

void testToJson() {
  Foo f = new Foo();
  f.x = 3;
  f.y = 'snarf';  
  f.l.add(new Bar(2));
  f.l.add(new Bar(16));  
  f.b = new Bar(99);  
  expect(f.toJson(), equals('{"l":[{"n":2},{"n":16}],"y":"snarf","b":{"n":99},"x":3}'));
}

void testFromJson() {    
  Foo f = new Foo();  
  bool observedResetting = false;
  bool observedReset = false;  
  f.resetting.observe((p) {
    observedResetting = true;
    expect(p, isNull);
  });  
  f.reset.observe((p) {
    observedReset = true;
    expect(p, isNull);
  });        
  f.fromJson(testJson);  
  expect(f.y, equals("you buy posters"));
  expect(f.x, equals(42));
  expect(f.l[0].n, equals(12));
  expect(f.l[1].n, equals(17));
  expect(f.l[2].n, equals(1000));
  expect(f.b.n, equals(7));
  expect(observedResetting, isTrue);
  expect(observedReset, isTrue);
}

void testReflexiveBarEquals() {
  Bar x = new Bar(4);
  expect(x, equals(x));
}

void testSymmetricBarEquals() {  
  Bar x = new Bar(4);
  Bar y = new Bar(4);  
  Bar z = new Bar(5);
  expect(x, equals(y));
  expect(y, equals(x));
  expect(x, isNot(equals(z)));
  expect(z, isNot(equals(x)));
  expect(x.hashCode(), equals(y.hashCode()));
}

void testTransitiveBarEquals() {
  Bar x = new Bar(4);
  Bar y = new Bar(4);  
  Bar z = new Bar(4);
  expect(x, equals(y));
  expect(y, equals(z));
  expect(x, equals(z));
  expect(x.hashCode(), equals(y.hashCode()));
  expect(y.hashCode(), equals(z.hashCode()));
  expect(x.hashCode(), equals(z.hashCode()));
}

void testBarNotEqualsNull() {
  Bar x = new Bar(4);
  expect(x, isNot(equals(null)));
}

void testReflexiveFooEquals() {
  Foo x = new Foo();
  x.x = 3;
  x.y = 'snarf';  
  x.l.add(new Bar(2));
  x.l.add(new Bar(16));  
  x.b = new Bar(99);
  expect(x, equals(x));
}

void testSymmetricFooEquals() {
  Foo x = new Foo();
  x.x = 3;
  x.y = 'snarf';  
  x.l.add(new Bar(2));
  x.l.add(new Bar(16));  
  x.b = new Bar(99);
  Foo y = new Foo();
  y.x = 3;
  y.y = 'snarf';  
  y.l.add(new Bar(2));
  y.l.add(new Bar(16));  
  y.b = new Bar(99);
  Foo z = new Foo();
  z.x = 7;
  z.y = 'buna';  
  z.l.add(new Bar(11));
  z.l.add(new Bar(1));  
  z.b = new Bar(1024);
  expect(x, equals(y));
  expect(y, equals(x));
  expect(x, isNot(equals(z)));
  expect(z, isNot(equals(x)));
  expect(x.hashCode(), equals(y.hashCode()));
}

void testTransitiveFooEquals() {
  Foo x = new Foo();
  x.x = 3;
  x.y = 'snarf';  
  x.l.add(new Bar(2));
  x.l.add(new Bar(16));  
  x.b = new Bar(99);
  Foo y = new Foo();
  y.x = 3;
  y.y = 'snarf';  
  y.l.add(new Bar(2));
  y.l.add(new Bar(16));  
  y.b = new Bar(99);
  Foo z = new Foo();
  z.x = 3;
  z.y = 'snarf';  
  z.l.add(new Bar(2));
  z.l.add(new Bar(16));  
  z.b = new Bar(99);
  expect(x, equals(y));
  expect(y, equals(z));
  expect(x, equals(z));
  expect(x.hashCode(), equals(y.hashCode()));
  expect(y.hashCode(), equals(z.hashCode()));
  expect(x.hashCode(), equals(z.hashCode()));
}

void testFooNotEqualsNull() {
  Foo x = new Foo();
  expect(x, isNot(equals(null)));
}

void testEmptyDataNotEquals() {
  Data x = new Data();
  Data y = new Data();
  Expect.notEquals(x, y);
  // TODO: why does the following not work? seems a bug in unittest...
  //expect(y, isNot(equals(x)));
}

void testMapAdd() {
  Data data = new Data();  
  int addingCount = 0;
  int addedCount = 0;
  data.adding.observe((value) {
    addingCount++;
    if(addingCount == 1) expect(value, equals("a"));
    if(addingCount == 2) expect(value, equals("b"));
  });  
  data.added.observe((value) {
    addedCount++;
    if(addedCount == 1) expect(value, equals("a"));
    if(addedCount == 2) expect(value, equals("b"));
  });  
  data['a'] = 12;
  data['b'] = 'snarf';      
  expect(data['a'], equals(12));
  expect(data['b'], equals('snarf'));  
  expect(addingCount, equals(2));
  expect(addedCount, equals(2));  
}

void testMapChange() {
  Data data = new Data();  
  int addingCount = 0;
  int addedCount = 0;
  int changingCount = 0;
  int changedCount = 0;  
  data.adding.observe((value) { addingCount++; });  
  data.added.observe((value) { addedCount++; });  
  data.changing.observe((value) {
    changingCount++;
    if(changingCount == 1) expect(value, equals("a"));
    if(changingCount == 2) expect(value, equals("b"));
  });  
  data.changed.observe((value) {
    changedCount++;
    if(changedCount == 1) expect(value, equals("a"));
    if(changedCount == 2) expect(value, equals("b"));
  });  
  data['a'] = 12;
  data['b'] = 'snarf';  
  expect(addingCount, equals(2));
  expect(addedCount, equals(2));
  expect(changingCount, equals(0));
  expect(changedCount, equals(0));  
  data['a'] = 4096;
  data['b'] = 'woot';  
  expect(data['a'], equals(4096));
  expect(data['b'], equals('woot'));  
  expect(addingCount, equals(2));
  expect(addedCount, equals(2));
  expect(changingCount, equals(2));
  expect(changedCount, equals(2));
}

void testMapPutIfAbsent() {
  Data data = new Data();  
  int addingCount = 0;
  int addedCount = 0;
  int putCount = 0;  
  data.adding.observe((value) {
    addingCount++;
    if(addingCount == 1) expect(value, equals("a"));
    if(addingCount == 2) expect(value, equals("b"));
  });  
  data.added.observe((value) {
    addedCount++;
    if(addedCount == 1) expect(value, equals("a"));
    if(addedCount == 2) expect(value, equals("b"));
  });    
  data.putIfAbsent('a', () { 
    putCount++; 
    return 12;
  });  
  data.putIfAbsent('b', () { 
    putCount++; 
    return 'snarf';
  });  
  expect(addingCount, equals(2));
  expect(addedCount, equals(2));
  expect(putCount, equals(2));
  data.putIfAbsent('a', () { 
    putCount++; 
    return 4096;
  });  
  data.putIfAbsent('b', () { 
    putCount++; 
    return 'woot';
  });  
  expect(data['a'], equals(12));
  expect(data['b'], equals('snarf'));
  expect(addingCount, equals(2));
  expect(addedCount, equals(2));
  expect(putCount, equals(2));
}

void testMapRemove() {
  Data data = new Data();
  int removingCount = 0;
  int removedCount = 0;
  data.removing.observe((value) {
    removingCount++;
    if(removingCount == 1) expect(value, equals("a"));
    if(removingCount == 2) expect(value, equals("b"));
  });  
  data.removed.observe((value) {
    removedCount++;
    if(removedCount == 1) expect(value, equals("a"));
    if(removedCount == 2) expect(value, equals("b"));
  });  
  data['a'] = 12;
  data['b'] = 'snarf'; 
  expect(data['a'], equals(12));
  expect(data['b'], equals('snarf'));  
  expect(removingCount, equals(0));
  expect(removedCount, equals(0));
  data.remove('a');
  data.remove('b');
  expect(data.containsKey('a'), isFalse);
  expect(data.containsKey('b'), isFalse);
  expect(data.isEmpty(), isTrue);
  expect(removingCount, equals(2));
  expect(removedCount, equals(2));
}

void testMapClear() {
  Data data = new Data();
  int resettingCount = 0;
  int resetCount = 0;
  data.resetting.observe((ignored) => resettingCount++);  
  data.reset.observe((ignored) => resetCount++);
  data['a'] = 12;
  data['b'] = 'snarf'; 
  expect(data['a'], equals(12));
  expect(data['b'], equals('snarf'));  
  expect(resettingCount, equals(0));
  expect(resetCount, equals(0));
  data.clear();
  expect(data.containsKey('a'), isFalse);
  expect(data.containsKey('b'), isFalse);
  expect(data.isEmpty(), isTrue);
  expect(resettingCount, equals(1));
  expect(resetCount, equals(1));
}
