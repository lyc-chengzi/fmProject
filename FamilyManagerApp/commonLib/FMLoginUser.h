//
//  FMLoginUser.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLoginUser : NSObject
/**
 *  是否登陆
 */
@property (nonatomic, readonly) BOOL isLogin;

@property (nonatomic, readonly) NSInteger loginUserID;
@property (nonatomic, readonly, copy) NSString *loginUserName;
@property (nonatomic, readonly, copy) NSString *loginUserCode;

+(instancetype)sharedFMLoginUser;
@end
