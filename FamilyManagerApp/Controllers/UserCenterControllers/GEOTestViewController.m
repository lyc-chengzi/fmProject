//
//  GEOTestViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/7/16.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "GEOTestViewController.h"
#import "AppConfiguration.h"

@interface GEOTestViewController()

@end

@implementation GEOTestViewController
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (_geoCoder == nil) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
}

- (IBAction)geoCoder_click:(id)sender {
    
    [self.geoCoder geocodeAddressString:self.txtAddress.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            self.lblAddressInfo.text = @"地址没有找到";
        
        }
        else if (placemarks.count == 0){
            self.lblAddressInfo.text = @"地址没有找到";
        }
        else {
            //CLPlacemark *pm = [placemarks firstObject];
            for (CLPlacemark *pm in placemarks) {
                CLLocation *location = pm.location;
                self.lblJD.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
                self.lblWD.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
                self.lblAddressInfo.text = [NSString stringWithFormat:@"%@",pm.name];
                [pm.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    LYCLog(@"key:%@,  value:%@",key, obj);
                }];
            }
            
            
        }
    }];
}
@end
