//
//  CheckFlowTypeViewController.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/1.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKViewController.h"

@interface CheckFlowTypeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pv;
@property (weak, nonatomic) id<BKViewControllerDataSourceDelegate> delegate;

//已选择的记账类型
@property (strong, nonatomic, readonly) NSString *selectedKP;

@property (weak, nonatomic) NSMutableDictionary *dataSouce;

@end
