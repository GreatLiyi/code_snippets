## text field只允许输入小写字母

implement delegate method
- (BOOL)textField:(UITextField *)textField
  shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string{
  NSString *lc = [string lowercaseString];
  textField.text = [textField.text stringByReplacingCharactersInRange:range
    withString:lc];
  return NO;
}

//返回值NO，表示不接受本次输入
