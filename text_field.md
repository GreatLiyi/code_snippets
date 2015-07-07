
缺少一种简单的用于查找first responder的方法。

## 通过keyboard return来dismiss keyboard
``` objc
implement delegate method
``` objc
- (BOOL)textFieldShouldReturn:(UITextField *)tf{
  [tf resignFirstResponder];
  return YES;
}
```

## 除了通过textFieldDelegate，notification之外，还可以通过target-action来处理事件。
``` objc
[textField addTarget:nil action:@selector(dummy:)
  forControlEvents:UIControlEventEditingDidEndOnExit];
```
给textField关联一个didEndOnExit事件处理方法后，return键直接dismiss keyboard

## 如何自定义text field menu
=======
## text field自定义menuItem
``` objc
textField.allowsEditingTextAttributes=YES;
//设置UIMenuController，添加一个menuItem。expand selector会首先到text field中找，然后到当前controller中找。
UIMenuItem *mi=[[UIMenuItem alloc] initWithTitle:@"expand"
  action:@selector(expand:)];
UIMenuController *mc = [UIMenuController sharedMenuController];
mc.menuItems = @[mi];
```
