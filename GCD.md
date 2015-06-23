functions分类
http://codingobjc.com/blog/2013/05/07/gcdshi-yong-xiang-jie-xia-pian/
## creating and managing queues
- dispatch_get_main_queue
return the main queue. 该队列在调用main方法之前以主线程（main thread）的名义自动创建。使用下面其中一个（仅一个）方式来调用提交给main queue的block
 + calling dispatch_main
 + calling UIApplicationMain(iOS)
 + using a CFRunLoopRef on the main thread
与global concurrent queues类似，对main queue调用dispatch_suspend,dispatch_resume,dispatch_set_context等类似方法是没有效果的。
- dispatch_get_global_queue
- dispatch_queue_create(const char *label,dispatch_queue_attr_t attr);
label用来唯一标示queue，reverse-DNS naming style(com.example.myqueue) is recommended.
attr用来区分serial queue or concurrent queue,DISPATCH_QUEUE_SERIAL(or null)来创建serial queue; DISPATCH_QUEUE_CONCURRENT来创建concurrent queue。
- dispatch_set_target_queue(object,queue)
设置object queue的优先级=queue
还可以用来构建queue层次体系

### dispatch_after
用于在队列中定时执行任务。下面代码，在3秒后将block添加到主线程队列。
``` objc
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,3ull*NSEC_PER_SEC);
dispatch_after(time,dispatch_get_main_queue(),^{
  NSLog(@"waited at least three seconds");
  });
```
将dispatch_after作为一个精确的定时器使用是有问题的。
dispatch_time以起始时间和时间间隔来创建一个新的时间。

### dispatch group
用于创建一组队列。有时需要等dispatch队列中的所有任务完成，才能执行一个任务。如果是在一个串行队列里面，你只需将最后一个任务加到队列最后即可。如果使用的是并行队列或者多个队列，事情就没那么简单了。这种情况下可以使用dispatch group。
``` objc
dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group,queue,^{NSLog(@"block0");});
dispatch_group_async(group,queue,^{NSLog(@"block1");});
dispatch_group_async(group,queue,^{NSLog(@"block2");});
dispatch_group_notify(group,dispatch_get_main_queue(),^{NSLog(@"done");});
dispatch_release(group);
```
原理：dispatch group会监控任务的完成情况。当它发现所有任务都完成后，最终一个任务就会被加到队列上。
