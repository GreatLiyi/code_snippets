//
//  NSObject+KVO.m
//  KVOSample
//
//  Created by zheng on 7/17/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>


static NSString *kKVOAssocatedKey = @"kKVOAssocatedKey";
static NSString *kKVOClassNamePrefix= @"KVOClassPrefix_";


@interface ObservationInfo : NSObject
@property (nonatomic,weak) id observer;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) ObserverBlock block;
- (instancetype)initWithObserver:(id)observer
                             key:(NSString *)key
                           block:(ObserverBlock)block;
@end

@implementation ObservationInfo
- (instancetype)initWithObserver:(id)observer
                             key:(NSString *)key
                           block:(ObserverBlock)block{
    self = [super init];
    if (self) {
        _observer = observer;
        _key=[key copy];
        _block=[block copy];
    }
    return self;
}
- (NSString *)description{
    NSDictionary *dict = @{@"observer":self.observer,
                           @"key":self.key,
                           @"block":self.block};
    return [dict description];
}
@end

//get superclass
static Class kvo_Class(id obj, SEL _cmd){
    return class_getSuperclass(object_getClass(obj));
}

static NSString *getterFromSetter(NSString *setterName){
    NSString *name = [setterName substringWithRange:NSMakeRange(3, setterName.length-4)];
    NSString *firstLetter = [[name substringToIndex:1] lowercaseString];
    return [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
}

static NSString *setterFromGetter(NSString *getterName){
    NSString *firstLetter = [[getterName substringToIndex:1] uppercaseString];
    return [NSString stringWithFormat:@"set%@%@:",firstLetter,[getterName substringFromIndex:1]];
}

//make a setter method, in which we call super, then insert our own logic
static void kvo_setter(id self, SEL _cmd, id newValue){
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterFromSetter(setterName);
    if (!getterName) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"getter not found"
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    struct objc_super superclass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendSuperWrapper)(void *,SEL,id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperWrapper(&superclass,_cmd,newValue);
    
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)kKVOAssocatedKey);
    for (ObservationInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                info.block(self,info.key,oldValue,newValue);
            });
        }
    }
}

@implementation NSObject (KVO)

//make a new class from original, override class method
- (Class)makeKVOClassFromOriginalClass:(Class)originalClass
                              withName:(NSString *)originalName{
    NSString *clazzName = [NSString stringWithFormat:@"%@%@",kKVOClassNamePrefix,originalName];
    Class clazz = NSClassFromString(clazzName);
    if (clazz) {
        return clazz;
    }
    //Class originalClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClass, clazzName.UTF8String, 0);
    //change class selector
    Method instanceMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *typeEncoding = method_getTypeEncoding(instanceMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_Class, typeEncoding);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}


- (BOOL)hasOwnSelector:(SEL)selector{
    unsigned int count;
    Class clazz = object_getClass(self);
    Method *methodList = class_copyMethodList(clazz, &count);
    for (int i=0; i<count; i++) {
        Method m = methodList[i];
        SEL methodName = method_getName(m);
        if (methodName == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

- (void)kvo_addObserver:(NSObject *)observer
                    forKey:(NSString *)key
             usingBlock:(ObserverBlock)block{
    
    Class clazz = object_getClass(self);
    NSString *className = NSStringFromClass(clazz);
    if (![className hasPrefix:kKVOClassNamePrefix]) {
        clazz = [self makeKVOClassFromOriginalClass:clazz withName:className];
        object_setClass(self, clazz);
    }
    NSString *setterName = setterFromGetter(key);
    SEL setter = NSSelectorFromString(setterName);
    if (![self hasOwnSelector:setter]) {
        //override setter and invoke block with observers
        Method setterMethod = class_getInstanceMethod(clazz, setter);
        if (!setterMethod) {
            NSLog(@"clazz = %@,setter = %@,no setter method %@,superclass= %@",clazz,setterName,NSStringFromSelector(method_getName(setterMethod)),class_getSuperclass(clazz));
        }
        const char *methodTypes = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setter, (IMP)kvo_setter, methodTypes);
    }

    NSMutableArray *observers= objc_getAssociatedObject(self, (__bridge const void *)kKVOAssocatedKey);
    if (!observers) {
        observers = [NSMutableArray new];
        objc_setAssociatedObject(self, (__bridge const void *)kKVOAssocatedKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    ObservationInfo *info = [[ObservationInfo alloc] initWithObserver:observer key:key block:block];
    [observers addObject:info];
}

- (void)kvo_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)kKVOAssocatedKey);
    if (observers) {
        ObservationInfo *removedInfo;
        for (ObservationInfo *each in observers) {
            if (each.observer==observer && [each.key isEqualToString:key]) {
                removedInfo = each;
                break;
            }
        }
        [observers removeObject:removedInfo];
    }
}

@end
