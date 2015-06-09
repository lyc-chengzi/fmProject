//
//  Local_FlowTypeDAO.h
//  FamilyManagerApp
//  ******本地 资金类型 sqlite 操作类******
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Local_BaseDAO.h"
@class Local_FlowType;

@interface Local_FlowTypeDAO : Local_BaseDAO
{
    NSString *_entityName;
}

//一次添加多个flowType
-(BOOL)addFlowTypes:(NSArray *) fis;

//获取所有资金类型
-(NSArray *) getAllFlowTypes;

//清空本地资金类型
-(void) deleteAllFlowType;

//根据id查询一个对象
-(Local_FlowType *)getEntityByID:(int) flowTypeID;
@end
