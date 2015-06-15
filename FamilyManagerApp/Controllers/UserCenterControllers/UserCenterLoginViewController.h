//
//  UserCenterLoginViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserCode;
@property (weak, nonatomic) IBOutlet UITextField *txtUserPwd;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *showWait;
- (IBAction)btnLogin_click:(id)sender;
- (IBAction)btnCancel_click:(id)sender;
@end
