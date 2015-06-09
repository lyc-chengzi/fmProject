//
//  Local_FlowType.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Local_FlowType : NSManagedObject

@property (nonatomic, retain) NSNumber * flowTypeID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * flowType;
@property (nonatomic, retain) NSString * inOutType;

@end
