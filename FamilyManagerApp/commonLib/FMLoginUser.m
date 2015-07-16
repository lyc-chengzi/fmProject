//
//  FMLoginUser.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "FMLoginUser.h"
#import "AppConfiguration.h"

@implementation FMLoginUser
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static FMLoginUser *instance;
    static dispatch_once_t onceToken;//默认为0
    
    //app生命周期中，只会被执行一次
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+(instancetype)sharedFMLoginUser
{
    return [[self alloc] init];
}

-(BOOL)isLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:__fm_defaultsKey_loginUser_Status];
}

-(NSInteger)loginUserID
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:__fm_defaultsKey_loginUser_ID];
}

-(NSString *)loginUserCode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:__fm_defaultsKey_loginUser_code];
}
-(NSString *)loginUserName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:__fm_defaultsKey_loginUser_name];
}
@end
