//
//  ApplyMainQueryModalViewController.m
//  FamilyManagerApp

//  账单高级查询弹出页

//  Created by ESI on 15/6/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "ApplyMainQueryModalViewController.h"
#import "AppConfiguration.h"

@interface ApplyMainQueryModalViewController ()

@end

@implementation ApplyMainQueryModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClose_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnOK_click:(id)sender {
    if (self.txtStartTime.text.length > 0 && self.txtEndTime.text.length > 0) {
        [self.queryDelegate setApplyMainQueryTime:self.txtStartTime.text andEndTime:self.txtEndTime.text];
        
        [self.queryDelegate willDismissViewController:self];
    }
    [self btnClose_click:sender];
    
}

- (IBAction)btnLastTwo_Click:(id)sender {
    [self getNeedDateMonthStr:-2];
}

- (IBAction)btnLast_Click:(id)sender {
    [self getNeedDateMonthStr:-1];
}

- (IBAction)btnCurrent_Click:(id)sender {
    [self getNeedDateMonthStr:0];
}

-(void) getNeedDateMonthStr:(int) months
{
    NSDate *now = [NSDate date];
    int year = (int)[now getDateYear];
    int month = (int)[now getDateMonth];
    int day = (int)[now getDateDay];
    
    int endYear = year;
    int endMonth = month;
    int endDay = day;
    
    month = month + months;
    if (month < 0) {
        month += 12;
        year --;
    }
    
    //查询上个月，只显示一个月
    if (months == -1) {
        endMonth = month;
        if (endMonth == 1 || endMonth == 3 || endMonth == 5 || endMonth == 7 || endMonth == 8 || endMonth == 10 || endMonth == 12) {
            endDay = 31;
        }
        else if (endMonth == 4 || endMonth == 6 || endMonth == 9 || endMonth == 11 ){
            endDay = 30;
        }
        else if (endMonth == 2 && endYear % 4 == 0) {
            endDay = 29;
        } else {
            endDay = 28;
        }
    }
    
    
    
    NSString *startmonthStr = month < 10 ? [NSString stringWithFormat:@"%d-0%d", year, month] : [NSString stringWithFormat:@"%d-%d", year, month];
    NSString *endmonthStr = month < 10 ? [NSString stringWithFormat:@"%d-0%d", endYear, endMonth] : [NSString stringWithFormat:@"%d-%d", endYear, endMonth];
    self.txtStartTime.text = [NSString stringWithFormat:@"%@-01", startmonthStr];
    self.txtEndTime.text = [NSString stringWithFormat:@"%@-%d", endmonthStr, endDay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
