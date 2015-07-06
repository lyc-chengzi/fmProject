//
//  Cache_ApplyRecordsDAO.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_BaseDAO.h"
@class Local_ApplyRecordsViewModel;

@interface Local_ApplyRecordsDAO : Local_BaseDAO
{
    NSString *_entityName;
}

//一次添加多个本地记账信息
-(BOOL)addApplyRecord:(Local_ApplyRecordsViewModel *) ar;

//获取所有本地记账信息
-(NSArray *) getAllApplyRecords;

//清空本地记账信息
-(void) deleteAllApplyRecords;

//清空某个用户的本地记账信息
-(void) deleteAllApplyRecordsByUserID:(int) userID;

//查询某一个用户下所有本地记账信息
-(NSArray *)getEntitiesByUserID:(int) userID;
//查询某一个用户下所有本地记账信息
-(NSArray *)getDictionariesByUserID:(int) userID;
@end
