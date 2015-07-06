//
//  Local_ApplyRecords.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Local_ApplyRecords : NSManagedObject

@property (nonatomic, retain) NSString * applyDate;
@property (nonatomic, retain) NSString * cAdd;
@property (nonatomic, retain) NSNumber * feeItemID;
@property (nonatomic, retain) NSString * feeItemName;
@property (nonatomic, retain) NSNumber * flowTypeID;
@property (nonatomic, retain) NSString * flowTypeName;
@property (nonatomic, retain) NSDecimalNumber * imoney;
@property (nonatomic, retain) NSString * inOutType;
@property (nonatomic, retain) NSNumber * inUserBankID;
@property (nonatomic, retain) NSString * keepType;
@property (nonatomic, retain) NSNumber * outUserBankID;
@property (nonatomic, retain) NSNumber * userID;

@end
