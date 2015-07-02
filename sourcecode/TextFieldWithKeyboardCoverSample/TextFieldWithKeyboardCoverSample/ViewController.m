//
//  ViewController.m
//  TextFieldWithKeyboardCoverSample
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic,strong) UIView *fr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *slidingView;

@end

@implementation ViewController

#pragma mark - text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.fr=textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf{
    [tf resignFirstResponder];
    self.fr= nil;
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.topConstraint.constant = -100;
//    self.bottomConstraint.constant=-100;
//    [self.view layoutIfNeeded];
}

- (void)keyboardShow:(NSNotification *)notification{
    NSDictionary *d = [notification userInfo];
    CGRect keyboardRect = [ d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.slidingView convertRect:keyboardRect fromView:nil];
    CGRect f = self.fr.frame;
    
    NSNumber *duration = d[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = d[UIKeyboardAnimationCurveUserInfoKey];
    CGFloat gap = CGRectGetMaxY(f) + keyboardRect.size.height - self.slidingView.bounds.size.height + 5;
    NSLog(@"gap = %f",gap);
    //if keyboard.origin.y < firstResponder.frameMaxY,we need to modify constraits
    if(CGRectIntersectsRect(keyboardRect, f)){
    //if (keyboardRect.origin.y < CGRectGetMaxY(f)) {
        
        [UIView animateWithDuration:duration.floatValue
                              delay:0
                            options:curve.integerValue
                         animations:^{
                             self.topConstraint.constant = -gap;
                             self.bottomConstraint.constant = -gap;
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

@end
