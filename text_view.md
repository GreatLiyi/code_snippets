如何获取当前光标位置滚动
在文本修改的事件中
``` objc
- (void)textViewDidChange:(UITextView *)textView{
  CGRect r = [textView caretRectForPosition:textview.selectedTextRange.end];
  [textView scrollRectToVisible:r animated:NO];
}
```
