//
//  MyCell.m
//  TableViewEditInsertSample
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
    self.textField.enabled=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super didTransitionToState:state];
    if (state == UITableViewCellStateShowingEditControlMask) {
        self.textField.enabled=YES;
    }else{
        self.textField.enabled=NO;
    }
}

@end
