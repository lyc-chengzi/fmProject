//
//  MyLocationViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/16.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocationViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblJD;
@property (weak, nonatomic) IBOutlet UILabel *lblWD;
@property (weak, nonatomic) IBOutlet UILabel *lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblFX;

- (IBAction)btnBeginLocation_click:(id)sender;


@property (strong, nonatomic, readonly) CLLocationManager *clManager;
@end
