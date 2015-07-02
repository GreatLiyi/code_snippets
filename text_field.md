
缺少一种简单的用于查找first responder的方法。

## 通过keyboard return来dismiss keyboard
implement delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)tf{
  [tf resignFirstResponder];
  return YES;
}
