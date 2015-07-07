//
//  ApplyMain_OLViewController.h
//  FamilyManagerApp
//  在线账单主页面
//  Created by ESI on 15/6/23.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyMainQueryModalViewController.h"
@class LycDialogView;

@interface ApplyMain_OLViewController : UIViewController<NSURLConnectionDelegate,UITableViewDataSource, UITableViewDelegate, ApplyMainQueryModalDelegate>
{
    dispatch_queue_t cQueue; //定义一个并行队列
    NSOperationQueue *_nsq;//队列
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic, readonly) UIRefreshControl *refreshControl;

//加载框
@property (strong, nonatomic) LycDialogView *dialogView;

//账单数据
@property (strong, nonatomic) NSMutableArray *applyMainList;

@property (strong, nonatomic) NSMutableDictionary *totalApply; //合计

@property (copy, nonatomic) NSString *starTime; //查询开始时间
@property (copy, nonatomic) NSString *endTime;  //查询结束时间
@end
