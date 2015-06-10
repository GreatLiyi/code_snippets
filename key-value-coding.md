## key-value coding
in essence, key-value coding defines the patterns and method signatures that your application's accessor methods implement.

- a key is a string that identifies a specific property of an object. Keys must use ASCII encoding, begin with a lowercase letter, and may not contain whitespace.
- a key path is a string of dot separated keys that is used to specify a sequence of object properties to traverse.
- valueForKeyPath:
- valueForKey:
- dictionaryWithValuesForKeys: retrieves the values for an array of keys relative to the receiver
- setValuesForKeysWithDictionary: //update object properties using dictionary. Default implementation is enumerating dictionary and using setValue:forKey:
- if the key is for a to-many property, and not the last key in the path, the returned value is a collection
