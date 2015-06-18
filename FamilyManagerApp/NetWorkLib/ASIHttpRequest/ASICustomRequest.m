//
//  ASICustomRequest.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/5/29.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ASICustomRequest.h"
#import "AppConfiguration.h"
#import "ASIFormDataRequest.h"
@interface ASICustomRequest()
@end

@implementation ASICustomRequest
+(void)testWebservice
{
    //请求地址
    NSString *requestURL = [__fm_userDefaults_serverIP stringByAppendingString:@"/webservice/basedataservice.asmx"];
    
    //soap头信息
    NSString *soapHeader = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetFlowType xmlns=\"http://tempuri.org/BaseData/\"><typeID>0</typeID></GetFlowType></soap:Body></soap:Envelope>"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu",(unsigned long)[soapHeader length]]];
    [request addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/BaseData/GetFlowType"];    [request setRequestMethod:@"POST"];
    [request appendPostData:[soapHeader dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startSynchronous];
    NSLog(@"返回的数据为：%@",[request responseString]);
}
+(void)testRequestUrl
{
    NSString *requestURL = [__fm_userDefaults_serverIP stringByAppendingString:@"/baseDataapi/getFeeItemlist"];
    NSLog(@"requestUrl is %@",requestURL);
    ASIFormDataRequest *re= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    re.delegate = self;
    re.shouldAttemptPersistentConnection = YES;
    re.requestMethod = @"POST";
    [re setPostValue:@"nihao" forKey:@"par1"];
    [re setDidFinishSelector:@selector(requestdidFinished:)];
    [re setDidFailSelector:@selector(requestDidFailedCallBack:)];
    [re startSynchronous];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)requestdidFinished:(ASIHTTPRequest *) requests
{
    NSString *result = [requests responseString];
    NSLog(@"finished,result string is %@",result);
}

-(void)requestDidFailedCallBack:(ASIHTTPRequest *) requests
{
    NSError *errors = requests.error;
    NSLog(@"failed,result string is %@",errors);
}
@end
