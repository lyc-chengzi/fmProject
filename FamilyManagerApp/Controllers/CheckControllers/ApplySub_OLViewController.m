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
#import "LycApplySubCellAutoHeight.h"
#import "LycApplySubCell.h"

#define applySubCellDefaultHeight 120.0 //默认高度120
@implementation ApplySub_OLViewController

-(void)viewDidLoad
{
    //初始化等待框
    self.dialogView = [[LycDialogView alloc] initWithTitle:@"正在加载" andSuperView:self.view isModal:NO];
    _applySubList = [[NSMutableArray alloc] init];
    _nsq = [[NSOperationQueue alloc] init];
    _isNeedLoadData = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isNeedLoadData == YES) {
        //加载账单数据
        [self loadData];
    }
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
                    //给实体赋值
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
                    
                    LycApplySubCellAutoHeight *lycCell = [[LycApplySubCellAutoHeight alloc] init];
                    lycCell.applySubModel = sub;
                    [_applySubList addObject:lycCell];
                    
                    //计算cell的高度
                }
            }
            NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
                _isNeedLoadData = NO;
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


/*************************UITableView 代理设置************************/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LycApplySubCell *cell = [[LycApplySubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lycCell"];
    LycApplySubCellAutoHeight *cellFrame = _applySubList[indexPath.row];
    [cell setCellValue:cellFrame];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.applySubList.count == 0) {
        LYCLog(@"height-----44");
        return 44;
    }else {
        
        LycApplySubCellAutoHeight *lycCell = [self.applySubList objectAtIndex:indexPath.row];
        LYCLog(@"height-----%f",lycCell.cellHeight);
        return lycCell.cellHeight;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applySubList.count;
}

/*************************UICollectionView 代理设置************************/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.applyMainList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"applyMain";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ApplyMainViewModel *main = [self.applyMainList objectAtIndex:indexPath.row];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:1];
    UILabel *lblInMoney = (UILabel *)[cell viewWithTag:2];
    UILabel *lblOutMoney = (UILabel *)[cell viewWithTag:3];
    lblDate.text = main.applyDate;
    lblInMoney.text = [NSString stringWithFormat:@"收入: ¥%@",main.applyInMoney];
    lblOutMoney.text = [NSString stringWithFormat:@"支出: ¥%@",main.applyInMoney];
    
    return cell;
}
@end
