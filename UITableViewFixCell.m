//
//  UITableViewFixCell.m
//  iosApp
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 lifevc. All rights reserved.
//

#import "UITableViewFixCell.h"

@implementation UITableViewFixCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Remove seperator inset
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [self setPreservesSuperviewLayoutMargins:NO];
        }
        // Explictly set your cell's layout margins
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
