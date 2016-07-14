//
//  BaiDuMapIndexViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/20.
//  Copyright (c) 2015年 LYC. All rights reserved.
//
/*
#import "BaiDuMapIndexViewController.h"
#import "AppConfiguration.h"

@interface BaiDuMapIndexViewController ()

@end

@implementation BaiDuMapIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bMap = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _bMap.zoomLevel = 16;
    _bmkLocationServer = [[BMKLocationService alloc] init];
    
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
    self.bMap.delegate = self;
    self.bmkLocationServer.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bmkLocationServer startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bMap viewWillDisappear];
    self.bMap.delegate = nil;
    
    [self.bmkLocationServer stopUserLocationService];
    self.bmkLocationServer.delegate = nil;
}
-(void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    LYCLog(@"map加载完成");
}

#pragma mark BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        [newAnnotationView setSelected:YES];
        return newAnnotationView;
    }
    return nil;
}

#pragma mark BMKLocationServiceDelegate
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;///< 当前位置
    if (location != nil) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = location.coordinate.latitude;
        coor.longitude = location.coordinate.longitude;
        annotation.coordinate = coor;
        annotation.title = @"您当前的位置";
        self.bMap.centerCoordinate = coor;
        [self.bMap addAnnotation:annotation];
        [self.bmkLocationServer stopUserLocationService];
    }else{
        [self showErrorInfoAlert:@"提示" andMessage:@"定位失败"];
    }
    
}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    [self showErrorInfoAlert:@"提示" andMessage:[NSString stringWithFormat:@"定位失败，%@",error]];
}

-(void)showErrorInfoAlert:(NSString *) title andMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end 
 
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


