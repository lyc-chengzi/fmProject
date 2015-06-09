//
//  Local_UserBank.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Local_UserBank : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * userBankID;
@property (nonatomic, retain) NSNumber * bankID;
@property (nonatomic, retain) NSString * bankName;
@property (nonatomic, retain) NSString * bankType;
@property (nonatomic, retain) NSDecimalNumber * money;
@property (nonatomic, retain) NSString * cardNo;

@end
