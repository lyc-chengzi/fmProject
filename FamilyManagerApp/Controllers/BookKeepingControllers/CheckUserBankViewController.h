//
//  CheckUserBankViewController.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKViewController.h"

@interface CheckUserBankViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *selectedPath;
}
@property (weak, nonatomic) id<BKViewControllerDataSourceDelegate> delegate;
@property (strong, nonatomic) NSArray *userBankList;
@property (weak, nonatomic) IBOutlet UITableView *table1;

@property (nonatomic, copy) NSString *inOutBankType;
@end
