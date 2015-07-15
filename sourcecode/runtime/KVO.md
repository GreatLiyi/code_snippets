
Typically, controller objects observe model objects, and views observe controller objects or model objects.

## 官方实现

``` objc
//NSObject
- (void)addObserver:(NSObject *)anObserver
  forKeyPath:(NSString *)keypath
  options:(NSKeyValueObservingOptions)options
  context:(void *)context
将anObserver注册为receiver keypath的监听者
这里的context通常会设置一个const值
- (void)observeValueForKeyPath:(NSString *)keypath
  ofObject:(id)object
  change:(NSDictionary *)change
  context:(void *)context;

- (void)removeObserver:forKeyPath:context;
```
neither the receiver, nor anObserver are retained. 当使用KVO时，必须调用removeObserver:forKeyPath: or removeObserver:forKeyPath:context:

## register for KVO
什么是KVO-complaint?

## KeyValueObserver helper class
注意observertoken和observedTarget的顺序

## KVO和线程
KVO行为是同步的，并且发生在于所观察的值变化同样的线程上。不推荐把KVO和多线程混起来

## KVC
KVC允许我们用属性的字符串名称来访问属性，字符串也叫键。不仅可以访问对象属性，而且也能访问一些标量(int,CGFloat)和struct（CGRect）

``` objc
@property (nonatomic) CGFloat height;

[object setValue:@(20) forKey:@"height"];
```

## KVC without @property
通过设置-<key> and -set<Key>:方法，可以实现一个支持KVC的属性

``` objc
//需要height属性支持KVC
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
//这样就可以调用
[object setValue:nil forKey:@"height"];

//这里会抛异常，需要处理nil
- (void)setNilValueForKey:(NSString *)key{
  if([key isEqualToString:@"height"]){
    [self setValue:@0 forKey:key];
  }else{
    [super setNilValueForKey:key];
  }
}
```

## KVC 访问instance variables
默认情况下KVC在找不到方法时会访问instance variable, 根据`(BOOL)accessInstanceVariablesDirectly`方法。子类可以override该方法。按照_<key>, _is<Key>, <key> 和 is<Key> 的顺序查找实例变量。

## key path
KVC同样允许我们通过关系来访问对象，如person对象有属性address,address有属性city
``` objc
[person valueForKeyPath:@"address.city"]
```

## 集合的操作
官方文档[collection operators](https://developer.apple.com/library/ios/documentation/cocoa/conceptual/KeyValueCoding/Articles/CollectionOperators.html)
``` objc
NSArray *a=@[@4,@84,@2];
NSLog(@"max= %@",[a valueForKeyPath:@"@max.self"]);//取最大值
```
