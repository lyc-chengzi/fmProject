//
//  CheckViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/5/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Local_FeeItem.h"
#import "Local_FlowType.h"
#import "Local_UserBank.h"
@class BKViewController;

@interface CheckViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
- (IBAction)btnLeft_click:(id)sender;


@property (strong,nonatomic,readonly) NSOperationQueue *queue;




@property (weak, nonatomic) BKViewController *B_controller;

@property (weak, nonatomic) NSString *B_keepType;     //记账类型
@property (weak, nonatomic) Local_FeeItem *B_checkFeeItem;    //选择的费用科目


//＊／＊／＊／＊／＊排除了
/*
@property (nonatomic) CGFloat B_applyMoney;         //记账金额
@property (weak, nonatomic) UITapGestureRecognizer *B_tapGesture;//taptableview时隐藏键盘
@property (weak, nonatomic) NSString *B_applyDate;    //记账日期
@property (weak, nonatomic) NSString *B_applyRemark;//备注信息
@property (weak, nonatomic) Local_FlowType *B_checkFlowType;  //选择的资金类型

@property (weak, nonatomic) NSMutableDictionary *B_flowTypeList;  //资金类型列表，按记账类型标记好了
@property (weak, nonatomic) NSArray *B_feeItemList;               //费用科目列表，使用时再处理
 

 @property (weak, nonatomic) Local_UserBank *B_inUserBank;   //入账银行
 @property (weak, nonatomic) Local_UserBank *B_outUserBank;  //出账银行
 @property (weak, nonatomic) UIViewController *B_flowTypeController;   //资金类型选择页面

*/
@end
