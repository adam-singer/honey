#library('honey:happening:test');

#import('file:///c:/dart/dart-sdk/lib/unittest/unittest.dart');

#import('../happening.dart');

void main() {
  testHappening();
}

void testHappening() { 
  group('testHappening', () {
    test('testObserveIgnoreSuccess', testObserveIgnoreSuccess);  
    test('testIgnoreUnobservedReturnsFalse', testIgnoreUnobservedReturnsFalse);
    test('testObserveTwiceReturnsFalse', testObserveTwiceReturnsFalse);
    test('testSingleObservationSingleHappening', testSingleObservationSingleHappening);
    test('testSingleObservationMultipleHappenings', testSingleObservationMultipleHappenings);
    test('testMultipleObservationsSingleHappening', testMultipleObservationsSingleHappening);
    test('testMultipleObservationsMultipleHappenings', testMultipleObservationsMultipleHappenings);
  });
}

void testObserveIgnoreSuccess() {  
  Observer observation = (value) {};
  Happening happeningUUT = new Happening();  
  expect(happeningUUT.observe(observation), isTrue);
  expect(happeningUUT.ignore(observation), isTrue);  
}

void testIgnoreUnobservedReturnsFalse() {
  Observer observation = (value) {};  
  Happening happeningUUT = new Happening(); 
  expect(happeningUUT.ignore(observation), isFalse);
}

void testObserveTwiceReturnsFalse() {
  Observer observation = (value) {};
  Happening happeningUUT = new Happening();  
  expect(happeningUUT.observe(observation), isTrue);
  expect(happeningUUT.observe(observation), isFalse);
}

void testSingleObservationSingleHappening() {  
  int observationCount = 0;
  Observer<String> observation = (value) {
    observationCount++;
    expect(value, equals("snarf"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observation);
  happeningUUT.happen("snarf");  
  expect(observationCount, equals(1));
}

void testSingleObservationMultipleHappenings() {
  int observationCount = 0;
  Observer<String> observation = (value) {
    observationCount++;
    if(observationCount == 1) expect(value, equals("snarf"));
    if(observationCount == 2) expect(value, equals("woof"));
    if(observationCount == 3) expect(value, equals("yapp"));    
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observation);
  happeningUUT.happen("snarf");  
  happeningUUT.happen("woof");
  happeningUUT.happen("yapp");
  expect(observationCount, equals(3));
}

void testMultipleObservationsSingleHappening() {
  int observation1Count = 0;
  int observation2Count = 0;
  int observation3Count = 0;
  Observer<String> observation1 = (value) {
    observation1Count++;
    expect(value, equals("snarf"));
  };
  Observer<String> observation2 = (value) {
    observation2Count++;
    expect(value, equals("snarf"));
  };
  Observer<String> observation3 = (value) {
    observation3Count++;
    expect(value, equals("snarf"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observation1);
  happeningUUT.observe(observation2);
  happeningUUT.observe(observation3);
  happeningUUT.happen("snarf");
  expect(observation1Count, equals(1));
  expect(observation2Count, equals(1));
  expect(observation3Count, equals(1));
  expect(happeningUUT.ignore(observation1), isTrue); 
  expect(happeningUUT.ignore(observation2), isTrue); 
  expect(happeningUUT.ignore(observation3), isTrue);
}

void testMultipleObservationsMultipleHappenings() {
  int observation1Count = 0;
  int observation2Count = 0;
  int observation3Count = 0;
  Observer<String> observation1 = (value) {
    observation1Count++;
    if(observation1Count == 1) expect(value, equals("snarf"));
    if(observation1Count == 2) expect(value, equals("woof"));
    if(observation1Count == 3) expect(value, equals("yapp"));
  };
  Observer<String> observation2 = (value) {
    observation2Count++;
    if(observation2Count == 1) expect(value, equals("snarf"));
    if(observation2Count == 2) expect(value, equals("woof"));
    if(observation2Count == 3) expect(value, equals("yapp"));
  };
  Observer<String> observation3 = (value) {
    observation3Count++;
    if(observation3Count == 1) expect(value, equals("snarf"));
    if(observation3Count == 2) expect(value, equals("woof"));
    if(observation3Count == 3) expect(value, equals("yapp"));
  };  
  Happening happeningUUT = new Happening();
  happeningUUT.observe(observation1);
  happeningUUT.observe(observation2);
  happeningUUT.observe(observation3);
  happeningUUT.happen("snarf");  
  happeningUUT.happen("woof");
  happeningUUT.happen("yapp");
  expect(observation1Count, equals(3));
  expect(observation2Count, equals(3));
  expect(observation3Count, equals(3));
  expect(happeningUUT.ignore(observation1), isTrue); 
  expect(happeningUUT.ignore(observation2), isTrue); 
  expect(happeningUUT.ignore(observation3), isTrue);
}
