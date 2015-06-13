//
//  ViewController.m
//  UICollectionViewSample
//
//  Created by admin on 15/6/10.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *sectionData;
@property (nonatomic,strong) NSMutableArray *sectionNames;
@end

@implementation ViewController

-(void)initData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
    NSArray *cities = [content componentsSeparatedByString:@"\n"];
    cities = [cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *left=obj1;
        NSString *right =obj2;
        return [left compare:right];
    }];
    //NSLog(@"sorted cities=%@",cities);
    
    NSMutableArray *sectionNames = [NSMutableArray new];
    NSMutableArray *groupCities = [NSMutableArray new];
    NSString *previous=nil;
    for (NSString *item in cities) {
        if (!item.length) {
            continue;
        }
        NSString *firstLetter = [item substringToIndex:1].uppercaseString;
        if (![firstLetter isEqualToString:previous]) {
            previous = firstLetter;
            [sectionNames addObject:firstLetter];
            [groupCities addObject:[NSMutableArray new]];
        }
        
        [[groupCities lastObject] addObject:item];
    }
    self.sectionData=groupCities;
    self.sectionNames=sectionNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    //[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *items = self.sectionData[section];
    return items.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell.contentView.subviews.count) {
        //init uilabel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [cell.contentView addSubview:label];
    }
    UILabel *lab = (UILabel *)cell.contentView.subviews[0];
    lab.text = self.sectionData[indexPath.section][indexPath.item];
    [lab sizeToFit];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView * v= nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        if (![v.subviews count]) {
            [v addSubview:[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]];
        }
        UILabel *lab = (UILabel *)v.subviews[0];
        lab.text = self.sectionNames[indexPath.section];
        lab.textAlignment = NSTextAlignmentCenter;
        
        //v.backgroundColor = [UIColor lightGrayColor];
    }
    
    return v;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
    lab.text = (self.sectionData)[indexPath.section][indexPath.item];
    [lab sizeToFit];
    //CGSize size = lab.bounds.size;
    CGRect bounds = CGRectInset(lab.bounds, -10, 0);
    //NSLog(@"bounds=%@",NSStringFromCGRect(bounds));
    return bounds.size;
}

@end
