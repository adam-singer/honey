
#library('honey:happening:test');

#import('package:unittest/unittest.dart');
#import('package:honey/happening.dart');

void main() {
  testHappening();
}

void testHappening() { 
  group('testHappening', () {
    test('testObserveIgnoreSuccess', testObserveIgnoreSuccess);  
    test('testObserveIgnoreNoReferenceSuccess', testObserveIgnoreNoReferenceSuccess);
    test('testIgnoreUnobservedReturnsFalse', testIgnoreUnobservedReturnsFalse);
    test('testObserveTwiceReturnsFalse', testObserveTwiceReturnsFalse);
    test('testSingleObserverSingleHappening', testSingleObserverSingleHappening);
    test('testSingleObserverMultipleHappenings', testSingleObserverMultipleHappenings);
    test('testMultipleObserversSingleHappening', testMultipleObserversSingleHappening);
    test('testMultipleObserversMultipleHappenings', testMultipleObserversMultipleHappenings);
  });
}

class MockObservingObject {
  void observe(ignored) { }
}

void testObserveIgnoreSuccess() {  
  Observer observer = (value) {};
  Happening happeningUUT = new Happening();  
  expect(happeningUUT.observe(observer), isTrue);
  expect(happeningUUT.ignore(observer), isTrue);  
}

// This test relies on / validates that multiple anonymous Closures over the
// same method of the same object hash to the same value (currently fails)
void testObserveIgnoreNoReferenceSuccess() {
  var observer = new MockObservingObject();
  Happening happeningUUT = new Happening();  
  expect(happeningUUT.observe(observer.observe), isTrue);
  expect(happeningUUT.ignore(observer.observe), isTrue);
}

void testIgnoreUnobservedReturnsFalse() {
  Observer observer = (value) {};  
  Happening happeningUUT = new Happening(); 
  expect(happeningUUT.ignore(observer), isFalse);
}

void testObserveTwiceReturnsFalse() {
  Observer observer = (value) {};
  Happening happeningUUT = new Happening();  
  expect(happeningUUT.observe(observer), isTrue);
  expect(happeningUUT.observe(observer), isFalse);
}

void testSingleObserverSingleHappening() {  
  int observationCount = 0;
  Observer<String> observer = (value) {
    observationCount++;
    expect(value, equals("snarf"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observer);
  happeningUUT.happen("snarf");  
  expect(observationCount, equals(1));
}

void testSingleObserverMultipleHappenings() {
  int observationCount = 0;
  Observer<String> observer = (value) {
    observationCount++;
    if(observationCount == 1) expect(value, equals("snarf"));
    if(observationCount == 2) expect(value, equals("woof"));
    if(observationCount == 3) expect(value, equals("yapp"));    
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observer);
  happeningUUT.happen("snarf");  
  happeningUUT.happen("woof");
  happeningUUT.happen("yapp");
  expect(observationCount, equals(3));
}

void testMultipleObserversSingleHappening() {
  int observation1Count = 0;
  int observation2Count = 0;
  int observation3Count = 0;
  Observer<String> observer1 = (value) {
    observation1Count++;
    expect(value, equals("snarf"));
  };
  Observer<String> observer2 = (value) {
    observation2Count++;
    expect(value, equals("snarf"));
  };
  Observer<String> observer3 = (value) {
    observation3Count++;
    expect(value, equals("snarf"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observer1);
  happeningUUT.observe(observer2);
  happeningUUT.observe(observer3);
  happeningUUT.happen("snarf");
  expect(observation1Count, equals(1));
  expect(observation2Count, equals(1));
  expect(observation3Count, equals(1));
  expect(happeningUUT.ignore(observer1), isTrue); 
  expect(happeningUUT.ignore(observer2), isTrue); 
  expect(happeningUUT.ignore(observer3), isTrue);
}

void testMultipleObserversMultipleHappenings() {
  int observation1Count = 0;
  int observation2Count = 0;
  int observation3Count = 0;
  Observer<String> observer1 = (value) {
    observation1Count++;
    if(observation1Count == 1) expect(value, equals("snarf"));
    if(observation1Count == 2) expect(value, equals("woof"));
    if(observation1Count == 3) expect(value, equals("yapp"));
  };
  Observer<String> observer2 = (value) {
    observation2Count++;
    if(observation2Count == 1) expect(value, equals("snarf"));
    if(observation2Count == 2) expect(value, equals("woof"));
    if(observation2Count == 3) expect(value, equals("yapp"));
  };
  Observer<String> observer3 = (value) {
    observation3Count++;
    if(observation3Count == 1) expect(value, equals("snarf"));
    if(observation3Count == 2) expect(value, equals("woof"));
    if(observation3Count == 3) expect(value, equals("yapp"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observer1);
  happeningUUT.observe(observer2);
  happeningUUT.observe(observer3);
  happeningUUT.happen("snarf");  
  happeningUUT.happen("woof");
  happeningUUT.happen("yapp");
  expect(observation1Count, equals(3));
  expect(observation2Count, equals(3));
  expect(observation3Count, equals(3));
  expect(happeningUUT.ignore(observer1), isTrue); 
  expect(happeningUUT.ignore(observer2), isTrue); 
  expect(happeningUUT.ignore(observer3), isTrue);
}
