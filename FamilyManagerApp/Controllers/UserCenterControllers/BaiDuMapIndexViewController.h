//
//  BaiDuMapIndexViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/20.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface BaiDuMapIndexViewController : UIViewController<BMKMapViewDelegate>
@property (strong, nonatomic) BMKMapView *bMap;
@end
