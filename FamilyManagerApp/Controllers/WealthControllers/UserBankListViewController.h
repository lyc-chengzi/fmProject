//
//  UserBankListViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate, ASIFormDataRequest;

@interface UserBankListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic, readonly) AppDelegate *appDelegate;
@property (weak, nonatomic, readonly) ASIFormDataRequest *userBankRequest;

@property (strong, nonatomic, readonly) NSArray *userBankList;
@end
