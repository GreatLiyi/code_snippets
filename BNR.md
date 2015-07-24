## 初始化方法
指定初始化方法(designated initializer)，确保每个实例变量都处于一个有效的状态。应该做一个注释，表明是designated initializer.

头文件顺序约定
- 实例变量声明
- 类方法
- 初始化方法
- 其他方法

## 数组
数组的下标语法也可以向数组中添加对象
``` objc
for (int i=0; i<10; i++) {
    BNRItem *item = [BNRItem randomItem];
    //[items addObject:item];
    items[i]=item;
}
```

## 属性的特性
- 多线程特性nonatomic,atomic
- 读写属性readwrite,readonly
- 内存管理属性 strong,weak,copy,unsafe_unretained
unsafe_unretained用于对象属性，表示方法直接为实例变量赋值，不会自动nil
与之对应的是assign，用于非对象属性，直接为实例变量赋值，不会自动nil
copy用于类型有可修改子类的属性，设置为copy后，还需在代码中调用copy方法。比如setter方法和init方法中
