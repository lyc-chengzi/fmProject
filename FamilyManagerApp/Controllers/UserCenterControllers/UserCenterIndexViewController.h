//
//  UserCenterIndexViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/11.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterIndexViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)btnLogout_click:(id)sender;

@end
