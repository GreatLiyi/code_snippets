
看看objccn.io上的一篇关于[行为驱动开发](http://objccn.io/issue-15-1/)的文章。以及一篇关于[TDD与BDD区别](http://blog.mattwynne.net/2012/11/20/tdd-vs-bdd/)的文章。

## 测试的步骤
- given 设置环境
- when 要测试的代码
- then 检查结果是否符合期望

## 公共类
创建一个测试基础类，将公用代码放在这里。新写的测试类集成该基础类。

## mocking
mock是一个对象，当调用方法时返回标准答案。使用mock我们可以将待测试行为与其他行为（因为有依赖）隔离开。使用的mock框架是OCMock。
mock用来管理一个对象的所有依赖项。这样，我们在隔离情况下，测试这个类的行为。不过，这样也有一个明显的缺点：就是当我们修改了类后，其他依赖于这个类的测试不会自动失败。总体来说也是好处多余坏处。
预防过度mock。哪些对象适合mock？

## 有状态和无状态
app还是需要有状态的，这样就带来了复杂的状态管理问题。
core data的代码如何测试？在公用的TestCase中，-setup方法中创建managedObjectContext，保证每次调用都使用的是一个新的context。

## 测试异步代码
异步代码的测试主要问题是隔离。另外，我们很难确定下一个测试什么时候开始。一个解决方案是使用dispatch_group

wwdc 2014介绍了一种方法来解决这个问题：expectation。步骤是这样的：
``` objc
//make expectation
XCTestExpectation *expectation = [self expectationWithDescription:@"finished processing"];

//call async method
APLParseOperation *op = [[APLParseOperation alloc] initWithData:... withBlock:^{
  [expectation fullfill];
}];
//wait
[self waitForExpectationsWithTimeout:2 handler:nil];

//assert
XCTAssertEqual(op.parsedEarthquakes.count,55);
```

## 测试与服务的交互

## 测试性能
- measureBlock:
- measureMetrics:automaticallyStartMeasuring:withBlock:
- startMeasuring
- stopMeasuring

## 自动测试的好处
- 使重构更简单
- 避免代码恶化
- 提供了可执行的说明和文档
- 减少了创建软件的时间
- 降低了创建软件的代价
## 关于测试的优秀实践 FIRST
- fast 经常被执行
- isolated 不依赖外部因素或其他测试的结果
- repeatable 每次运行都产生相同的结果
- self-verifying 包括断言，不需要人为干预
- timely 测试应该和生产代码一同书写
