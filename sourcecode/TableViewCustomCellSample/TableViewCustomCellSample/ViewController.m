//
//  ViewController.m
//  TableViewCustomCellSample
//
//  Created by zheng on 5/30/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import "ViewController.h"
#import "ItemCell.h"
#define SUBTITLE_CELL @"itemCell"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *sectionNames;
@property (nonatomic,strong) NSArray *cityNamesWithGroup;
@end

@implementation ViewController

- (IBAction)editRow:(UIBarButtonItem *)sender {
    if ([self.tableView isEditing]) {
        //sender.title = @"Done";
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
    
}

-(void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    _tableView.delegate=self;
    _tableView.dataSource=self;
}

-(void)initData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
    NSArray *cities = [content componentsSeparatedByString:@"\n"];
    cities = [cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *left=obj1;
        NSString *right =obj2;
        return [left compare:right];
    }];
    NSLog(@"sorted cities=%@",cities);
    
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
    self.cityNamesWithGroup=groupCities;
    self.sectionNames=sectionNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor blueColor];
    
    [self initData];
    //self.tableView.sectionIndexBackgroundColor = [UIColor greenColor];
    //self.tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
    
    //self.tableView.allowsMultipleSelection=YES;
}

#pragma mark table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    NSArray *cities = self.cityNamesWithGroup[section];
    return cities.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTITLE_CELL forIndexPath:indexPath];
    cell.textLabel.text = self.cityNamesWithGroup[indexPath.section][indexPath.row];
    //cell.textLabel.text= [NSString stringWithFormat:@"this is label %ld",(long)indexPath.row];
    //cell.detailTextLabel.text = @"a quick brow fox jumps over the lazy dog";
    
    ItemCell *itemCell = (ItemCell *)cell;
    itemCell.itemId = indexPath.row+1;
    itemCell.qty = 1;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    return self.sectionNames[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionNames;
}

#pragma mark table view delegate
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        //cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        //cell.preservesSuperviewLayoutMargins=NO;
        //cell.separatorInset = UIEdgeInsetsMake(0, -20, 0, 100);
    }
    
    UIView *v=[UIView new];
    v.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    cell.selectedBackgroundView = v;
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return nil;
    }
    if ([tableView cellForRowAtIndexPath:indexPath].selected) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return nil;
    }
    return indexPath;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select row %ld",(long)indexPath.row);
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    NSLog(@"rect=%@",NSStringFromCGRect(rect));
}

@end