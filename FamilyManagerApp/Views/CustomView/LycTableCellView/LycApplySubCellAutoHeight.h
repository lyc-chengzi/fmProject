//
//  LycTableViewCellAutoHeight.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/25.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ApplySubViewModel;
@interface LycApplySubCellAutoHeight : NSObject
@property (strong, nonatomic) ApplySubViewModel *applySubModel;
@property (nonatomic) CGRect cashTypeFrame;//现金业务还是银行业务
@property (nonatomic) CGRect flowTypeFrame;//资金类型
@property (nonatomic) CGRect iMoneyFrame;//金额
@property (nonatomic) CGRect bankFrame1;//出账银行
@property (nonatomic) CGRect bankFrame2;//入账银行
@property (nonatomic) CGRect remarkFrame;//备注
@property (nonatomic) CGFloat cellHeight;//单元格高度
@end
