//
//  ApiJsonHelper.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/31.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiJsonHelper : NSObject

@property (nonatomic, readonly) BOOL bSuccess;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, strong) id jsonObj;

//根据api返回的data，初始化json对象
//data:返回的数据
//reName:给此次转换起一个别名，可以为nil
-(instancetype) initWithData:(NSData *) data requestName:(NSString *) reName;

@end
