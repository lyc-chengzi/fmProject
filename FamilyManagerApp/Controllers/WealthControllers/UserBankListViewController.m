//
//  UserBankListViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "UserBankListViewController.h"

#import "AppConfiguration.h"
#import "ApiJsonHelper.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

#import "Local_UserBank.h"
#import "Local_UserBankDAO.h"
#import "FMLoginUser.h"

@implementation UserBankListViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMLoginUser *loginUser = [FMLoginUser sharedFMLoginUser];
    NSInteger userID = loginUser.loginUserID;
    if (self.appDelegate.isConnectNet == YES) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",__fm_userDefaults_serverIP,__fm_apiPath_getUserBanks]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        _userBankRequest = request;
        request.shouldAttemptPersistentConnection = YES;
        [request setRequestMethod:@"POST"];
        [request setTimeOutSeconds:15];
        [request addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userid"];
        [request setCompletionBlock:^{
            NSData *data = [self.userBankRequest responseData];
            ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:data requestName:@"加载用户银行信息"];
            if (aj.bSuccess == YES) {
                _userBankList = aj.jsonObj;
                [self.tableView1 reloadData];
            }else{
                [self loadLoacl_userBankList:userID];
                [self.tableView1 reloadData];
            }
        }];
        [request setFailedBlock:^{
            LYCLog(@"获取服务器端数据失败，显示本地数据");
            [self loadLoacl_userBankList:userID];
            [self.tableView1 reloadData];
        }];
        [request startAsynchronous];
    }else{
        [self loadLoacl_userBankList:userID];
    }
    
    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
}

-(void)loadLoacl_userBankList:(NSInteger) userID
{
    Local_UserBankDAO *dao = [[Local_UserBankDAO alloc] init];
    NSArray *array = [dao getUserBanksByUserID:(int)userID];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <= array.count - 1; i++) {
        Local_UserBank *ub = array[i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[ub.userID,ub.userBankID,ub.bankID,ub.bankName,ub.bankType,ub.money,ub.cardNo] forKeys:@[@"userID", @"userBankID", @"bankID", @"bankName", @"bankType", @"money", @"cardNo"]];
        [newArray addObject:dic];
    }
    _userBankList = [newArray copy];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userBankList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary *dic = _userBankList[indexPath.row];
    NSString *money = [dic objectForKey:@"money"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  ¥ %@",[dic objectForKey:@"bankName"], money];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"bankType"], [dic objectForKey:@"cardNo"]];
    
    return cell;
}

-(void)dealloc
{
    
}
@end
