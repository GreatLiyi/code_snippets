
Typically, controller objects observe model objects, and views observe controller objects or model objects.

## 官方实现

``` objc
//NSObject
- (void)addObserver:(NSObject *)anObserver
  forKeyPath:(NSString *)keypath
  options:(NSKeyValueObservingOptions)options
  context:(void *)context
将anObserver注册为receiver keypath的监听者
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

## 集合的操作
