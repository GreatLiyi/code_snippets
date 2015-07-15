# type encoding

## relationship of class and metaclass
![class and metaclass](images/relation_of_class_metaclass.png)

有几点需要注意：
- root class(class)没有父类，因此它的superclass指向nil
- 每一个class的isa都指向唯一一个meta class
- root class(meta)的父类是root class(class),也就是NSObject, Class也是一个对象
- 所有的meta class的isa指针都指向root class(meta)

## autorelease pool implementation


http://gold.xitu.io/entry/5599daa2e4b0c4d3e71b292d

http://cocoasamurai.blogspot.jp/2010/01/understanding-objective-c-runtime.html

## class method
- class method中的self指的是什么？
class也是一个对象，这里的self指的就是该对象。
- class method和instance method有什么区别？
class method从meta class中查找，instance method从class中查找

## lldb记录所有的消息调用
call (void)instrumentObjcMessageSends(YES) //开启

## 如何实现KVO
http://tech.glowing.com/cn/implement-kvo/
