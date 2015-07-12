class is also an object, NSObject is an object, its class is NSObject meta class. instance method在NSObject中查找，class method在NSObject meta class中查找。meta class和class名称是一样的，创建的时候同时产生。
NSObject meta class inherit from NSObject。这样NSObject中的instance method在NSObject meta class中也存在。
