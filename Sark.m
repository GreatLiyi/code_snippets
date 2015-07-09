#import <Foundation/Foundation.h>
@interface Sark : NSObject
@property (nonatomic,copy) NSString *name;
@end

@implementation Sark

//@synthesize name;
- (void)speak{
  NSLog(@"my name is %@",self.name);
}

@end

@interface Test:NSObject

@end

@implementation Test

- (instancetype)init{
  self = [super init];
  if(self){
    id cls = [Sark class];
    //void *obj = &cls;
    //[(__bridge id)obj speak];
    //[(__bridge id)(&cls) speak];
    [cls speak];
  }
  return self;
}

@end

int main(int argc,const char *argv[]){
  @autoreleasepool{
    [[Test alloc] init];
  }
  return 0;
}
