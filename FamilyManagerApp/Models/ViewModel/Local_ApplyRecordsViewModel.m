//
//  Cache_ApplyRecordsViewModel.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_ApplyRecordsViewModel.h"

@implementation Local_ApplyRecordsViewModel
-(instancetype)init
{
    self = [super init];
    if (self) {
        NSNumber *zero = [NSNumber numberWithInt:0];
        self.userID = zero;
        self.flowTypeID = zero;
        self.feeItemID = zero;
        self.imoney = [NSDecimalNumber decimalNumberWithString:@"0"];
        self.inUserBankID = zero;
        self.outUserBankID = zero;
    }
    return self;
}
@end
