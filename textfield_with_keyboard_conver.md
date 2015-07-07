## textfield被keyboard覆盖的情况
解决方案：首先将textfield放在一个container中，container用约束定位，其中的toplayout和bottomlayout添加outlet。在keyboard出现的时候，判断是否与当前的first responder相交了（通过高度或者cgrectInsectRect方法）。若相交了，那么算出一个偏移量，将container约束值偏移。偏移约束的方式需要使用autolayout。

关键代码
``` objc
//delegate method, 保留first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.fr=textField;
}
//delegate method, 响应return
- (BOOL)textFieldShouldReturn:(UITextField *)tf{
    [tf resignFirstResponder];
    self.fr= nil;
    return YES;
}

- (void)viewDidLoad{
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)ntf{
  NSDictionary *d = [ntf userInfo];
  CGRect keyboardRect = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  //转换为slidingView中的坐标
  keyboardRect = [self.slidingView convertRect:keyboardRect fromView:nil];
  //first responder frame
  CGRect f = self.fr.frame;
  //get keyboard animation info
  NSNumber *duration = d[UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = d[UIKeyboardAnimationCurveUserInfoKey];
  //输入元素的高度+keyboard高度-slidingView的高度 = 需要偏移量
  CGFloat gap = CGRectGetMaxY(f) + keyboardRect.size.height - self.slidingView.bounds.size.height + 5;

  if(CGRectIntersectsRect(keyboardRect,f)){
    [UIView animateWithDuration:duration.floatValue
      delay:0
      options:curve.integerValue
      animations:^{
        self.topConstraint.constant = -gap;
        self.bottomConstraint.constant = -gap;
        //relayout
        [self.view layoutIfNeeded];
      } completion:nil];
  }
}

- (void)keyboardHide:(NSNotification *)notification{
    NSDictionary *d = [notification userInfo];
    NSNumber *duration = d[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = d[UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:duration.floatValue
                          delay:0
                        options:curve.integerValue animations:^{
                            self.topConstraint.constant = 0;
                            self.bottomConstraint.constant = 0;
                            [self.view layoutIfNeeded];
                        } completion:nil];
}
```
