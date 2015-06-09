//
//  DateFormatterHelper.m
//  Unit10
//
//  Created by ESI on 15/4/9.
//  Copyright (c) 2015年 ESI. All rights reserved.
//

#import "DateFormatterHelper.h"

@implementation DateFormatterHelper
 
+(NSDateFormatter*) getBasicFormatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    return df;
}

+(NSDateFormatter *) getShortDateFormatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    return df;
}
@end
