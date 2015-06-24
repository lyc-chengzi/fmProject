//
//  NSObject+LYCDate.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LYCDate)
//获取当前时间的年份
+(NSInteger) getNowYear;
//获取当前时间的月份
+(NSInteger) getNowMonth;
//获取当前时间的天数
+(NSInteger) getNowDay;

//获取时间的年份
-(NSInteger) getDateYear;
//获取时间的月份
-(NSInteger) getDateMonth;
//获取时间的天数
-(NSInteger) getDateDay;

@end
