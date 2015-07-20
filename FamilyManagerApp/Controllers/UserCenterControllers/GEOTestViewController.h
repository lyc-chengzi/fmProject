//
//  GEOTestViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/7/16.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface GEOTestViewController : UIViewController
- (IBAction)geoCoder_click:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblJD;
@property (weak, nonatomic) IBOutlet UILabel *lblWD;
@property (weak, nonatomic) IBOutlet UILabel *lblAddressInfo;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@end
