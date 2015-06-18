//
//  ReachabilityHelper.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ReachabilityHelper.h"
#import "Reachability.h"
#import "AppConfiguration.h"

@implementation ReachabilityHelper
// wifi是否连接
+(BOOL)isWiFiEnabled
{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        return YES;
    }else{
        return NO;
    }
}
// 3G/4G是否连接
+(BOOL)isWWANEnabled
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        return YES;
    }else{
        return NO;
    }
}
// 是否可以联网，wifi或者3G/4G
+(BOOL)isConnectInternet
{
    return [self isWiFiEnabled] || [self isWWANEnabled];
}


//示例代码，演示怎么获取网络连接状态，不可调用
-(void)demoFunc
{
    Reachability *reach = [Reachability reachabilityWithHostName:__fm_userDefaults_serverIP];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"不能访问网络");
            break;
        case ReachableViaWWAN:
            NSLog(@"使用3G/4G访问网络");
        case ReachableViaWiFi:
            NSLog(@"使用wifi访问网络");
    }
}

-(void)demoAddNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demoNotificationCallBack:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostName:__fm_userDefaults_serverIP];
    //让reach对象开启被监听状态
    [reach startNotifier];
}

-(void)demoNotificationCallBack:(NSNotification *) note
{
    //获取被监听的reach对象
    Reachability *reach = [note object];
    //获取网络状态
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"网络已经断开");
    }
}
@end
