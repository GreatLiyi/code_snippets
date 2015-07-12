#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface  MessageForwarding: NSObject
- (void)sendMessage:(NSString *)word;
@end
@implementation MessageForwarding
- (void)sendMessage:(NSString *)word{
  NSLog(@"fast forwarding: send message = %@",word);
}
@end

@interface Message: NSObject
- (void)sendMessage:(NSString *)word;
@end

@implementation Message
/*
- (void)sendMessage:(NSString *)word{
  NSLog(@"normal way: send message = %@",word);
}
*/
//method resolution
/*
+ (BOOL)resolveInstanceMethod:(SEL)sel{
  if(sel == @selector(sendMessage:)){
    class_addMethod([self class],sel,imp_implementationWithBlock(^(id self,NSString *word){
      NSLog(@"normal way: send message = %@",word);
    }),"v@*");
  }
  return YES;
}
*/
- (id)forwardingTargetForSelector:(SEL)selector{
  if(selector == @selector(sendMessage:)){
    return [MessageForwarding new];
  }
  return nil;
}
@end



int main(){
  @autoreleasepool{
    Message *msg = [Message new];
    [msg sendMessage:@"Sam Lau"];
  }
  return 0;
}
