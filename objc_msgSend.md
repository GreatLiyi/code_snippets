# 消息
本章描述了消息表达式（message expression）是如何转变为对objc_msgSend的调用，以及如何通过方法名称来引用方法。之后介绍了如何利用objc_msgSend，在需要的时候，规避动态绑定带来的性能损失。

## objc_msgSend函数
在objective-c中，将消息传递绑定到具体的方法实现是在运行时进行的（messages aren't bound to method implementations until runtime）。编译器将下面的消息表达式转换为对消息函数objc_msgSend的调用。
``` objective-c
[receiver message]
```
该函数接收receiver和上述消息（方法selector）中得方法名称作为主要参数：
``` objective-c
objc_msgSend(receiver,selector)
```
传递给消息的所有参数也一并传递给objc_msgSend:
``` objective-c
objc_msgSend(receiver,selector,arg1,arg2,...)
```
消息函数为了动态绑定做如下准备：
- 首先定位到selector指向的方法实现。由于每个类对于同样的方法有不同的实现，具体定位的实现过程（proccedure）取决于接受者(receiver)
- 之后调用该过程，传入接受者对象(receiving object)，一个指向具体数据的指针。同时传入方法制定的参数
- 最后，将该过程的返回值作为消息函数的返回值。
```
Note:编译器生成对消息函数的调用，在你的代码中不要直接调用。
```

消息传递的关键，存在于编译器为每个class和object构建的结构中。每个class结构都包括以下两个核心元素：
- 一个指向父类的指针
- 一个类指派表（dispatch table）。指派表里的条目关联方法selector和selector对应的方法地址，这些地址与类相关的。如setOrigin:: method的selector，关联到setOrigin::的地址，display方法的selector关联到display的地址。
