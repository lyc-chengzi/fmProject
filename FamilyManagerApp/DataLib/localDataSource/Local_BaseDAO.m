//
//  Local_BaseDAO.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/5.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "Local_BaseDAO.h"
#import <CoreData/CoreData.h>
#import "AppConfiguration.h"

@implementation Local_BaseDAO
@synthesize appDelegate = _appDelegate;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}
//获得所有实体
-(NSArray *)getAllEntities:(NSString *) entityName
{
    return [self getAllEntities:entityName withPredicate:nil andOrderBy:nil];
}

//根据查询条件、排序获得实体集合
-(NSArray *)getAllEntities:(NSString *) entityName withPredicate:(NSPredicate *) predicate andOrderBy:(NSArray *) sortDes
{
    //创建抓取数据的请求对象
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    
    //设置要抓取哪种类型的实体
    NSEntityDescription *des = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    //设置抓取实体
    [fetch setEntity:des];
    
    //排序
    if (sortDes) {
        [fetch setSortDescriptors: sortDes];
    }
    
    //查询条件
    if (predicate) {
        [fetch setPredicate:predicate];
    }
    
    NSError *error = nil;
    //执行查询请求
    NSArray *result = [self.appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    //如果没有数据返回nil
    if (error!=nil || result.count == 0) {
        return nil;
    }
    return result;
}

//清空本地实体表
-(void)deleteAllEntities:(NSString *) entityName
{
    NSArray *array = [self getAllEntities:entityName];
    for (int i = 0; i < array.count; i++) {
        //从上下文对象中删除该实体
        [self.appDelegate.managedObjectContext deleteObject:array[i]];
    }
    NSError *error;
    if (![self.appDelegate.managedObjectContext save:&error]) {
        LYCLog(@"全部删除实体：[%@]时出现错误：%@,%@", entityName, error, [error userInfo]);
    }
}

//根据查询条件清空一些实体
-(void)deleteSomeEntities:(NSString *) entityName withPredicate:(NSPredicate *) predicate
{
    NSArray *array = [self getAllEntities:entityName withPredicate:predicate andOrderBy:nil];
    for (int i = 0; i < array.count; i++) {
        //从上下文对象中删除该实体
        [self.appDelegate.managedObjectContext deleteObject:array[i]];
    }
    NSError *error;
    if (![self.appDelegate.managedObjectContext save:&error]) {
        LYCLog(@"全部删除实体：[%@]时出现错误：%@,%@", entityName, error, [error userInfo]);
    }
}

//根据查询条件返回第一个实体
-(NSManagedObject *)getFirstEntity:(NSString *) entityName withPredicate:(NSPredicate *) predicate
{
    NSArray *array = nil;
    array = [self getAllEntities:entityName withPredicate:predicate andOrderBy:nil];
    if (!array) {
        LYCLog(@"查询没有数据！");
        return nil;
    }else {
        return [array firstObject];
    }
}
@end
