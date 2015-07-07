//
//  Cache_ApplyRecordsViewModel.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Local_ApplyRecordsViewModel : NSObject
@property (nonatomic, copy) NSString *applyID;
@property (nonatomic, strong) NSNumber * userID;
@property (nonatomic, copy) NSString * applyDate;
@property (nonatomic, copy) NSString * keepType;
@property (nonatomic, strong) NSNumber * flowTypeID;
@property (nonatomic, copy) NSString * flowTypeName;
@property (nonatomic, copy) NSString * inOutType;
@property (nonatomic, strong) NSNumber * feeItemID;
@property (nonatomic, copy) NSString * feeItemName;
@property (nonatomic, strong) NSDecimalNumber * imoney;
@property (nonatomic, strong) NSNumber * inUserBankID;
@property (nonatomic, strong) NSNumber * outUserBankID;
@property (nonatomic, copy) NSString * cAdd;
@end
