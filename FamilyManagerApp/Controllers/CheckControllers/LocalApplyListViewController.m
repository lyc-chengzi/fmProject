//
//  LocalApplyListViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/7.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LocalApplyListViewController.h"
#import "AppConfiguration.h"
#import "ASIFormDataRequest.h"

#import "Local_ApplyRecordsViewModel.h"
#import "Local_ApplyRecordsDAO.h"
@interface LocalApplyListViewController()
{
    BOOL syncing;
}
@end

@implementation LocalApplyListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    syncing = NO;
    //设置导航右侧按钮
    //1. 同步按钮
    UIBarButtonItem *btnSync = [[UIBarButtonItem alloc] initWithTitle:@"同步" style:UIBarButtonItemStyleBordered target:self action:@selector(syncLoaclApplyAction:)];
    //2. 编辑按钮
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editLoaclApplyAction:)];
    
    self.navigationItem.rightBarButtonItems = @[btnSync, btnEdit];
    
    //加载本地账单数据
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [de boolForKey:__fm_defaultsKey_loginUser_Status];
    if (isLogin == NO) {
        [self showAlert:@"提示" andMessage:@"您还未登录，无法同步账单"];
    }
    Local_ApplyRecordsDAO *dao = [[Local_ApplyRecordsDAO alloc] init];
    NSInteger userID = [self getLoginUserID];
    if (userID == 0) {
        return;
    }
    NSArray *array = [dao getEntitiesByUserID:(int)userID];
    _applyList = [array mutableCopy];
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
}

-(void)dealloc
{
    LYCLog(@"本地账单页面销毁");
}

-(void)showAlert:(NSString *) title andMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//同步导航按钮事件
-(void)syncLoaclApplyAction:(UIBarButtonItem *) btn
{
    if (self.tableView1.editing == YES) {
        [self showAlert:@"提示" andMessage:@"编辑状态下不可以同步账单！"];
        return;
    }
    NSInteger userID = [self getLoginUserID];
    if (userID == 0) {
        return;
    }
    Local_ApplyRecordsDAO *dao = [[Local_ApplyRecordsDAO alloc] init];
    NSArray *array = [dao getDictionariesByUserID:(int)userID];
    if (array.count == 0) {
        [self showAlert:@"提示" andMessage:@"本地账单为空，不需要同步"];
        return;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        [self showAlert:@"错误提示" andMessage:@"转换json出错了"];
    }
    else
    {
        NSString * result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (syncing == NO) {
            syncing = YES;
            //向服务器发送同步请求
            [self applySyncAction:result andUserID:(int)userID];
        }
    }

}

-(NSInteger) getLoginUserID
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [de boolForKey:__fm_defaultsKey_loginUser_Status];
    if (isLogin == NO) {
        [self showAlert:@"提示" andMessage:@"您还未登录，无法进行相关操作"];
        return 0;
    }
    NSInteger userID = [de integerForKey:__fm_defaultsKey_loginUser_ID];
    return userID;
}

-(void)applySyncAction:(NSString *) jsonStr andUserID:(int) userID
{
    NSString *serverIP = __fm_userDefaults_serverIP;
    //创建两个任务
    //第一个任务，下载资金类型
    NSString *requestURL = [serverIP stringByAppendingString:__fm_apiPath_doSync];
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    _syncRequest = request;//将请求付给一个weak指针
    request.shouldAttemptPersistentConnection = YES;
    request.requestMethod = @"POST";
    [request addPostValue:jsonStr forKey:@"jsonStr"];
    [request setCompletionBlock:^{
        NSData *resultData = [_syncRequest responseData];
        ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:resultData requestName:@"同步本地账单"];
        if (aj.bSuccess == YES) {
            
            //同步成功后清空当前用户的本地记账信息
            [self removeAllLocalApplyByUserID:userID];
            [self showAlert:@"成功" andMessage:@"账单同步成功，本地账单已经清空！"];
        } else{
            [self showAlert:@"失败" andMessage:@"账单同步失败"];
        }
        syncing = NO;
    }];
    
    [request setFailedBlock:^{
        [self showAlert:@"失败" andMessage:@"账单同步失败"];
        syncing = NO;
    }];
    [request startAsynchronous];
}

//清空本地账单
-(void)removeAllLocalApplyByUserID:(int) userID
{
    Local_ApplyRecordsDAO *dao = [[Local_ApplyRecordsDAO alloc] init];
    [dao deleteAllApplyRecordsByUserID:userID];
}

//编辑导航按钮事件
-(void)editLoaclApplyAction:(UIBarButtonItem *) btn
{
    //如果按钮文字是编辑，进入编辑状态
    if ([btn.title isEqualToString:@"编辑"]) {
        btn.title = @"完成";
        self.tableView1.editing = YES;
    }
    //否则，tableView显示非编辑状态
    else
    {
        btn.title = @"编辑";
        self.tableView1.editing = NO;
    }
        
}

/******************uitableview 代理实现*****************/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    Local_ApplyRecordsViewModel *lar = _applyList[indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",lar.applyDate, lar.flowTypeName];
        if(lar.feeItemName == nil){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@", [lar.imoney stringValue]];
        } else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@, %@", [lar.imoney stringValue], lar.feeItemName];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applyList.count;
}

//协议中定义的方法，返回表格的编辑状态
-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//移动完成时激发该方法
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //原数据的行号
    NSInteger sourceRowNo = sourceIndexPath.row;
    //目标数据的行号
    NSInteger desRowNo = destinationIndexPath.row;
    id targetObj = [_applyList objectAtIndex:sourceRowNo];
    [_applyList removeObjectAtIndex:sourceRowNo];
    [_applyList insertObject:targetObj atIndex:desRowNo];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Local_ApplyRecordsViewModel *lar = _applyList[indexPath.row];
        Local_ApplyRecordsDAO *dao = [[Local_ApplyRecordsDAO alloc] init];
        [dao deleteApplyByApplyID:lar.applyID];
        [_applyList removeObjectAtIndex:indexPath.row];
        [self.tableView1 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
