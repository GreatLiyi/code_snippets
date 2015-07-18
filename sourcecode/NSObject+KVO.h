//
//  NSObject+KVO.h
//  KVOSample
//
//  Created by zheng on 7/17/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ObserverBlock)(id observedObject,NSString *key,id oldValue,id newValue);

@interface NSObject (KVO)
- (void)kvo_addObserver:(NSObject *)observer
                 forKey:(NSString *)key
             usingBlock:(ObserverBlock)block;
- (void)kvo_removeObserver:(NSObject *)observer forKey:(NSString *)key;
@end
