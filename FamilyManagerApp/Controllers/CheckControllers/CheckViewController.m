//
//  CheckViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "CheckViewController.h"
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import "BKViewController.h"

#import "ASIFormDataRequest.h"
#import "Local_FeeItem.h"
#import "Local_FeeItemDAO.h"
#import "Local_FlowType.h"
#import "Local_FlowTypeDAO.h"
#import "Local_UserBankDAO.h"

#import "Local_ApplyRecordsViewModel.h"
#import "Local_ApplyRecordsDAO.h"
#import "FMLoginUser.h"

@interface CheckViewController()<ASIHTTPRequestDelegate>
{
    //最后一次更新基础数据的时间
    NSString *_lastUpdateBaseDataTimeStr;
    dispatch_queue_t sQueue;//串行队列
    dispatch_queue_t cQueue;//并发队列
    
    //table数据
    NSArray *tableData;
    
    BOOL syncing; //是否正在同步数据
}

@end

@implementation CheckViewController
@synthesize queue = _queue;

- (IBAction)btnLeft_click:(id)sender
{
    LYCLog(@"打印内存泄漏情况：");
    LYCLog(@"_B_controller:,%@",_B_controller);
    LYCLog(@"_B_keepType:,%@",_B_keepType);
    LYCLog(@"_B_checkFeeItem:,%@",_B_checkFeeItem);
    
    /*
    //LYCLog(@"_B_flowTypeList:,%@",_B_flowTypeList);
    //LYCLog(@"_B_feeItemList:,%@",_B_feeItemList);
    //LYCLog(@"_B_checkFlowType:,%@",_B_checkFlowType);
    //LYCLog(@"_B_applyDate:,%@",_B_applyDate);
    //LYCLog(@"_B_tapGesture:,%@",_B_tapGesture);
    //LYCLog(@"_B_applyRemark:,%@",_B_applyRemark);
    LYCLog(@"_B_inUserBank:,%@",_B_inUserBank);
    LYCLog(@"_B_outUserBank:,%@",_B_outUserBank);
     LYCLog(@"_B_flowTypeController:,%@",_B_flowTypeController);
     */
}
//property queue的get方法
-(NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    syncing = NO;
    
    //1、检查是否需要更新基础数据
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.isConnectNet == YES) {
        [self checkNeedUpdateBaseData];
    }
    else
    {
        LYCLog(@"网络未连接，基础数据不会更新！");
    }
    //从plist文件夹在table的数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CheckViewTableData" ofType:@"plist"];
    tableData = [NSArray arrayWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self performSelector:@selector(doTest) withObject:nil afterDelay:2];//测试--调试内存泄漏使用
}

