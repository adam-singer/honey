
library happening;

/**
 * An [Observer] function is used to observe a [Happening] and will be invoked
 * each time the [Happening] happens until it ignores the [Happening].  The 
 * [Happening] may pass a different [context] to the [Observer] each time it
 * happens, and the [context] may be [:null:].
 */
typedef void Observer<T>(T context);

/**
 * A [Happening] is something that can be [observe]d and can [happen].  It is
 * synonymous to an event.  It may optionally carry contextual information of
 * type [T].
 * 
 * One or more [Observer]s may [observe] a [Happening], and they may also
 * decide at any time to [ignore] the [Happening].  When a [Happening]
 * [happen]s, all [Observer]s that are currently observing will be called with
 * the context (may be [:null:]).
 * 
 * It it important that user code call [observe] and [ignore] with the same
 * reference to their [Observer] function.  This is a (hopefully) temporary
 * workaround for the fact that anonymous functions are neither canonical nor
 * [Hashable], so the management of the references must be delegated to the 
 * user code.  Other current event models in dart are often choosing to return
 * a new [Hashable] object from their register method which they require to be
 * passed back to their unregister method.  Our reason for not taking that
 * approach (in addition to avoiding the allocation) is that this can lead to
 * more complex bookkeeping in objects that observe more than one other object
 * with the same observer function.  With our approach, the observing object in
 * this situation can reuse its single reference to its observer function to
 * register with any number of objects it is observing.  This requirement will
 * be completely lifted if either of the following issues is fixed:
 * 
 *    http://code.google.com/p/dart/issues/detail?id=144
 *    http://code.google.com/p/dart/issues/detail?id=167
 *    
 * As an example, let's consider that we have a Kitten class:
 * 
 *    class Kitten {
 *      final Happening meowed;
 *      final Happening<Mouse> ate;
 *      
 *      Kitten()
 *      : meowed = new Happening()
 *      , ate = new Happening<Mouse>();
 *      
 *      void meow() => meowed.happen();
 *      void eat(Mouse m) => ate.happen(m);
 *    }
 *    
 * Our Kitten can meow and it can eat any given Mouse.  These 2 occurences are
 * exposed via the Happenings meowed and ate.  When the Kitten eats a Mouse, it
 * also passes the specific Mouse that it ate as the context of that Happening.
 * Now let's define an Owner class as someone who wants to observe the behavior
 * of one or more Kittens:
 * 
 *    class Owner {
 *      Observer _onMeowedRef;
 *      Observer _onAteRef;
 *      
 *      Owner() {
 *        _onMeowedRef = _onMeowed;
 *        _onAteRef = _onAte;
 *      }
 *    
 *      void adopt(Kitten kitten) {
 *        assert(kitten.meowed.observe(_onMeowedRef));
 *        assert(kitten.ate.observe(_onAteRef));
 *        
 *        // keep track of our kitten
 *      }
 *      
 *      void release(Kitten kitten) {
 *        assert(kitten.meowed.ignore(_onMeowedRef));
 *        assert(kitten.ate.ignore(_onAteRef));
 *        
 *        // young heart be free tonight
 *      }
 *      
 *      void _onMeowed(ignored) {
 *        // pay some attention to all of our kittens
 *      }
 *      
 *      void _onAte(mouse) {
 *        // not much we can do!
 *      }
 *    }
 *    
 *  The first thing to notice is that the Owner keeps a private Observer
 *  reference to each of its observer methods.  These are the references that 
 *  it will use to observe and ignore the Happenings.  When the Owner adopts a 
 *  new Kitten, we can see that it starts to observe both the meowed and ate
 *  happenings using these references.  Those calls are wrapped in assert 
 *  statements as a convenience, to ensure that the Owner does not accidentally 
 *  observe the same Happening twice.  When the owner releases a Kitten back to
 *  the wild, it similarly ignores the Happenings.  This example also 
 *  illustrates the use case of observing multiple Happenings with the same
 *  Observer reference.  Since the Owner controls the Observer reference 
 *  himself, he may observe multiple Kittens with the same reference.
 */
class Happening<T> {
  
  final HashSet<Observer<T>> _observers;
  
  // TODO: consider lazily allocating this on first observe
  Happening() : _observers = new HashSet<Observer<T>>();
  
  /**
   * Notifies all observers that the happening has happened.  A [context] may
   * be provided and will be passed to all observers.
   */
  void happen([T context]) => _observers.forEach((o) => o(context));
  
  /**
   * Ignores the happening for the given [observer].  Returns [:true:] if the
   * [observer] was observing the happening, else [:false:].
   */
  bool ignore(Observer<T> observer) => _observers.remove(observer);
  
  /**
   * Observes the happening for the given [observer].  Returns [:true:] if the
   * [observer] was not already observing the happening, else [:false:].
   */
  bool observe(Observer<T> observer) {
    if(_observers.contains(observer)) return false;
    _observers.add(observer);
    return true;
  }
}
