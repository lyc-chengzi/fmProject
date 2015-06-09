//
//  Local_FeeItem.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Local_FeeItem : NSManagedObject

@property (nonatomic, retain) NSNumber * feeItemID;
@property (nonatomic, retain) NSString * feeItemName;
@property (nonatomic, retain) NSNumber * feeItemClassID;
@property (nonatomic, retain) NSNumber * isLast;

@end
