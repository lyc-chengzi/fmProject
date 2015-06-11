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
#import "ApiJsonHelper.h"
#import "DateFormatterHelper.h"
#import "BKViewController.h"

#import "ASIFormDataRequest.h"
#import "Local_FeeItem.h"
#import "Local_FeeItemDAO.h"
#import "Local_FlowType.h"
#import "Local_FlowTypeDAO.h"
#import "Local_UserBankDAO.h"

@interface CheckViewController()<ASIHTTPRequestDelegate>
{
    //最后一次更新基础数据的时间
    NSString *_lastUpdateBaseDataTimeStr;
    NSMutableArray *_feeItemList;
    NSMutableData *_requestData;
    dispatch_queue_t sQueue;//串行队列
    dispatch_queue_t cQueue;//并发队列
}

@end

@implementation CheckViewController
@synthesize queue = _queue;

- (IBAction)btnLeft_click:(id)sender
{
    NSLog(@"打印内存泄漏情况：");
    NSLog(@"_B_controller:,%@",_B_controller);
    NSLog(@"_B_keepType:,%@",_B_keepType);
    NSLog(@"_B_checkFeeItem:,%@",_B_checkFeeItem);
    
    /*
    //NSLog(@"_B_flowTypeList:,%@",_B_flowTypeList);
    //NSLog(@"_B_feeItemList:,%@",_B_feeItemList);
    //NSLog(@"_B_checkFlowType:,%@",_B_checkFlowType);
    //NSLog(@"_B_applyDate:,%@",_B_applyDate);
    //NSLog(@"_B_tapGesture:,%@",_B_tapGesture);
    //NSLog(@"_B_applyRemark:,%@",_B_applyRemark);
    NSLog(@"_B_inUserBank:,%@",_B_inUserBank);
    NSLog(@"_B_outUserBank:,%@",_B_outUserBank);
     NSLog(@"_B_flowTypeController:,%@",_B_flowTypeController);
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
    //NSLog(@"viewDidLoad时的NSThread Info:%@",[NSThread currentThread]);
    self.tableView1.dataSource = self;
    _requestData = [[NSMutableData alloc] init];
    
    //1、检查是否需要更新基础数据
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if (app.isConnectNet == YES) {
        [self checkNeedUpdateBaseData];
    }
    else
    {
        NSLog(@"网络未连接，基础数据不会更新！");
    }
    
    
    //2、加载费用科目
    [self getFeeItemAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feeItemList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Local_FeeItem *fi = _feeItemList[indexPath.row];
    cell.textLabel.text = fi.feeItemName;
    return cell;
}





/*******************************************************检查是否需要更新基础数据**********************************************************************/

//检查是否需要更新主数据
-(void)checkNeedUpdateBaseData
{
    //新建一个线程，检查是否需要更新主数据
    NSString *requestFeeItemURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_getBaseUpdateTime];
    ASIFormDataRequest *requestUpdateTime= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestFeeItemURL]];
    requestUpdateTime.name = @"检查是否需要更新主数据";
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
        NSLog(@"请求到得时间点为：%@",[jh.jsonObj objectForKey:@"updateDate"]);
        NSDate *updateDate = [[DateFormatterHelper getBasicFormatter] dateFromString:[jh.jsonObj objectForKey:@"updateDate"]];
        //获取上次更新的时间
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _lastUpdateBaseDataTimeStr = [defaults stringForKey:__fm_defaults_baseDataGetDate_Key];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:0];
        //如果上次更新时间配置不存在，则默认为1970年
        if (_lastUpdateBaseDataTimeStr == nil || [_lastUpdateBaseDataTimeStr isEqualToString:@""]) {
            _lastUpdateBaseDataTimeStr = [[DateFormatterHelper getBasicFormatter] stringFromDate:lastUpdateTime];
        }
        else{
            //如果存在,将上次基础数据更新时间配置 转换为NSDate类型数据
            lastUpdateTime = [[DateFormatterHelper getBasicFormatter] dateFromString:_lastUpdateBaseDataTimeStr];
        }
        NSLog(@"%@",_lastUpdateBaseDataTimeStr);
        
        if ([lastUpdateTime compare:updateDate] == NSOrderedAscending) {
            NSLog(@"需要更新");
            //如果需要更新，调用 loadBaseData 方法
            [self loadBaseData];
        }else{
            NSLog(@"不需要更新");
        }
        
    }else{
        NSLog(@"接口返回false，请求失败");
    }
    
    //释放 ApiJsonHelper 的 jsonObj对象
    jh.jsonObj = nil;
}

/*******************************************************************下载基础数据*****************************************************************************/
//下载基础数据（费用科目、资金类型）到本地
-(void)loadBaseData
{
    
    //创建两个任务
    //第一个任务，下载资金类型
    NSString *requestURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_getFlowType];
    ASIFormDataRequest *requestFlowType= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
    requestFlowType.name = @"下载资金类型";
    requestFlowType.delegate = self;
    requestFlowType.shouldAttemptPersistentConnection = YES;
    requestFlowType.requestMethod = @"POST";
    [requestFlowType setDidFinishSelector:@selector(requestFlowTypeFinished:)];
    [requestFlowType setDidFailSelector:@selector(requestDidFailedCallBack:)];
    //添加到队列
    [self.queue addOperation:requestFlowType];
    
    //第二个任务，下载费用科目
    NSString *requestFeeItemURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_getFeeItem];
    ASIFormDataRequest *requestFeeItem= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestFeeItemURL]];
    requestFeeItem.name = @"下载费用科目";
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
        NSLog(@"资金类型添加后的数量：%lu",(unsigned long)[[lftDao getAllFlowTypes] count]);
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
        NSLog(@"费用科目添加后的数量：%lu",(unsigned long)[[lftDao getAllFeeItems] count]);
        
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
    
    NSLog(@"*******failed*******,result string is %@",errors);
    if (errors.code == 1) {
        NSLog(@"[%@]:网络未连接",requests.name);
    }
    if (errors.code == 2) {
        NSLog(@"[%@]:连接超时",requests.name);
    }
}

//获取所有费用科目
-(void)getFeeItemAction
{

    Local_FeeItemDAO *feeDao = [[Local_FeeItemDAO alloc] init];
    NSArray *feeList = [feeDao getAllFeeItems];
    if (feeList == nil) {
        NSLog(@"本地数据库中没有数据");
    }else {
        NSLog(@"一共有%d条数据！",(int)(feeList.count));
        _feeItemList = [feeList mutableCopy];
    }
}

@end
