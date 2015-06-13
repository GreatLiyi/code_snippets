//
//  ViewController.m
//  AttachmentAttributeStringSample
//
//  Created by zheng on 6/13/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import "ViewController.h"
@import ImageIO;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initTextView];
}

-(void)initTextView{
    NSString *s=@"price of Onions\t$2.34\nprice of Peppers\t$15.2\n";
    NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
    NSMutableArray *tabs = [NSMutableArray new];
    NSCharacterSet *terms = [NSTextTab columnTerminatorsForLocale:[NSLocale currentLocale]];
    NSTextTab *tab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight location:170 options:@{NSTabColumnTerminatorsAttributeName:terms}];
    [tabs addObject:tab];
    p.tabStops = tabs;
    p.firstLineHeadIndent = 20;
    NSMutableAttributedString *mas =
    [[NSMutableAttributedString alloc] initWithString:s
                                           attributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"GillSans" size:15],
                                                        NSParagraphStyleAttributeName:p
                                                        }];
    
    UIImage *onions = [self thumbnailOfImageWithName:@"onion" withExtension:@"jpg"];
    UIImage *peppers = [self thumbnailOfImageWithName:@"peppers" withExtension:@"jpg"];
    NSTextAttachment *onionAtt = [NSTextAttachment new];
    onionAtt.image=onions;
    onionAtt.bounds = CGRectMake(0, -5, onions.size.width, onions.size.height);
    NSAttributedString *onionAttChar = [NSAttributedString attributedStringWithAttachment:onionAtt];
    
    NSTextAttachment *pepperAttr = [NSTextAttachment new];
    pepperAttr.image=peppers;
    pepperAttr.bounds = CGRectMake(0, -5, peppers.size.width, peppers.size.height);
    NSAttributedString *pepperAttChar = [NSAttributedString attributedStringWithAttachment:pepperAttr];
    NSLog(@"mas.string = %@",mas.string);
    NSRange r = [mas.string rangeOfString:@"Onions"];
    [mas insertAttributedString:onionAttChar atIndex:r.location+r.length];
    r = [mas.string rangeOfString:@"Peppers"];
    [mas insertAttributedString:pepperAttChar atIndex:r.location+r.length];
    NSLog(@"mas.string = %@",mas.string);
    self.textView.attributedText = mas;
    [self.view addSubview:self.textView];
}

-(UIImage *)thumbnailOfImageWithName:(NSString *)name withExtension:(NSString *)extension{
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
    CGImageSourceRef src = CGImageSourceCreateWithURL((CFURLRef)url, nil);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat w = 20*scale;
    NSDictionary *d = @{
                   (NSString *)kCGImageSourceShouldAllowFloat:@YES,
                   (NSString *)kCGImageSourceCreateThumbnailWithTransform: @YES,
                   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
                   (NSString *)kCGImageSourceThumbnailMaxPixelSize: @(w)
                   };
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(src, 0, (CFDictionaryRef)d);
    return [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
}

@end
