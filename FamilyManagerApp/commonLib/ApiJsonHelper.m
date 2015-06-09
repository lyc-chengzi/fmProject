//
//  ApiJsonHelper.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/31.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ApiJsonHelper.h"
#import "AppConfiguration.h"

@implementation ApiJsonHelper

//根据api返回的data，初始化json对象
//data:返回的数据
//reName:给此次转换起一个别名，可以为nil
-(instancetype) initWithData:(NSData *) data requestName:(NSString *) reName
{
    self = [super init];
    if (self) {
        NSString *tishi = @"本次操作:";
        if (reName) {
            tishi = [tishi stringByAppendingString:reName];
        }
        NSError *error;
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        //如果转换没有报错
        if (!error) {
            //将获得的json返回给相应属性
            BOOL isSuccess =[jsonResult objectForKey:__fm_apiJsonKey_bSuccess];
            _bSuccess = isSuccess;
            _message = [jsonResult objectForKey:__fm_apiJsonKey_message];
            _jsonObj = [jsonResult objectForKey:__fm_apiJsonKey_jsonObj];
        }else{
            NSLog(@"%@，在转换json数据时发生错误；%@", tishi, error);
        }
    }
    return self;
}
@end
