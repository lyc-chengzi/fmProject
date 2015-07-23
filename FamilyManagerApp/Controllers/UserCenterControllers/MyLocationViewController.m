//
//  MyLocationViewController.m
//  FamilyManagerApp
//  我的位置，视图控制器
//  Created by ESI on 15/7/16.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "MyLocationViewController.h"

#import "AppConfiguration.h"

@implementation MyLocationViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _clManager = [[CLLocationManager alloc] init];
    _clGeo = [[CLGeocoder alloc] init];
}

-(void)dealloc
{
    LYCLog(@"我的位置页面，内存释放 --- dealloc");
    [self.clManager stopUpdatingHeading];
}

/**
 *  开始定位按钮点击事件
 *
 *  @param sender 处罚点击事件的对象
 */
- (IBAction)btnBeginLocation_click:(id)sender {
    //如果定位功能可用
    if ([CLLocationManager locationServicesEnabled]) {
        if (__fm_IOSVersion_ios8Later) {
            [self.clManager requestWhenInUseAuthorization];
        }
        //设定定位精度，最佳精度
        self.clManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定距离过滤器为50米，移动50米更新一次
        self.clManager.distanceFilter = 50;
        self.clManager.delegate = self;
        
        //开始监听定位信息
        [self.clManager startUpdatingLocation];
    }else{
        LYCLog(@"无法使用定位功能");
    }
}

//成功获取位置信息后触发
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //获取最后一个定位数据
    CLLocation *location = [locations lastObject];
    //依次获取各个信息
    self.lblJD.text = [NSString stringWithFormat:@"%g",location.coordinate.latitude];
    self.lblWD.text = [NSString stringWithFormat:@"%g",location.coordinate.longitude];
    
    self.lblHeight.text = [NSString stringWithFormat:@"%g",location.altitude];
    self.lblSpeed.text = [NSString stringWithFormat:@"%g",location.speed];
    self.lblFX.text = [NSString stringWithFormat:@"%g",location.course];
    [self.clGeo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            LYCLog(@"反地理编码错误！");
        }
        else{
            CLPlacemark *place = [placemarks firstObject];
            self.lblAddress.text = place.name;
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    LYCLog(@"定位失败, %@",error);
}

@end
