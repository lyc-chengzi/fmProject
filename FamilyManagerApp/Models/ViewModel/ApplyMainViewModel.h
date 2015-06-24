//
//  ApplyMainViewModel.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyMainViewModel : NSObject
@property (nonatomic) int applyMainID;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic) int applyUserID;
@property (nonatomic) int iYear;
@property (nonatomic) int iMonth;
@property (nonatomic) int iDay;
@property (nonatomic) NSDecimalNumber *applyOutMoney;
@property (nonatomic) NSDecimalNumber *applyInMoney;
@property (nonatomic) NSDecimalNumber *iNowCashMoney;
@end
