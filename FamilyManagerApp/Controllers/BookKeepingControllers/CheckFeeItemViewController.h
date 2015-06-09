//
//  CheckFeeItemViewController.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/1.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKViewController.h"

@interface CheckFeeItemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table1;
@property (weak, nonatomic) id<BKViewControllerDataSourceDelegate> delegate;
@property (weak, nonatomic) NSArray *allFeeItems;

@property (strong, readonly, nonatomic) NSMutableArray *firstFeeItem;//一级费用科目
@property (strong, readonly, nonatomic) NSMutableArray *secondFeeItem;//二级费用科目
@property (strong, readonly, nonatomic) NSMutableDictionary *feeItemRelation;

@property (weak, nonatomic) IBOutlet UIButton *btnCancle;
- (IBAction)btnCancle_click:(id)sender;

@end
