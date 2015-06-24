//
//  NSObject+LYCDate.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "NSDate+LYCDate.h"

@implementation NSDate (LYCDate)
+(NSInteger) getNowYear
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:[NSDate date]];
    return [dc year];
}
+(NSInteger) getNowMonth
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:[NSDate date]];
    return [dc month];
}
+(NSInteger) getNowDay
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:[NSDate date]];
    return [dc day];
}

//获取时间的年份
-(NSInteger) getDateYear
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:self];
    return [dc year];
}
//获取时间的月份
-(NSInteger) getDateMonth
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:self];
    return [dc month];
}
//获取时间的天数
-(NSInteger) getDateDay
{
    //然后就可以从d中获取具体的年月日了；
    NSDateComponents * dc = [NSDate getDateComponents:self];
    return [dc day];
}

+(NSDateComponents *)getDateComponents:(NSDate *) date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    return d;
}

@end
