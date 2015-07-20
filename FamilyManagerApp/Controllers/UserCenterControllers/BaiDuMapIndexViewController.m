//
//  BaiDuMapIndexViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/20.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "BaiDuMapIndexViewController.h"
#import "AppConfiguration.h"

@interface BaiDuMapIndexViewController ()

@end

@implementation BaiDuMapIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bMap = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bMap viewWillAppear];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bMap viewWillDisappear];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
