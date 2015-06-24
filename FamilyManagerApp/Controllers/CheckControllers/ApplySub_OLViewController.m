//
//  ApplySub_OLViewController.m
//  FamilyManagerApp
//  在线账单明细页面
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ApplySub_OLViewController.h"
#import "AppConfiguration.h"

#import "LycDialogView.h"
#import "ApplyMainViewModel.h"
#import "ApplySubViewModel.h"

@implementation ApplySub_OLViewController

-(void)viewDidLoad
{
    //初始化等待框
    self.dialogView = [[LycDialogView alloc] initWithTitle:@"正在加载" andSuperView:self.view isModal:NO];
    _applySubList = [[NSMutableArray alloc] init];
    _nsq = [[NSOperationQueue alloc] init];
    
    //加载账单数据
    [self loadData];
}


//提示错误信息
-(void)showErrorInfo:(NSString *) text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//加载账单数据
-(void)loadData
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    //获得当前登陆用户
    NSInteger userID = [de integerForKey:__fm_defaultsKey_loginUser_ID];
    
    [self.dialogView showDialog:nil];
    NSString *serverIP = __fm_userDefaults_serverIP;
    NSURL *url = [NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_queryApplySub]];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30];
    request.HTTPMethod = @"POST";
    NSString *values = [NSString stringWithFormat:@"userID=%d&applymainid=%d",
                        (int)userID,
                        self.currentMain.applyMainID];
    request.HTTPBody = [values dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:_nsq completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            NSString *errorTitle;
            switch (connectionError.code) {
                case -1001:
                    errorTitle = @"连接服务器超时，请稍候再试";
                    break;
            }
            errorTitle = @"请求时出现错误，请稍候再试";
            [self showErrorInfo:errorTitle];
            [self.dialogView hideDialog];
        }
        else
        {
            //如果加载数据成功，将数据转化为数组
            ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:data requestName:@"加载记账子表数据"];
            if (aj.bSuccess == YES) {
                [_applySubList removeAllObjects];
                for (int i = 0; i < [aj.jsonObj count]; i++) {
                    NSDictionary *dic = [aj.jsonObj objectAtIndex:i];
                    ApplySubViewModel *sub = [[ApplySubViewModel alloc] init];
                    sub.applyMainID = (int)[dic[@"ApplyMainID"] integerValue];
                    sub.applySubID = (int)[dic[@"ApplySubID"] integerValue];
                    sub.cashOrBank = (int)[dic[@"CashOrBank"] integerValue];
                    sub.flowTypeID = (int)[dic[@"FlowTypeID"] integerValue];
                    sub.flowTypeName = [dic objectForKey:@"FlowTypeName"];
                    sub.inOutType = dic[@"InoutType"];
                    sub.feeItemID = (int)[dic[@"FeeItemID"] integerValue];
                    sub.feeItemName = [dic objectForKey:@"FeeItemName"];
                    sub.iMoney = dic[@"iMoney"];
                    sub.userBankID = (int)[dic[@"UserBankID"] integerValue];
                    sub.userBankName = dic[@"UserBankName"];
                    sub.bChange = dic[@"BChange"];
                    sub.inUserBankID = (int)[dic[@"InUserBankID"] integerValue];
                    sub.inUserBankName = [dic objectForKey:@"InUserBankName"];
                    sub.outUserBankID = (int)[dic[@"OutUserBankID"] integerValue];
                    sub.outUserBankName = [dic objectForKey:@"OutUserBankName"];
                    sub.cAdd = [dic objectForKey:@"CAdd"];
                    sub.createDate = [dic objectForKey:@"CreateDate"];
                    
                    [_applySubList addObject:sub];
                }
            }
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                [self.table reloadData];
                [self.dialogView hideDialog];
            }];
            [[NSOperationQueue mainQueue] addOperation:op];
        }
    }];
}

-(void)dealloc
{
    LYCLog(@"-----账单明细页被销毁-------   dealloc");
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base"];
    ApplySubViewModel *sub = _applySubList[indexPath.row];
    UILabel *lblCashOrBank = (UILabel *)[cell viewWithTag:1];
    UILabel *lblFlowType = (UILabel *)[cell viewWithTag:2];
    UILabel *lblInOut = (UILabel *)[cell viewWithTag:3];
    UILabel *lblMoney = (UILabel *)[cell viewWithTag:4];
    UILabel *lblAdd = (UILabel *)[cell viewWithTag:5];
    lblCashOrBank.text = sub.cashOrBank == 0 ? @"现金业务" : @"银行业务";
    lblFlowType.text = sub.flowTypeName;
    if ([sub.inOutType isEqualToString:@"in"]) {
        lblInOut.text = @"收入";
        lblInOut.textColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.4 alpha:1];
    }else if ([sub.inOutType isEqualToString:@"out"]) {
        lblInOut.text = [NSString stringWithFormat:@"支出-%@",sub.feeItemName];
        lblInOut.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    }else {
        lblInOut.text = sub.inOutType;
    }
    lblMoney.text = [NSString stringWithFormat:@"¥%@", sub.iMoney];
    lblAdd.text = sub.cAdd;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applySubList.count;
}
@end