-(void)doTest
{
    LYCLog(@"记账类型：%p",self.B_keepType);
    LYCLog(@"费用科目列表：%p",self.B_feeItemList);
    LYCLog(@"费用科目：%@", self.B_checkFeeItem);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableData.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[tableData objectAtIndex:section] objectForKey:@"sectionName"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[tableData objectAtIndex:section] objectForKey:@"sectionRows"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:1];
    NSDictionary *rowEntity = [[[tableData objectAtIndex:indexPath.section] objectForKey:@"sectionRows"] objectAtIndex:indexPath.row];
    lbl.text = rowEntity[@"rowTitle"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    NSDictionary *rowEntity = [[[tableData objectAtIndex:indexPath.section] objectForKey:@"sectionRows"] objectAtIndex:indexPath.row];
    //同步账单
    if (sectionNo == 1 && rowNo == 0) {
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
            //如果当前没有同步数据，则可以同步数据
            if (syncing == NO) {
                syncing = YES;
                //向服务器发送同步请求
                [self applySyncAction:result andUserID:(int)userID];
            }
        }
    }
    //清空本地账单
    else if (sectionNo == 1 && rowNo == 1){
        NSInteger userID = [self getLoginUserID];
        if (userID == 0) {
            return;
        }
        [self removeAllLocalApplyByUserID:(int)userID];
        [self showAlert:@"成功" andMessage:@"本地账单已经清空"];
    }
    //跳转页面
    else{
        if ([[rowEntity objectForKey:@"isPush"] boolValue] == YES) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:[rowEntity objectForKey:@"pushVCID"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)applySyncAction:(NSString *) jsonStr andUserID:(int) userID
{
    NSString *serverIP = __fm_userDefaults_serverIP;
    //创建两个任务
    //第一个任务，下载资金类型
    NSString *requestURL = [serverIP stringByAppendingString:__fm_apiPath_doSync];
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    _applySyncRequest = request;//将请求付给一个weak指针
    request.shouldAttemptPersistentConnection = YES;
    request.requestMethod = @"POST";
    [request addPostValue:jsonStr forKey:@"jsonStr"];
    [request setCompletionBlock:^{
        NSData *resultData = [_applySyncRequest responseData];
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

-(NSInteger) getLoginUserID
{
    FMLoginUser *loginUser = [FMLoginUser sharedFMLoginUser];
    
    BOOL isLogin = loginUser.isLogin;
    if (isLogin == NO) {
        [self showAlert:@"提示" andMessage:@"您还未登录，无法进行相关操作"];
        return 0;
    }
    NSInteger userID = loginUser.loginUserID;
    return userID;
}


/*******************************************************检查是否需要更新基础数据**********************************************************************/

//检查是否需要更新主数据
-(void)checkNeedUpdateBaseData
{
    //新建一个线程，检查是否需要更新主数据
    NSString *requestFeeItemURL = [__fm_userDefaults_serverIP stringByAppendingString:__fm_apiPath_getBaseUpdateTime];
    ASIFormDataRequest *requestUpdateTime= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestFeeItemURL]];
    //requestUpdateTime.name = @"检查是否需要更新主数据";
    requestUpdateTime.delegate = self;
    requestUpdateTime.shouldAttemptPersistentConnection = YES;
    requestUpdateTime.requestMethod = @"POST";
    [requestUpdateTime setDidFinishSelector:@selector(requestUpdateTimeDidFinished:)];
    [requestUpdateTime setDidFailSelector:@selector(requestDidFailedCallBack:)];
    //[requestFeeItem addDependency:requestFlowType]; 添加依赖，依赖的任务执行完成后才执行
    //添加到队列
    [self.queue addOperation:requestUpdateTime];

}

//检查是否需要更新基础数据 回调函数
-(void)requestUpdateTimeDidFinished:(ASIHTTPRequest *) request
{
    //获取api返回的数据
    NSData *resultData = [request responseData];
    //将data转换为json
    ApiJsonHelper *jh = [[ApiJsonHelper alloc] initWithData:resultData requestName:@"获取基础数据更新时间点"];
    if (jh.bSuccess) {
        //请求成功
        NSString *stringUpdateDate = [jh.jsonObj objectForKey:@"updateDate"];
        LYCLog(@"请求到得时间点为：%@", stringUpdateDate);
        NSDateFormatter *dateFormatter = [DateFormatterHelper getBasicFormatter];
        NSDate *updateDate = [dateFormatter dateFromString:stringUpdateDate];
        //获取上次更新的时间
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _lastUpdateBaseDataTimeStr = [defaults stringForKey:__fm_defaults_baseDataGetDate_Key];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:0];
        //如果上次更新时间配置不存在，则默认为1970年
        if (_lastUpdateBaseDataTimeStr == nil || [_lastUpdateBaseDataTimeStr isEqualToString:@""]) {
            _lastUpdateBaseDataTimeStr = [dateFormatter stringFromDate:lastUpdateTime];
        }
        else{
            //如果存在,将上次基础数据更新时间配置 转换为NSDate类型数据
            lastUpdateTime = [dateFormatter dateFromString:_lastUpdateBaseDataTimeStr];
        }
        
        if ([lastUpdateTime compare:updateDate] == NSOrderedAscending) {
            LYCLog(@"需要更新");
            //如果需要更新，调用 loadBaseData 方法
            [self loadBaseData];
        }else{
            LYCLog(@"不需要更新");
        }
        
    }else{
        LYCLog(@"接口返回false，请求失败");
    }
    
    //释放 ApiJsonHelper 的 jsonObj对象
    jh.jsonObj = nil;
}

/*******************************************************************下载基础数据*****************************************************************************/
//下载基础数据（费用科目、资金类型）到本地
-(void)loadBaseData
{
    NSString *serverIP = __fm_userDefaults_serverIP;
    //创建两个任务
    //第一个任务，下载资金类型
    NSString *requestURL = [serverIP stringByAppendingString:__fm_apiPath_getFlowType];
    ASIFormDataRequest *requestFlowType= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //requestFlowType.name = @"下载资金类型";
    requestFlowType.delegate = self;
    requestFlowType.shouldAttemptPersistentConnection = YES;
    requestFlowType.requestMethod = @"POST";
    [requestFlowType setDidFinishSelector:@selector(requestFlowTypeFinished:)];
    [requestFlowType setDidFailSelector:@selector(requestDidFailedCallBack:)];
    //添加到队列
    [self.queue addOperation:requestFlowType];
    
    //第二个任务，下载费用科目
    NSString *requestFeeItemURL = [serverIP stringByAppendingString:__fm_apiPath_getFeeItem];
    ASIFormDataRequest *requestFeeItem= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestFeeItemURL]];
    //requestFeeItem.name = @"下载费用科目";
    requestFeeItem.delegate = self;
    requestFeeItem.shouldAttemptPersistentConnection = YES;
    requestFeeItem.requestMethod = @"POST";
    [requestFeeItem setDidFinishSelector:@selector(requestFeeItemFinished:)];
    [requestFeeItem setDidFailSelector:@selector(requestDidFailedCallBack:)];
    [requestFeeItem addDependency:requestFlowType]; //添加依赖，依赖的任务执行完成后才执行
    //添加到队列
    [self.queue addOperation:requestFeeItem];
    
    
}

