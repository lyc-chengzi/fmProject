//
//  ApplyMain_OLViewController.h
//  FamilyManagerApp
//  在线账单主页面
//  Created by ESI on 15/6/23.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyMain_OLViewController : UITableViewController
{
    dispatch_queue_t cQueue; //定义一个并行队列
}
//账单数据
@property (strong, nonatomic) NSMutableArray *applyMainList;
@end
