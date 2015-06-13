//
//  ViewController.m
//  TableViewCustomCellSample
//
//  Created by zheng on 5/30/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import "ViewController.h"
#import "EditableCell.h"
#define SUBTITLE_CELL @"itemCell"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionNames;
@property (nonatomic,strong) NSMutableArray *cityNamesWithGroup;
@end

@implementation ViewController

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    self.cityNamesWithGroup=groupCities;
    self.sectionNames=sectionNames;
}

-(void)refreshSectionNames{
    //NSMutableArray *marray = [NSMutableArray new];
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
    
    //[self.tableView registerNib:[UINib nibWithNibName:@"EditableCell" bundle:nil]  forCellReuseIdentifier:SUBTITLE_CELL];
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    
//    for (NSString *s in [UIFont familyNames]) {
//        NSLog(@"%@: %@",s,[UIFont fontNamesForFamilyName:s]);
//    }
    
}

#pragma mark uitextfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return NO;
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
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTITLE_CELL forIndexPath:indexPath];
    //cell.textLabel.text = self.cityNamesWithGroup[indexPath.section][indexPath.row];
    /*
    ItemCell *itemCell = (ItemCell *)cell;
    itemCell.itemId = indexPath.row+1;
    itemCell.qty = 1;
    return cell;
     */
    /*
    if (tableView.isEditing) {
        EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTITLE_CELL forIndexPath:indexPath];
        cell.textField.text = self.cityNamesWithGroup[indexPath.section][indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.textField.delegate=self;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTITLE_CELL forIndexPath:indexPath];
        cell.textLabel.text = self.cityNamesWithGroup[indexPath.section][indexPath.row];
        return cell;
    }
    */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SUBTITLE_CELL forIndexPath:indexPath];
    cell.textLabel.text = self.cityNamesWithGroup[indexPath.section][indexPath.row];
    UIFont *f = [UIFont fontWithName:@"Hobbiton Brushhand" size:18];
    if (f) {
        //NSLog(@"font = %@",f);
        cell.textLabel.font=f;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    return self.sectionNames[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionNames;
}

//-(BOOL)tableView:(UITableView *)tableView
//canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return indexPath.row==0;
//}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView endEditing:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *cities = self.cityNamesWithGroup[indexPath.section];
        [cities removeObjectAtIndex:indexPath.row];
        if (!cities.count) {
            //remove section
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
            [self.cityNamesWithGroup removeObjectAtIndex:indexPath.section];
            //remove section index
            [self.sectionNames removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        //update model
        NSMutableArray *cities = self.cityNamesWithGroup[indexPath.section];
        [cities addObject:@""];
        NSInteger ct = [cities count];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ct-1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ct-2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ct-1 inSection:indexPath.section]];
        //((ItemCell *)cell).text
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rc = [tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == rc-1) {
        return UITableViewCellEditingStyleInsert;
    }
    return self.editing?UITableViewCellEditingStyleDelete:UITableViewCellEditingStyleNone;
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
    //NSLog(@"select row %ld",(long)indexPath.row);
    
    //CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    //NSLog(@"rect=%@",NSStringFromCGRect(rect));
}

#pragma mark - rotation
-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    NSLog(@"trait collection did change");
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    NSLog(@"will transition to trait collection %@",newCollection);
}

-(void)viewWillTransitionToSize:(CGSize)size
      withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"view will transition to size");
}
@end
