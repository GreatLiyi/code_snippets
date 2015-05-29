## pageIndicatorTintColor error
debug error info的时候发现`pageControl.pageIndicatorTintColor = [UIColor grayColor];`出错了。sof上搜索到iOS7有这个问题，不过我发现的crash是在8.1.2iphone6上。下面是sof上的针对iOS7的方案
``` objective-c
UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame: ...
pageControl.numberOfPages = 5;
pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
pageControl.pageIndicatorTintColor = [UIColor grayColor];
```
