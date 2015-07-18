
``` objc
-(void)swizzleViewDidLoad{
    [self swizzleViewDidLoad];

    NSLog(@"log something important");
}
//c function
void swizzeMethod(Class class,SEL originalSelector,SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
```


## using AOP
``` objc
+ (id<AspectToken>)aspect_hookSelector:(SEL)selector
                          withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;
- (id<AspectToken>)aspect_hookSelector:(SEL)selector
                      withOptions:(AspectOptions)options
                       usingBlock:(id)block
                            error:(NSError **)error;


@implementation AppDelegate (Logging)

+ (void)setupLogging
{
    NSDictionary *config = @{
        @"MainViewController": @{
            GLLoggingPageImpression: @"page imp - main page",
            GLLoggingTrackedEvents: @[
                @{
                    GLLoggingEventName: @"button one clicked",
                    GLLoggingEventSelectorName: @"buttonOneClicked:",
                    GLLoggingEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        [Logging logWithEventName:@"button one clicked"];
                    },
                },
                @{
                    GLLoggingEventName: @"button two clicked",
                    GLLoggingEventSelectorName: @"buttonTwoClicked:",
                    GLLoggingEventHandlerBlock: ^(id<AspectInfo> aspectInfo) {
                        [Logging logWithEventName:@"button two clicked"];
                    },
                },
           ],
        },

        @"DetailViewController": @{
            GLLoggingPageImpression: @"page imp - detail page",
        }
    };

    [AppDelegate setupWithConfiguration:config];
}

+ (void)setupWithConfiguration:(NSDictionary *)configs
{
    // Hook Page Impression
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                       NSString *className = NSStringFromClass([[aspectInfo instance] class]);
                                    [Logging logWithEventName:className];
                               } error:NULL];

    // Hook Events
    for (NSString *className in configs) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = configs[className];

        if (config[GLLoggingTrackedEvents]) {
            for (NSDictionary *event in config[GLLoggingTrackedEvents]) {
                SEL selekor = NSSelectorFromString(event[GLLoggingEventSelectorName]);
                AspectHandlerBlock block = event[GLLoggingEventHandlerBlock];

                [clazz aspect_hookSelector:selekor
                               withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    block(aspectInfo);
                                } error:NULL];

            }
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self setupLogging];
    return YES;
}
```

### Aspect使用场景
- add Logging and debugging
``` objc
[UIViewController aspect_hookSelector:@selector(viewWillAppear:)
  withOptions:AspectPositionAfter
  usingBlock:^(id<AspectInfo> aspectInfo,BOOL animated){
    NSLog(@"view controller %@ will appear animated:%tu",aspectInfo.instance,animated);
  } error:NULL];
```

- 检查某个方法是否被调用了
block内修改一个__block变量

- 对第三方库的代码添加处理程序
``` objc
- (void)pspdf_addWillDismissAction:(void (^)(void))action{
  [self aspect_hookSelector:@selector(viewWillDisappear:)
    withOptions:AspectPositionAfter
    usingBlock:^(id<AspectInfo> aspectInfo,BOOL animated){
      if([aspectInfo.instance isBeingDismissed]){
        action();
      }
    }]
}
```

- 修改方法的返回值
``` objc
[PSPDFDrawView aspect_hookSelector:@selector(shouldProcessTouches:withEvent:)
  withOptions:AspectPositionInstead
  usingBlock:^(id<AspectInfo> info,NSSet *touches,UIEvent *event){
    //call original
    BOOL processTouches;
    NSInvocation *invocation = info.originalInvocation;
    [invocation invoke];
    [invocation getReturnValue:&processTouches];

    if(processTouches){
      processTouches = pspdf_stylusShouldProcessTouches(touches,event);
      [invocation setReturnValue:&processTouches];
    }
  } error:NULL];
```
