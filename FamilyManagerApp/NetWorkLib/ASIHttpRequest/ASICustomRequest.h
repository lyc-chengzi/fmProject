//
//  ASICustomRequest.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/29.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ASIHTTPRequest.h"


@interface ASICustomRequest :NSObject <ASIHTTPRequestDelegate>
+(void)testWebservice;
+(void)testRequestUrl;
@end
