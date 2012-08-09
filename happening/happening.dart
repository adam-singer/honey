
#library('honey:happening');

// TODO: Anonymous functions are neither canonical nor Hashable, so the user has to be careful to 
// observe/ignore with a variable reference to their function (as opposed to the function itself) 
// until the language gives us a way to allow that:
// see http://code.google.com/p/dart/issues/detail?id=144
// and http://code.google.com/p/dart/issues/detail?id=167

typedef void Observer<T>(T context);

class Happening<T> {
  
  // TODO: if and when functions become Hashable, we can change this to be
  // a HashSet<Observer<T>> and lift the user requirement of passing us a reference
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
