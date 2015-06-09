//
//  API_FeeItem.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API_FeeItem : NSObject
@property (nonatomic, retain) NSNumber * FeeItemID;
@property (nonatomic, copy) NSString * FeeItemName;
@property (nonatomic, retain) NSNumber * FeeItemClassID;
@property (nonatomic, retain) NSNumber * IsLast;
@end

