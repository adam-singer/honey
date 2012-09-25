
#library('honey:data');

#import('dart:json');
#import('package:honey/happening.dart');

/**
 * An observable [Data] object that is essentially a property bag.  [Data] can
 * be serialized to and from JSON, and properties may be added or removed at
 * any time.  
 */
class Data implements Hashable, Map<String, Dynamic> {
  
  Map<String, Dynamic> _properties;
  
  final Happening<String> adding;
  final Happening<String> added;  
  final Happening<String> changing;    
  final Happening<String> changed;    
  final Happening<String> removing;
  final Happening<String> removed;
  final Happening resetting;
  final Happening reset;
  
  Data() : this._fromMap(new Map<String, Dynamic>());
  
  Data._fromMap(this._properties)
      : adding = new Happening<String>()
      , added = new Happening<String>()
      , changing = new Happening<String>()
      , changed = new Happening<String>() 
      , removing = new Happening<String>()
      , removed = new Happening<String>()
      , resetting = new Happening()
      , reset = new Happening() {
    _parseMap(_properties);
  }
      
  bool operator ==(Object other) {
    if(this === other) return true;
    if(other is! Data) return false;    
    final Data otherData = other;
    if(length != otherData.length) return false;
    // two empty and different Data objects are not equal
    if(length == 0) return false;  
    // TODO: I don't like that this allocates a new Collection
    // TODO: we should probably use forEach(f) even though we can't break the loop... :(
    // as suggested by Christopher Wright, we could throw an Exception to break !?!
    Collection keys = _properties.getKeys();
    for(String k in keys) {
      if(!otherData.containsKey(k)) return false;
      if(!_buildEquals(_properties[k], otherData[k])) return false;     
    }    
    return true;
  }
  
  bool _buildEquals(Dynamic value, Dynamic otherValue) {
    if(value is List) {
      if(!(otherValue is List)) return false;
      var list = value;        
      var otherList = otherValue;
      if(list.length != otherList.length) return false;        
      for(int i = 0; i < list.length; i++) {
        if(!_buildEquals(list[i], otherList[i])) return false;
      }
      return true;
    } else {
      return value == otherValue;
    }
  }
  
  int hashCode() {
    // TODO: investigate using a Jenkins hash instead as described in this forum thread:
    // https://groups.google.com/a/dartlang.org/group/misc/browse_thread/thread/bcefaa5674a73819/7f19db1217011a51#7f19db1217011a51
    int result = 17;
    _properties.forEach((k, v) {
      result = 37 * result + _buildHash(v, result);
    });
    return result;
  }
  
  int _buildHash(Dynamic value, int result) {
    if(value != null) {
      if(value is List) {
        var list = value;
        list.forEach((e) {
          result = 37 * result + _buildHash(e, result);
        });
      } 
      else if(value is bool) {
        result = 37 * result + (value ? 0 : 1);
      }      
      else { // num, String, Data are all Hashable
        result = 37 * result + value.hashCode();
      }
    }
    return result;
  }
  
  int get length => _properties.length;
  operator [](key) => _properties[key];
  bool containsKey(key) => _properties.containsKey(key);
  bool containsValue(value) => _properties.containsValue(value);  
  forEach(void f(key,value)) => _properties.forEach(f);
  Collection getKeys() => _properties.getKeys();
  Collection getValues() => _properties.getValues();  
  bool isEmpty() => _properties.isEmpty();
  
  operator []=(key,value) {
    if(containsKey(key)) {
      changing.happen(key);
      _properties[key] = value;
      changed.happen(key);
    } else {
      adding.happen(key);
      _properties[key] = value;
      added.happen(key);
    }
  }
  
  void clear() { 
    resetting.happen();
    _properties.clear();
    reset.happen();
  }
    
  putIfAbsent(key, ifAbsent()) {
    final bool isAbsent = !containsKey(key);
    if(isAbsent) adding.happen(key);
    final value = _properties.putIfAbsent(key, ifAbsent);
    if(isAbsent) added.happen(key);
    return value;
  }
  
  remove(key) {
    removing.happen(key);
    final value = _properties.remove(key);
    removed.happen(key);
    return value;
  }
  
  noSuchMethod(String name, List args) {    
    if(args.length == 0 && name.startsWith("get:")) {
      final String propertyName = name.substring(4);
      if(containsKey(propertyName)) {
        return this[propertyName];
      }
    } else if(args.length == 1 && name.startsWith("set:")) {
      final String propertyName = name.substring(4);      
      this[propertyName] = args[0];
      return;
    }
    super.noSuchMethod(name, args);
  }
  
  void fromJson(String s) {    
    resetting.happen();
    _properties = JSON.parse(s);
    assert(_properties is Map);
    _parseMap(_properties);
    reset.happen();
  }
  
  String toJson() => JSON.stringify(_properties);
  
  // TODO: have a look at the new JSON.printOn() method, should help avoid string allocations
  
  void _parseList(List list) {
    for(int i = 0; i < list.length; i++) {
      var item = list[i];
      if(item is Map) {
        list[i] = new Data._fromMap(item);        
      } else if(item is List) {
        _parseList(item);
      }
    }
  }
  
  void _parseMap(Map props) {    
    props.forEach((key, value) {
      if(value is Map) {        
        props[key] = new Data._fromMap(value);
      } else if(value is List) {
        _parseList(value);
      }
    });
  }
  
}
