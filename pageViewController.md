# code_snippets

## ViewController.m
//  ViewController.m
``` objective-c
#import "ViewController.h"
#import "DataViewController.h"

@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic,strong) UIPageViewController *pageController;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //add pageController as a child view controller

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];

    [self.pageController didMoveToParentViewController:self];


    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        CGRect frame = self.pageController.view.bounds;
        self.pageController.view.frame = CGRectInset(frame, 40, 40);
    }

    UIViewController *startingVc = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    [self.pageController setViewControllers:@[startingVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(UIPageViewController *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc]
    initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:nil];
        _pageController.delegate=self;
        _pageController.dataSource=self;
    }
    return _pageController;
}

-(NSArray *)dataArray{
    if(!_dataArray){
        NSDateFormatter *fmt = [NSDateFormatter new];
        _dataArray = [[fmt monthSymbols] copy];
    }
    return _dataArray;
}

#pragma mark - page view controller delegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (UIInterfaceOrientationIsPortrait(orientation)||[UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {

        //update viewControllers
        UIViewController *current = self.pageController.viewControllers[0];
        [self.pageController setViewControllers:@[current] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.pageController.doubleSided=NO;
        return UIPageViewControllerSpineLocationMin;
    }

    DataViewController *current = self.pageController.viewControllers[0];
    NSUInteger index = [self indexOfViewController:current];
    NSArray *viewControllers;
    if (index % 2 ==0) {
        UIViewController *next = [self viewControllerAtIndex:index+1 storyboard:self.storyboard];
        viewControllers = @[current,next];
    }else{
        UIViewController *previous=[self viewControllerAtIndex:index-1 storyboard:self.storyboard];
        viewControllers=@[previous,current];
    }
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    return UIPageViewControllerSpineLocationMid;
}

#pragma mark - page view controller datasource

-(NSUInteger)indexOfViewController:(DataViewController *)vc{
    //find by title
    return [self.dataArray indexOfObject:vc.data];
}
-(DataViewController *)viewControllerAtIndex:(NSUInteger)index
                                storyboard:(UIStoryboard *)storyboard{
    if (index>self.dataArray.count-1) {
        return nil;
    }
    DataViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    vc.data=self.dataArray[index];
    //NSLog(@"%@",self.dataArray[index]);
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    DataViewController *dvc = (DataViewController *)viewController;
    NSUInteger index = [self indexOfViewController:dvc];
    if (index<=0 || index==NSNotFound) {
        return nil;
    }
    index--;

    //create new DataViewController
    return [self viewControllerAtIndex:index storyboard:self.storyboard];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    DataViewController *dvc = (DataViewController *)viewController;
    NSUInteger index = [self indexOfViewController:dvc];
    if (index>=self.dataArray.count-1 || index==NSNotFound) {
        return nil;
    }
    index++;

    //create new DataViewController
    return [self viewControllerAtIndex:index storyboard:self.storyboard];
}

@end
```

## DataViewController.h

``` objective-c
#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController
@property (nonatomic,strong) NSString *data;
@end
```

## DataViewController.m

``` objective-c
#import "DataViewController.h"

@interface DataViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation DataViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.label.text=self.data;
}

@end
```
