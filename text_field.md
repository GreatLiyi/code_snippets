
缺少一种简单的用于查找first responder的方法。

## 通过keyboard return来dismiss keyboard
``` objc
implement delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)tf{
  [tf resignFirstResponder];
  return YES;
}
```

## text field自定义menuItem
``` objc
textField.allowsEditingTextAttributes=YES;
//设置UIMenuController，添加一个menuItem。expand selector会首先到text field中找，然后到当前controller中找。
UIMenuItem *mi=[[UIMenuItem alloc] initWithTitle:@"expand"
  action:@selector(expand:)];
UIMenuController *mc = [UIMenuController sharedMenuController];
mc.menuItems = @[mi];
```
