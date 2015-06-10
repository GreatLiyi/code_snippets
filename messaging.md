## messaging

### objc_msgSend function
two hidden arguments to the procedure that implements a method
- the receiving object(self)
- the selector for the method(_cmd)

``` objective-c
- strange{
  id target = getTheReceiver();
  SEL method = getTheMethod();
  if(target == self || method == _cmd) return nil;
  return [target performSelector:method];
}
```

### getting a method address
dynamic binding comes at a price. The only way to circumvent it is to get the address of a method and call it directly as if it were a function. 只有很少的情况下，如减少方法多次调用的消耗。
With a method defined in the NSObject class, methodForSelector:, you can ask for a pointer to the procedure that implements a method, then use the pointer to call the procedure. The pointer that methodForSelector: returns must be carefully cast to the proper function type. Both return and argument types should be included in the cast.
``` objective-c
//declare a C function type variable
void (*setter)(id,SEL,BOOL);
int i;
setter = (void (*)(id,SEL,BOOL))[target methodForSelector:@selector(setFilled:)];
for(i=0;i<1000;i++){
  setter(targetList[i],@selector(setFilled:),YES);
}
```
Using methodForSelector: to circumvent dynamic binding saves most of the time required by messaging. However, the savings will be significant only where a particular message is repeated many times, as in the for loop shown above.
Note that `methodForSelector:` is provided by the Cocoa runtime system; it's not a feature of the Objective-C language itself.
