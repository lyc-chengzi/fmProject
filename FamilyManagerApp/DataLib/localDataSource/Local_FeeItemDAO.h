//
//  Local_FeeItemDAO.h
//  FamilyManagerApp
//  ******本地 费用项目 sqlite 操作类******
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Local_BaseDAO.h"
@class Local_FeeItem;
@interface Local_FeeItemDAO : Local_BaseDAO
{
    NSString *_entityName;
}

//一次添加多个FeeItem
-(BOOL)addFeeItems:(NSArray *) fis;

//获取所有费用科目
-(NSArray *) getAllFeeItems;

//清空本地费用科目
-(void) deleteAllFeeItems;

//根据名字查询一个对象
-(Local_FeeItem *)getEntityByID:(int) feeItemID;
@end
