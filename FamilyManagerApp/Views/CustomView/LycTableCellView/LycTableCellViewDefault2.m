//
//  LycTableCellViewDefault.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LycTableCellViewDefault2.h"

@implementation LycTableCellViewDefault2

- (void)awakeFromNib {
    // Initialization code
    //NSLog(@"LycTableCellViewDefault执行awakeFromNib函数！");
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

@end
