
#library('honey:happening');

typedef void Observer<T>(T context);

/**
 * A [Happening] is something that can be [observe]d and can [happen].  It is
 * synonymous to an event.  It may optionally carry contextual information of type [T].
 * 
 * One or more [Observer]s may [observe] a [Happening], and they may also
 * decide at any time to [ignore] the [Happening].  When a [Happening] [happen]s,
 * all [Observer]s that are currently observing will be called with the context (may be null).
 * 
 * It it important that user code call [observe] and [ignore] with the same reference to 
 * their [Observer] function.  This is a (hopefully) temporary workaround for the fact that
 * anonymous functions are neither canonical nor [Hashable], so the management of the references
 * must be delegated to the user code.  Other current event models in dart are often choosing to
 * return a new [Hashable] object from their register method which they require to be passed back
 * to their unregister method.  Our reason for not taking that approach (in addition to avoiding
 * the allocation) is that this can lead to more complex bookkeeping in objects that observe more
 * than one other object with the same observer function.  With our approach, the observing object
 * in this situation can reuse its single reference to its observer function to register with
 * any number of objects it is observing.  This requirement will be completely lifted if either
 * of the following issues is fixed:
 * 
 *    http://code.google.com/p/dart/issues/detail?id=144
 *    http://code.google.com/p/dart/issues/detail?id=167
 *    
 * TODO: provide an example
 * 
 */
class Happening<T> {
  
  // TODO: if and when functions become Hashable, we can change this to a 
  // HashSet<Observer<T>> and lift the user requirement of passing us a reference
  final List<Observer<T>> _observers;
  
  // TODO: consider lazily allocating this list on first observe
  Happening() : _observers = new List<Observer<T>>();  
  
  void happen([T context]) => _observers.forEach((o) => o(context));
  
  bool ignore(Observer<T> observer) { //=> Lists.remove(_observers, observer);  
    // since there is no List.remove(object) and we don't want this library to have
    // any dependencies (i.e. on a Lists utilities class) we unroll the logic here
    final index = _observers.indexOf(observer);
    if(index == -1) return false;
    _observers.removeRange(index, 1);
    return true;
  }
  
  bool observe(Observer<T> observer) {
    if(_observers.indexOf(observer) == -1) {
      _observers.add(observer);
      return true;
    }
    return false;
  }
}
