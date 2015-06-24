//
//  ApplySub_OLViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyMainViewModel, LycDialogView;

@interface ApplySub_OLViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSOperationQueue *_nsq;//队列
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic, readonly) NSMutableArray *applyMainList;
@property (strong, nonatomic, readonly) NSMutableArray *applySubList;
//当前显示的记账主信息
@property (weak, nonatomic) ApplyMainViewModel *currentMain;
//加载框
@property (strong, nonatomic) LycDialogView *dialogView;
@end
