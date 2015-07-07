
缺少一种简单的用于查找first responder的方法。

## 通过keyboard return来dismiss keyboard
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
