## KVO 三个相关方法
``` objc
- (void)addObserver:(NSObject *)anObserver
  forKeyPath:(NSString *)keyPath
  options:(NSKeyValueObservingOptions)options
  context:(void *)context;
- (void)observeValueForKeyPath:(NSString *)keyPath
  ofObject:(id)object
  change:(NSDictionary *)change
  context:(void *)context;
- (void)removeObserver:(NSObject *)anObserver
  forKeyPath:(NSString *)keyPath;
```
