//
//  ApplyMain_OLViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/23.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ApplyMain_OLViewController.h"
#import "AppConfiguration.h"

#import "LycDialogView.h"
#import "ApplyMainViewModel.h"
#import "ApplySub_OLViewController.h"

@interface ApplyMain_OLViewController ()
{
    BOOL _isNeedLoadData;//是否需要加载数据
}

@end

@implementation ApplyMain_OLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /******************一些初始化操作*******************/
    //初始化等待框
    self.dialogView = [[LycDialogView alloc] initWithTitle:@"正在加载" andSuperView:self.view isModal:NO];
    _applyMainList = [[NSMutableArray alloc] init];
    _nsq = [[NSOperationQueue alloc] init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    _isNeedLoadData = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    BOOL isLogin = [de boolForKey:__fm_defaultsKey_loginUser_Status];
    if (isLogin == NO) {
        [self showErrorInfo:@"您还未登陆，无法查看账单信息"];
        return;
    }
    //获得当前登陆用户
    NSInteger userID = [de integerForKey:__fm_defaultsKey_loginUser_ID];
    
    [self.dialogView showDialog:nil];
    NSString *serverIP = __fm_userDefaults_serverIP;
    NSURL *url = [NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_queryApplyMain]];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    request.HTTPMethod = @"POST";
    //默认加载当前月的数据
    NSDate *now = [NSDate date];
    int year = (int)[now getDateYear];
    int month = (int)[now getDateMonth];
    int day = (int)[now getDateDay];
    NSString *monthStr = month < 10 ? [NSString stringWithFormat:@"%d-0%d", year, month] : [NSString stringWithFormat:@"%d-%d", year, month];
    NSString *values = [NSString stringWithFormat:@"userID=%d&startTime=%@&endTime=%@",
                            (int)userID,
                            [NSString stringWithFormat:@"%@-01", monthStr],
                            [NSString stringWithFormat:@"%@-%d", monthStr, day]];
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
            ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:data requestName:@"加载记账主表数据"];
            if (aj.bSuccess == YES) {
                [_applyMainList removeAllObjects];
                for (int i = 0; i < [aj.jsonObj count]; i++) {
                    NSDictionary *dic = [aj.jsonObj objectAtIndex:i];
                    ApplyMainViewModel *apply = [[ApplyMainViewModel alloc] init];
                    apply.applyMainID = (int)[dic[@"ApplyMainID"] integerValue];
                    apply.applyUserID = (int)[dic[@"ApplyUserID"] integerValue];
                    apply.applyDate = dic[@"ApplyDate"];
                    apply.applyInMoney = dic[@"ApplyInMoney"];
                    apply.applyOutMoney = [dic objectForKey:@"ApplyOutMoney"];
                    apply.iYear = (int)[dic[@"iyear"] integerValue];
                    apply.iMonth = (int)[dic[@"imonth"] integerValue];
                    apply.iDay = (int)[dic[@"iday"] integerValue];
                    apply.iNowCashMoney = dic[@"iNowCashMoney"];
                    [_applyMainList addObject:apply];
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
    LYCLog(@"-----账单列表页被销毁-------   dealloc");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.applyMainList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"base" forIndexPath:indexPath];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:1];
    UILabel *lblIn = (UILabel *)[cell viewWithTag:2];
    UILabel *lblOut = (UILabel *)[cell viewWithTag:3];
    UILabel *lblCash = (UILabel *)[cell viewWithTag:4];
    ApplyMainViewModel *applyMain = self.applyMainList[indexPath.row];
    lblDate.text = applyMain.applyDate;
    lblIn.text = [NSString stringWithFormat:@"¥%@",applyMain.applyInMoney];
    lblOut.text = [NSString stringWithFormat:@"¥%@",applyMain.applyOutMoney];
    lblCash.text = [NSString stringWithFormat:@"现金:¥%@",applyMain.iNowCashMoney];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//点击账单信息跳转到明细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyMainViewModel *main = [self.applyMainList objectAtIndex:indexPath.row];
    ApplySub_OLViewController *solvc = [self.storyboard instantiateViewControllerWithIdentifier:@"applysub_olID"];
    solvc.currentMain = main;
    solvc.applyMainList = self.applyMainList;
    solvc.currentMainIndex = (int)indexPath.row;
    [self.navigationController pushViewController:solvc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*******************URLDelegate代理设置********************/


@end