//资金类型下载完成回调函数
-(void)requestFlowTypeFinished:(ASIHTTPRequest *) requests
{
    NSData *data = [requests responseData];
    ApiJsonHelper *ah = [[ApiJsonHelper alloc] initWithData:data requestName:@"转换资金类型"];
    //如果请求成功，将数据保存到本地数据库
    if (ah.bSuccess) {
        Local_FlowTypeDAO *lftDao = [[Local_FlowTypeDAO alloc] init];
        [lftDao deleteAllFlowType];//先清空历史数据
        [lftDao addFlowTypes:ah.jsonObj];
        LYCLog(@"资金类型添加后的数量：%lu",(unsigned long)[[lftDao getAllFlowTypes] count]);
    }
    ah.jsonObj = nil;
}

//费用科目下载完成回调函数
-(void)requestFeeItemFinished:(ASIHTTPRequest *) requests
{
    NSData *data = [requests responseData];
    ApiJsonHelper *ah = [[ApiJsonHelper alloc] initWithData:data requestName:@"转换费用科目"];
    //如果请求成功，将数据保存到本地数据库
    if (ah.bSuccess) {
        Local_FeeItemDAO *lftDao = [[Local_FeeItemDAO alloc] init];
        [lftDao deleteAllFeeItems];//先清空历史数据
        [lftDao addFeeItems:ah.jsonObj];
        LYCLog(@"费用科目添加后的数量：%lu",(unsigned long)[[lftDao getAllFeeItems] count]);
        
        [self updateBaseDateGetDate];
    }
    ah.jsonObj = nil;
}


//更新基础数据下载时间为当前时间
-(void)updateBaseDateGetDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[DateFormatterHelper getBasicFormatter] stringFromDate:[NSDate date]] forKey:__fm_defaults_baseDataGetDate_Key];
}

//多线程下载基础数据错误回调函数
-(void)requestDidFailedCallBack:(ASIHTTPRequest *) requests
{
    NSError *errors = requests.error;
    
    LYCLog(@"*******failed*******,result string is %@",errors);
    if (errors.code == 1) {
        LYCLog(@"网络未连接");
    }
    if (errors.code == 2) {
        LYCLog(@"连接超时");
    }
}

-(void)showAlert:(NSString *) title andMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
