//
//  ViewController.m
//  TableViewEditInsertSample
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *numbers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.name= @"matt";
    self.numbers = [NSMutableArray arrayWithObject:@"(123)456789"];
    
    self.tableView.allowsSelection=NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark text field delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"text=%@",textField.text);
    //get containing cell
    UIView *v=textField;
    while(![v isKindOfClass:[UITableViewCell class]]){
        v=v.superview;
    }
    NSIndexPath *ip = [self.tableView indexPathForCell:(UITableViewCell *)v];
    if (ip.section==0) {
        self.name=textField.text;
    }else{
        self.numbers[ip.row] = textField.text;
    }
}

#pragma mark refresh control delegate
-(void)onRefresh:(id)sender{
    [self.refreshControl beginRefreshing];
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark data source method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.numbers.count;
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Name";
    }
    return @"Numbers";
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section==0) {
        cell.textField.text = self.name;
    }else{
        cell.textField.text=self.numbers[indexPath.row];
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    cell.textField.delegate=self;
    return cell;
}
#pragma mark delegate method

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==1;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return UITableViewCellEditingStyleNone;
    }
    NSInteger count = self.numbers.count;
    if (indexPath.row==count-1) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView endEditing:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.numbers removeObjectAtIndex:indexPath.row];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
        [self.numbers addObject:@""];
        
        [tableView beginUpdates];
        NSInteger count = self.numbers.count;
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:count-2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
        MyCell *cell = (MyCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:1]];
        [cell.textField becomeFirstResponder];
    }
}

#pragma mark rearrange items
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *s = self.numbers[sourceIndexPath.row];
    [self.numbers removeObjectAtIndex:sourceIndexPath.row];
    [self.numbers insertObject:s atIndex:destinationIndexPath.row];
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && self.numbers.count>0) {
        return YES;
    }
    return NO;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (proposedDestinationIndexPath.section==0) {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
    return proposedDestinationIndexPath;
}

@end
