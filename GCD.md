functions分类
http://codingobjc.com/blog/2013/05/07/gcdshi-yong-xiang-jie-xia-pian/

## serial and concurrent
![serial and concurrent](images/GCD7–3_Relationship_of_Serial_Dispatch_Queue_Concurrent_Dispatch_Queue_and_threads.png)

## 内存管理
当一个block被加入到队列后, block会用dispatch_retain保持队列，这样block就拥有了队列的所有权。当block执行完毕后，会通过dispatch_release函数释放对队列的所有权。

## 系统提供的dispatch queue(main dispatch queue, global dispatch queue)
|Name | Type | Description|
|-----|------|------------|
|main dispatch queue    | serial dispatch queue | executed on the main thread |
|global dispatch queue(high priority)| concurrent dispatch queue|priority:high|
|global dispatch queue(default priority)|concurrent dispatch queue|p:normal|
|global dispatch queue(low priority)|concurrent dispatch queue|p:low|
|global dispatch queue(background)|concurrent dispatch queue|p:background|

``` objc
dispatch_queue_t globalHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
dispatch_queue_t mainQueue = dispatch_get_main_queue();
```

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
iOS 6.0以前需要手动释放dispatch object
``` objc
dispatch_release(queue);
dispatch_retain(queue);
```
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

### dispatch_barrier_async
传入的queue必须是concurrent,若传入serial or global dispatch queue,那么作用类似dispatch_async方法。
``` objc
dispatch_async(queue,blk0_for_reading);
dispatch_async(queue,blk1_for_reading);
dispatch_async(queue,blk2_for_reading);
dispatch_async(queue,blk3_for_reading);
dispatch_barrier_async(queue,blk_for_writing);
dispatch_async(queue,blk4_for_reading);
dispatch_async(queue,blk5_for_reading);
dispatch_async(queue,blk6_for_reading);
dispatch_async(queue,blk7_for_reading);
```
![execution with dispatch_barrier_async](images/Figure7–9Execution-with-the-dispatch_barrier_async-function.png)

### dispatch_sync
将一个任务添加到一个队列上，但是会等待添加到队列上的任务执行完毕才返回。

### dispatch_apply
将一个block多次添加到queue，然后等待所有任务完成。
``` objc
dispatch_async(queue,^{
  dispatch_apply([array count],queue,^(size_t index){
      NSLog(@"%zu: %@",index,[array objectAtIndex:index]);
  });
  dispatch_async(dispatch_get_main_queue(),^{
    NSLog(@"done");
  });
});
```

### dispatch_suspend, dispatch_resume

### dispatch semaphore信号量
对间隔时间较短的任务做并发控制
``` objc
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,1ull*NSEC_PER_SEC);
long result = dispatch_semaphore_wait(semaphore,time);
if(result ==0 ){
  //信号量大于等于1或者在超时时间前，信号量计数器变成大于等于1的数字。计数器自动减1。安全运行任务
}else{
  //信号量计数器是0，等待超时
}

//一个完整的例子
dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
NSMutableArray *array = [NSMutableArray new];
for(int i=0;i<10000;i++){
  dispatch_async(queue,^{
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
    //signal counter>=1,decrease by 1,continue
    [array addObject:[NSNumber numberWithInit:i]];

    dispatch_semaphore_signal(semaphore);
  });
}
dispatch_release(semaphore);
```


### dispatch_once
多线程安全
