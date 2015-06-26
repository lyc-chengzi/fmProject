//
//  Local_UserBankDAO.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/5.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_UserBankDAO.h"
#import "Local_UserBank.h"
#import "AppConfiguration.h"

@implementation Local_UserBankDAO
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _entityName = @"Local_UserBank";
    }
    
    return self;
}

//一次添加多个FlowType
-(BOOL)addUserBanks:(NSArray *) ubs toUserID:(int) userID
{
    BOOL result = YES;
    
    for (int i = 0; i < ubs.count; i++) {
        NSDictionary *userBank = (NSDictionary *)ubs[i];
        Local_UserBank *ubEntity = [NSEntityDescription insertNewObjectForEntityForName:_entityName inManagedObjectContext:self.appDelegate.managedObjectContext];
        ubEntity.userID = [NSNumber numberWithInt:userID];
        ubEntity.userBankID = [userBank objectForKey:@"userBankID"];
        ubEntity.bankID = [userBank objectForKey:@"bankID"];
        ubEntity.bankName = [userBank objectForKey:@"bankName"];
        ubEntity.bankType = [userBank objectForKey:@"bankType"];
        ubEntity.money = [userBank objectForKey:@"money"];
        ubEntity.cardNo = [userBank objectForKey:@"cardNo"];
    }
    NSError *error;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        LYCLog(@"添加成功");
    }else
    {
        LYCLog(@"保存时出现错误：%@,%@",error,[error userInfo]);
    }
    return result;
}
//获取所有资金类型
-(NSArray *) getAllUserBanks
{
    //排序条件
    NSSortDescriptor *orderuserID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    NSSortDescriptor *orderbankID = [NSSortDescriptor sortDescriptorWithKey:@"bankID" ascending:YES];
    NSSortDescriptor *orderbankType = [NSSortDescriptor sortDescriptorWithKey:@"bankType" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:nil andOrderBy:@[orderuserID, orderbankID, orderbankType]];
}

//查询某一个用户下所有的银行信息
-(NSArray *)getUserBanksByUserID:(int) userID
{
    //查询条件
    NSPredicate *whereUserID = [NSPredicate predicateWithFormat:@"userID = %i",userID];

    //排序条件
    NSSortDescriptor *orderuserID = [NSSortDescriptor sortDescriptorWithKey:@"userID" ascending:YES];
    NSSortDescriptor *orderbankID = [NSSortDescriptor sortDescriptorWithKey:@"bankID" ascending:YES];
    NSSortDescriptor *orderbankType = [NSSortDescriptor sortDescriptorWithKey:@"bankType" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:whereUserID andOrderBy:@[orderuserID, orderbankID, orderbankType]];
}

//清空本地用户银行信息(慎用)
-(void) deleteAllUserBanks
{
    [self deleteAllEntities:_entityName];
}

//清空某一个用户银行信息
-(void) deleteAllUserBanksWithUserID:(int) userID
{
    //查询条件
    NSPredicate *whereUserID = [NSPredicate predicateWithFormat:@"userID = %i",userID];
    [self deleteSomeEntities:_entityName withPredicate:whereUserID];
}

//根据userBankID查询一个用户银行信息对象
-(Local_UserBank *)getEntityByID:(int) userBankID
{
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userBankID = %i",userBankID];
    return (Local_UserBank *)[self getFirstEntity:_entityName withPredicate:pre];
}


@end
