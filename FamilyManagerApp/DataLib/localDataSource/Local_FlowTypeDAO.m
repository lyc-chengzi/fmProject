//
//  Local_FlowTypeDAO.m
//  FamilyManagerApp
//  ******本地 资金类型 sqlite 操作类******
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_FlowTypeDAO.h"
#import "Local_FlowType.h"
#import "AppConfiguration.h"

@implementation Local_FlowTypeDAO
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _entityName = @"Local_FlowType";
    }
    
    return self;
}

//一次添加多个FlowType
-(BOOL)addFlowTypes:(NSArray *) fis
{
    BOOL result = YES;
    for (int i = 0; i < fis.count; i++) {
        NSDictionary *flowType = (NSDictionary *)fis[i];
        Local_FlowType *ftEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Local_FlowType" inManagedObjectContext:self.appDelegate.managedObjectContext];
        ftEntity.flowTypeID = [flowType objectForKey:@"ID"];
        ftEntity.name = [flowType objectForKey:@"Name"];
        ftEntity.flowType = [flowType objectForKey:@"FlowType"];
        ftEntity.inOutType = [flowType objectForKey:@"InOutType"];
    }
    NSError *error;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        //NSLog(@"添加成功,添加的实体的feeItemName是：%@",fee.feeItemName);
        LYCLog(@"添加成功");
    }else
    {
        LYCLog(@"保存时出现错误：%@,%@",error,[error userInfo]);
    }
    return result;
}
//获取所有资金类型
-(NSArray *) getAllFlowTypes
{
    //排序条件
    NSSortDescriptor *orderFlowTypeID = [NSSortDescriptor sortDescriptorWithKey:@"flowTypeID" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:nil andOrderBy:@[orderFlowTypeID]];
}

//清空本地资金类型
-(void) deleteAllFlowType
{
    [self deleteAllEntities:_entityName];
}

//根据id查询一个对象
-(Local_FlowType *)getEntityByID:(int) flowTypeID
{
    NSString *selectStr = [NSString stringWithFormat:@"flowTypeID = %i",flowTypeID];
    //定义抓取条件
    NSPredicate * qcmd = [NSPredicate predicateWithFormat:selectStr];
    return (Local_FlowType *)[self getFirstEntity:_entityName withPredicate:qcmd];
}

@end
