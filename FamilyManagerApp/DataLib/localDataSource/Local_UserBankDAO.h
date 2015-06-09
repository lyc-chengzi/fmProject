//
//  Local_UserBankDAO.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/5.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Local_BaseDAO.h"
@class Local_UserBank;

@interface Local_UserBankDAO : Local_BaseDAO
{
    NSString *_entityName;
}

//一次添加多个userbank
-(BOOL)addUserBanks:(NSArray *) ubs toUserID:(int) userID;

//获取所有用户银行信息
-(NSArray *) getAllUserBanks;

//查询某一个用户下所有的银行信息
-(NSArray *)getUserBanksByUserID:(int) userID;

//清空本地用户银行信息(慎用)
-(void) deleteAllUserBanks;

//清空某一个用户银行信息
-(void) deleteAllUserBanksWithUserID:(int) userID;

//根据userBankID查询一个用户银行信息对象
-(Local_UserBank *)getEntityByID:(int) userBankID;
@end
