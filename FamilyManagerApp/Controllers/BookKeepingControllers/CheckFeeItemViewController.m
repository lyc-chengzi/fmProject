//
//  CheckFeeItemViewController.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/1.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "CheckFeeItemViewController.h"
#import "AppConfiguration.h"
#import "Local_FeeItem.h"

@interface CheckFeeItemViewController ()
{

}

@end

@implementation CheckFeeItemViewController
{
    
}
@synthesize firstFeeItem = _firstFeeItem;
@synthesize feeItemRelation = _feeItemRelation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.view viewWithTag:101] setBackgroundColor:__fm_Global_color_blue];
    [[self.view viewWithTag:101] setAlpha:0.85];
    //处理数据
    _allFeeItems = [self.delegate getTheFeeItemList];
    _feeItemRelation = [[NSMutableDictionary alloc] init];
    _firstFeeItem = [[NSMutableArray alloc] init];
    //添加一级费用科目,将一级费用科目的ID作为字典的key
    for (int i = 0; i < _allFeeItems.count; i++) {
        Local_FeeItem *fi = _allFeeItems[i];
        if ([fi.feeItemClassID integerValue] == 0) {
            [_firstFeeItem addObject:fi];
            [_feeItemRelation setObject:[[NSMutableArray alloc] init] forKey:[NSString stringWithFormat:@"fid_%i",(int)[fi.feeItemID integerValue]]];
        }
    }
    
    //添加二级费用科目
    for (int i = 0; i < _allFeeItems.count; i++) {
        Local_FeeItem *fi = _allFeeItems[i];
        if ([fi.isLast integerValue] > 0) {
            [[_feeItemRelation objectForKey:[NSString stringWithFormat:@"fid_%i",(int)[fi.feeItemClassID integerValue]]] addObject:fi];
        }
    }
    
    
    self.table1.dataSource = self;
    self.table1.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    LYCLog(@"选择费用科目页面收到了内存赢告！！！");
}

- (IBAction)btnCancle_click:(id)sender {
    _firstFeeItem = nil;
    _secondFeeItem = nil;
    _feeItemRelation = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/***********************tableview代理设置**************************/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.firstFeeItem.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_firstFeeItem[section] feeItemName];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_feeItemRelation == nil) {
        return 0;
    }else{
        int fiID = (int)[[_firstFeeItem[section] feeItemID] integerValue];
        return (int)[[_feeItemRelation objectForKey:[NSString stringWithFormat:@"fid_%i",fiID]] count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *cellID = @"cid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    int fiID = (int)[[_firstFeeItem[section] feeItemID] integerValue];
    cell.textLabel.text = [[[_feeItemRelation objectForKey:[NSString stringWithFormat:@"fid_%i",fiID]] objectAtIndex:row] feeItemName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    int fiID = (int)[[_firstFeeItem[section] feeItemID] integerValue];
    [self.delegate setTheCheckFeeItem:[[_feeItemRelation objectForKey:[NSString stringWithFormat:@"fid_%i",fiID]] objectAtIndex:row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/***********************tableview代理设置**************************/



@end
