//
//  Cache_ApplyRecordsDAO.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_ApplyRecordsDAO.h"
#import "AppConfiguration.h"

#import "Local_ApplyRecords.h"
#import "Local_ApplyRecordsViewModel.h"

@class Local_BaseDAO, Cache_ApplyRecords;

@implementation Local_ApplyRecordsDAO

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _entityName = @"Local_ApplyRecordsDAO";
    }
    
    return self;
}

//一次添加多个FeeItem
-(BOOL)addApplyRecord:(Local_ApplyRecordsViewModel *) ar
{
    BOOL result = YES;
    
    Local_ApplyRecords *carEntity = [NSEntityDescription insertNewObjectForEntityForName:_entityName inManagedObjectContext:self.appDelegate.managedObjectContext];
    carEntity.userID = ar.userID;
    carEntity.applyDate = ar.applyDate;
    carEntity.keepType = ar.keepType;
    carEntity.flowTypeID = ar.flowTypeID;
    carEntity.flowTypeName = ar.flowTypeName;
    carEntity.inOutType = ar.inOutType;
    carEntity.feeItemID = ar.feeItemID;
    carEntity.feeItemName = ar.feeItemName;
    carEntity.imoney = ar.imoney;
    carEntity.inUserBankID = ar.inUserBankID;
    carEntity.outUserBankID = ar.outUserBankID;
    carEntity.cAdd = ar.cAdd;
    
    NSError *error;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        LYCLog(@"添加成功");
    }else
    {
        LYCLog(@"保存时出现错误：%@,%@",error,[error userInfo]);
    }
    return result;
}

//获取所有本地记账信息
-(NSArray *) getAllApplyRecords
{
    //排序条件
    NSSortDescriptor *orderApplyDate = [NSSortDescriptor sortDescriptorWithKey:@"applyDate" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:nil andOrderBy:@[orderApplyDate]];
}

//清空本地记账信息
-(void) deleteAllApplyRecords
{
    [self deleteAllEntities:_entityName];
}

//清空某个用户的本地记账信息
-(void) deleteAllApplyRecordsByUserID:(int) userID
{
    //定义抓取条件
    NSPredicate * qcmd = [NSPredicate predicateWithFormat:@"userID = %d ", userID];
    [self deleteSomeEntities:_entityName withPredicate:qcmd];
}

//查询某一个用户下所有本地记账信息
-(NSArray *)getEntityByUserID:(int) userID
{
    //定义抓取条件
    NSPredicate * qcmd = [NSPredicate predicateWithFormat:@"userID = %d ", userID];
    //排序条件
    NSSortDescriptor *orderApplyDate = [NSSortDescriptor sortDescriptorWithKey:@"applyDate" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:qcmd andOrderBy:@[orderApplyDate]];
}
@end
