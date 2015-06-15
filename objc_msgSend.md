# 消息
本章描述了消息表达式（message expression）是如何转变为对objc_msgSend的调用，以及如何通过方法名称来引用方法。之后介绍了在需要的时候，如何利用objc_msgSend，规避动态绑定带来的性能损失。

## objc_msgSend函数
在objective-c中，将消息传递绑定到具体的方法实现是在运行时做的（messages aren't bound to method implementations until runtime）。编译器将下面的消息表达式转换为对消息函数objc_msgSend的调用。
``` objective-c
[receiver message]
```
该函数接收receiver和上述消息中的方法名称（方法selector）作为主要参数：
``` objective-c
objc_msgSend(receiver,selector)
```
传递给消息的所有参数也一并传递给objc_msgSend:
``` objective-c
objc_msgSend(receiver,selector,arg1,arg2,...)
```
消息函数为了动态绑定做如下准备：
- 首先定位到selector指向的方法实现。由于每个类对于同样的方法有不同的实现，具体定位的实现过程（proccedure）取决于接受者(receiver)
- 之后调用该过程，传入接受者对象(receiving object)，一个指向具体数据的指针。同时传入方法指定的参数
- 最后，将该过程的返回值作为消息函数的返回值。
```
Note:编译器生成对消息函数的调用，在你的代码中不要直接调用。
```

消息传递的关键，存在于编译器为每个class和object构建的结构中。每个class结构都包括以下两个核心元素：
- 一个指向父类的指针
- 一个类指派表（dispatch table）。指派表里的条目关联方法selector和selector对应的方法地址，这些地址与类有关。如setOrigin:method的selector，关联到setOrigin:的地址，display方法的selector关联到display的地址。

当对象创建时，内存被分配，成员变量被初始化。在对象的变量中处于第一个的是一个指向类结构的指针。这个叫isa的指针，使得object对象可以访问它的类，由此访问所有它继承的类。

这些类的元素以及对象结构如下图所示：
![messaging framework](images/messaging.gif)

- 当消息传递给对象时，消息函数（objc_msgSend）沿着对象的isa指针到类结构，在那里找到指派表中的方法selector。若没有找到selector，objc_msgSend沿着指针到父类结构，试着查找那里的指派表。顺着这个逻辑，objc_msgSend沿着类框架直到NSObject类。当定位到selector，消息函数调用表中的方法，并传入receiver的数据结构。
- 这就是运行时对象的实现被选择的方式，用面向对象的行话来说，方法动态绑定到消息的方式。
- 为了加速消息处理（messaging process），运行时系统缓存selector和用过的方法地址。每个类有一个单独的缓存，该缓存包含继承来的方法以及类本身定义的方法。在搜索指派表之前，消息函数会先检查接收对象类的缓存（基于用过一次很可能会再次用到这一理论）。若selector在缓存中，消息传递只是比方法调用稍稍慢一些。一旦程序运行了足够时间，使得缓存充分热身，几乎所有的消息都会找到对应的缓存方法。缓存随着程序运行动态增长，以便容纳新的消息。

### 使用隐藏参数
objc_msgSend一旦找到某个方法的实现过程（procedure），会把消息中所有的参数传递给该过程。另外还会传递两个隐藏参数：
- 消息接收对象
- 消息方法的selector

这些参数提供了，关于调用每个方法实现（method implementation）的消息表达式([receiver message])的显式信息。这些参数之所以隐藏，是由于它们没有出现在定义方法的源代码声明中。它们是在编译时被插入具体实现的。
尽管这些参数不是显式声明的，源代码中依然可以引用到它们（就像可以引用接收对象的成员变量）。在方法中，通过self访问接收对象，通过_cmd访问方法的selector。下面示例中，_cmd指向strange方法的selector，self指向接收strange消息的对象。
``` objc
- strange{
  id target = getTheReceiver();
  SEL method = getTheMethod();
  if(target == self || method == _cmd) return nil;
  return [target performSelector:method];
}
```
self是两个参数中较有用的一个。事实上，接收对象的方法就是通过它访问该对象的成员变量的。

### 获得方法地址
避免动态绑定的唯一方式是获得方法的地址，把它作为函数一样直接调用。只有在很少情况下这么做才比较合适。比如某个方法将连续运行很多次，而你想要避免每次运行方法带来的消息传递方面的损耗。
通过NSObject中定义的一个方法,methodForSelector:,你可以获得实现某个方法的过程的指针，然后利用这个指针来调用该过程（procedure）。methodForSelector:返回的指针必须要小心得转换成合适的方法类型。返回值和参数都要包含在方法类型中。
下面的例子展示了实现setFilled:方法的过程是如何被调用的：
``` objc
void (*setter)(id,SEL,BOOL);
int i;
setter = (void (*)(id,SEL,BOOL))[target methodForSelector:@selector(setFilled:)];
for(i=0;i<1000;i++){
  setter(targetList[i],@selector(setFilled:),YES);
}
```

传入该过程（setter）的前两个参数分别是接受对象(self)和方法selector(_cmd)。这些参数是隐藏在方法的语法中，当方法被当做函数调用时，需要显式传入这些参数。
使用methodForSelector:来避免动态绑定节省了由于消息传递产生的大部分时间。不过，只有当某个特殊消息重复多次时，比如上面的例子，节省的时间才会比较显著。
需要注意的是methodForSelector:是由Cocoa运行时系统提供的，它并不是Objective-C语言的功能。
