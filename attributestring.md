## 计算attribute string的绘画区域
``` objective-c
CGRect r = [s boundingRectWithSize:CGSizeMake(320,1)
  options:NSStringDrawingUsesLineFragmentOrigin
  context:nil];
CGFloat result = ceil(r.size.height);
```
适用NSStringDrawingUsesLineFragmentOrigin会考虑多行的情况

## attribute name
https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/AttributedStrings/Articles/standardAttributes.html

## attributeString能做什么
