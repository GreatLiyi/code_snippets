//
//  ViewController.m
//  HiddenViewWithAutoLayoutSample
//
//  Created by admin on 15/8/20.
//  Copyright (c) 2015年 zhengxb. All rights reserved.
//

#import "ViewController.h"
#import "Constraints-Utility.h"

@interface ViewController ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSArray *imagePathArray; //of string
@end

@implementation ViewController

-(void)awakeFromNib{
    //add hide button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(vc_hideControl:)];
}

- (NSArray *)imagePathArray{
    return @[@"a.jpg",
             @"b.jpg",
             @"c.jpg"];
}

-(void)loadView{
    //one imageview + one label
    UIControl *baseview = [[UIControl alloc] init];
    baseview.backgroundColor = [UIColor whiteColor];
    self.view = baseview;
    [baseview addTarget:self action:@selector(vc_tap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    PREPCONSTRAINTS(self.imageView);
    [baseview addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    self.label.numberOfLines=0;
    PREPCONSTRAINTS(self.label);
    self.label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-2*AQUA_INDENT;
    self.label.text = @"What you need to do is judiciously over-constrain your labels. Leave your existing constraints (10pts space to the other view) alone, but add another constraint: make your labels' left edges 10pts away from their superview's left edge with a non-required priority (the default high priority will probably work well).\nThen, when you want them to move left, remove the left view altogether. The mandatory 10pt constraint to the left view will disappear along with the view it relates to, and you'll be left with just a high-priority constraint that the labels be 10pts away from their superview. On the next layout pass, this should cause them to expand left until they fill the width of the superview but for your spacing around the edges.";
    [baseview addSubview:self.label];
    
    Pin(self.label, @"H:|-[view]-|");
    PinWithPriority(self.label, @"V:|-[view]",nil,750);
}

- (void)vc_hideControl:(id)sender{
    self.imageView.hidden=YES;
    RemoveConstraints(self.imageView.referencingConstraints);
    
    NSLog(@"%@",[self.imageView viewLayoutDescription]);
}

- (void)vc_tap:(id)sender{
    [self vc_loadNextImage];
    
    NSLog(@"%@",[self.imageView viewLayoutDescription]);
}

- (void)vc_loadNextImage{
    static int _imageIndex = 0;
    _imageIndex++;
    if (_imageIndex>= self.imagePathArray.count) {
        _imageIndex=0;
    }
    //remove old constraint
    NSLayoutConstraint *constraint = [self.imageView constraintNamed:@"image aspect" matchingView:self.imageView];
    [constraint remove];
    UIImage *image = [UIImage imageNamed:self.imagePathArray[_imageIndex]];
    self.imageView.image=image;
    self.imageView.hidden=NO;
    if (image) {
        CGFloat ratio = image.size.width/image.size.height;
        constraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:ratio constant:0.0];
        constraint.nametag = @"image aspect";
        [constraint install];
        
        NSString *imageConstraintTag = @"top imageview";
        NSArray *imageConstraints = [self.imageView constraintsNamed:imageConstraintTag matchingView:self.imageView];
        if (!imageConstraints.count) {
            PinWithPriority(self.imageView, @"H:|[view]|",imageConstraintTag,DEFAULT_LAYOUT_PRIORITY);
            UIView *topLayout = (UIView *)self.topLayoutGuide;
            InstallConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayout][view]" options:0 metrics:nil views:@{@"topLayout":topLayout,@"view":self.imageView}], DEFAULT_LAYOUT_PRIORITY, imageConstraintTag);
            
            InstallConstraints([NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageview]-(==indent)-[label]" options:0 metrics:@{@"indent":@(AQUA_INDENT)} views:@{@"imageview":self.imageView,@"label":self.label}], 1000, imageConstraintTag);
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self vc_loadNextImage];
}

@end
