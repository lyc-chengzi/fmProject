//
//  CheckViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/5/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (strong,nonatomic,readonly) NSOperationQueue *queue;
@end
