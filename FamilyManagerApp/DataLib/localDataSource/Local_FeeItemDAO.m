//
//  Local_FeeItemDAO.m
//  FamilyManagerApp
//  ******本地 费用项目 sqlite 操作类******
//  Created by Lyc's computer on 15/5/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_FeeItemDAO.h"
#import "Local_FeeItem.h"
#import "API_FeeItem.h"

@implementation Local_FeeItemDAO

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _entityName = @"Local_FeeItem";
    }
    
    return self;
}

//一次添加多个FeeItem
-(BOOL)addFeeItems:(NSArray *) fis
{
    BOOL result = YES;
    
    for (int i = 0; i < fis.count; i++) {
        NSDictionary *fee = (NSDictionary *)fis[i];
        Local_FeeItem *feeEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Local_FeeItem" inManagedObjectContext:self.appDelegate.managedObjectContext];
        feeEntity.feeItemID = [fee objectForKey:@"FeeItemID"];
        feeEntity.feeItemName = [fee objectForKey:@"FeeItemName"];
        feeEntity.feeItemClassID = [fee objectForKey:@"FeeItemClassID"];
        feeEntity.isLast = [fee objectForKey:@"IsLast"];
        
        
    }
    NSError *error;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        //NSLog(@"添加成功,添加的实体的feeItemName是：%@",fee.feeItemName);
        NSLog(@"添加成功");
    }else
    {
        NSLog(@"保存时出现错误：%@,%@",error,[error userInfo]);
    }
    return result;
}

//获取所有费用科目
-(NSArray *) getAllFeeItems
{
    //排序条件
    NSSortDescriptor *orderFeeItemID = [NSSortDescriptor sortDescriptorWithKey:@"feeItemID" ascending:YES];
    return [self getAllEntities:_entityName withPredicate:nil andOrderBy:@[orderFeeItemID]];
}

//清空本地费用科目
-(void) deleteAllFeeItems
{
    [self deleteAllEntities:_entityName];
}

//根据id查询一个对象
-(Local_FeeItem *)getEntityByID:(int) feeItemID
{
    //定义抓取条件
    NSPredicate * qcmd = [NSPredicate predicateWithFormat:@"feeItemID = %i ", feeItemID];
    return (Local_FeeItem *)[self getFirstEntity:_entityName withPredicate:qcmd];
}
@end
