//
//  ItemCell.m
//  TableViewCustomCellSample
//
//  Created by zheng on 5/30/15.
//  Copyright (c) 2015 lifevc. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell()
@property (nonatomic,strong) UILabel *qtyLabel;
@end

@implementation ItemCell

-(UILabel *)qtyLabel{
    if (!_qtyLabel) {
        CGRect detailFrame =self.detailTextLabel.frame;
        CGPoint origin = CGPointMake(detailFrame.origin.x+detailFrame.size.width+20, detailFrame.origin.y);
        UILabel *qtyLabel = [UILabel new];
        qtyLabel.text=[NSString stringWithFormat:@"number=%lu",(unsigned long)self.qty];
        qtyLabel.tag=self.itemId;
        qtyLabel.font=self.detailTextLabel.font;
        [qtyLabel sizeToFit];
        qtyLabel.frame = (CGRect){origin,qtyLabel.frame.size};
        [self.contentView addSubview:qtyLabel];
        _qtyLabel=qtyLabel;
    }
    return _qtyLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        NSLog(@"init with style");
//        UIFont *f = [UIFont fontWithName:@"Hobbiton brush" size:15];
//        if (f) {
//            NSLog(@"font = %@",f);
//            self.textLabel.font = f;
//        }
        
    }
    
    //self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    return self;
}

/*
-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateEditingMask
        || state == UITableViewCellStateShowingDeleteConfirmationMask) {
        [self.qtyLabel setHidden:NO];
        
    }else{
        [self.qtyLabel setHidden:YES];
    }
    
}
 */

@end
