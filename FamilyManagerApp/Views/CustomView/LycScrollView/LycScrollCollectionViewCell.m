//
//  LycScrollCollectionViewCell.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/17.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LycScrollCollectionViewCell.h"

@implementation LycScrollCollectionViewCell

-(void)setContents:(NSString *) title andImage:(UIImage *) img
{
    self.lblTItle.text = title;
    self.imgIcon.image = img;
}

@end
