//
//  Local_BaseDAO.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/5.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@class NSManagedObject;
@protocol Local_BaseDAODelegate <NSObject>

@required

//获得所有实体
-(NSArray *)getAllEntities:(NSString *) entityName;

//根据查询条件、排序获得实体集合
-(NSArray *)getAllEntities:(NSString *) entityName withPredicate:(NSPredicate *) predicate andOrderBy:(NSArray *) sortDes;

//清空本地实体表
-(void)deleteAllEntities:(NSString *) entityName;

//根据查询条件清空一些实体
-(void)deleteSomeEntities:(NSString *) entityName withPredicate:(NSPredicate *) predicate;

//根据查询条件返回第一个实体
-(NSManagedObject *)getFirstEntity:(NSString *) entityName withPredicate:(NSPredicate *) predicate;

@end

@interface Local_BaseDAO : NSObject<Local_BaseDAODelegate>
@property (weak, nonatomic) AppDelegate *appDelegate;


@end
