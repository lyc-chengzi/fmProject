//
//  LycScrollCollectionViewCell.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/17.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LycScrollCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTItle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
-(void)setContents:(NSString *) title andImage:(UIImage *) img;
@end
