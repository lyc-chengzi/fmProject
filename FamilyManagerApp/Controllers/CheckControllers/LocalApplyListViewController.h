//
//  LocalApplyListViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/7.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;

@interface LocalApplyListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
typedef enum{
    LocalApplyRightButtonSync,
    LocalApplyRightButtonEdit
} LocalApplyRightButton;

@property (strong, nonatomic) NSMutableArray *applyList;//本地记账信息数据集合
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) ASIHTTPRequest *syncRequest;

@end
