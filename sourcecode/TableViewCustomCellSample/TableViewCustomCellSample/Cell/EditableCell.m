//
//  EditableCell.m
//  TableViewCustomCellSample
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 lifevc. All rights reserved.
//

#import "EditableCell.h"

@implementation EditableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didTransitionToState:(UITableViewCellStateMask)state{
    if (state == UITableViewCellStateEditingMask) {
//        self.textField.hidden=NO;
//        self.textField.enabled=YES;
//        self.textLabel.hidden=YES;
    }else if(state == UITableViewCellStateDefaultMask){
        //self.textField.enabled=NO;
//        self.textField.hidden=YES;
//        self.textLabel.hidden=NO;
    }
}

@end
