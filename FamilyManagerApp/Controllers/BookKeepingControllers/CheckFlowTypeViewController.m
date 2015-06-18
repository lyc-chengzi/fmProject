//
//  CheckFlowTypeViewController.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/1.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "CheckFlowTypeViewController.h"
#import "BKViewController.h"
#import "Local_FlowType.h"
#import "Local_FlowTypeDAO.h"
#import "AppConfiguration.h"

@interface CheckFlowTypeViewController ()
{
    NSArray *kpList;
}

@end

@implementation CheckFlowTypeViewController

@synthesize selectedKP = _selectedKP;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.pv setDelegate:self];
    [self.pv setDataSource:self];
    kpList = @[__fm_KPTypeOfCash_String,__fm_KPTypeOfBank_String,__fm_KPTypeOfChange_String];
    _selectedKP = kpList[0];
    //设置导航条
    self.navigationItem.title = @"选择资金类型";
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finishCheckFlowType)];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    self.dataSouce = [self.delegate performSelector:@selector(getTheFlowTypeList)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    LYCLog(@"选择资金类型页面收到内存警告！！！！");
    _selectedKP = nil;
}

//确定按钮点击事件
-(void)finishCheckFlowType
{
    Local_FlowType *ft = [[self.dataSouce objectForKey:_selectedKP] objectAtIndex:[self.pv selectedRowInComponent:1]];
    //设置选择的记账类型
    [self.delegate setTheKeepType:_selectedKP];
    //设置选择的资金类型
    [self.delegate setTheCheckFlowType:ft];
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

//**********************pickerView相关委托实现
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return [[self.dataSouce allKeys] count];
    }else{
        return [[self.dataSouce objectForKey:_selectedKP] count];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
}
//选择器显示内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        return kpList[row];
    } else {
        return [[[self.dataSouce objectForKey:_selectedKP] objectAtIndex:row] name];
    }
}
//选中事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _selectedKP = kpList[row];
        [self.pv reloadComponent:1];
        [self.pv selectRow:0 inComponent:1 animated:YES];
        
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 120;
    }else{
        return 200;
    }
}
//**********************pickerView相关委托实现
@end
