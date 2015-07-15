//
//  CheckUserBankViewController.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/6.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "CheckUserBankViewController.h"
#import "Local_UserBank.h"
#import "Local_UserBankDAO.h"
#import "AppConfiguration.h"
#import "FMLoginUser.h"

@interface CheckUserBankViewController ()

@end

@implementation CheckUserBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okBtnClick)];
    [self.navigationItem setRightBarButtonItem:btnRight];
    
    Local_UserBankDAO *dao = [[Local_UserBankDAO alloc] init];
    NSInteger userID = [[FMLoginUser sharedFMLoginUser] loginUserID];
    self.userBankList = [dao getUserBanksByUserID:(int)userID];
    self.table1.dataSource = self;
    self.table1.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) okBtnClick
{
    Local_UserBank *ub = self.userBankList[selectedPath.row];
    if ([self.inOutBankType isEqualToString:@"in"]) {
        [self.delegate setTheInUserBank:ub];
    }
    else if ([self.inOutBankType isEqualToString:@"out"])
    {
        [self.delegate setTheOutUserBank:ub];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    NSInteger rowNo = indexPath.row;
    Local_UserBank *ub = [self.userBankList objectAtIndex:rowNo];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultid"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lblBankName = (UILabel *)[cell viewWithTag:1];
    UILabel *lblBankType = (UILabel *)[cell viewWithTag:2];
    UILabel *lblCardNo = (UILabel *)[cell viewWithTag:3];
    UILabel *lblMoney = (UILabel *)[cell viewWithTag:4];
    lblBankName.text = [ub bankName];
    lblBankType.text = [ub bankType];
    lblCardNo.text = [ub cardNo];
    lblMoney.text = [[ub money] stringValue];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedPath = indexPath;

}

@end
