//
//  ReachabilityHelper.h
//  FamilyManagerApp
//
//  Created by ESI on 15/5/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//
/*
 
 
 }

 */

#import <Foundation/Foundation.h>

@interface ReachabilityHelper : NSObject
// wifi是否连接
+(BOOL)isWiFiEnabled;
// 3G/4G是否连接
+(BOOL)isWWANEnabled;
// 是否可以联网，wifi或者3G/4G
+(BOOL)isConnectInternet;

@end
