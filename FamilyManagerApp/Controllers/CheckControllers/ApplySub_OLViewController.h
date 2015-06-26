//
//  ApplySub_OLViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyMainViewModel, LycDialogView;

@interface ApplySub_OLViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSOperationQueue *_nsq;//队列
    BOOL _isNeedLoadData;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collection;//账单主信息展示 collection
@property (weak, nonatomic) IBOutlet UITableView *table;//账单明细信息展示 table
@property (nonatomic) int currentMainIndex;//当前主信息的下标

@property (weak, nonatomic) NSMutableArray *applyMainList;
@property (strong, nonatomic, readonly) NSMutableArray *applySubList;
//当前显示的记账主信息
@property (weak, nonatomic) ApplyMainViewModel *currentMain;
//加载框
@property (strong, nonatomic) LycDialogView *dialogView;
@end
