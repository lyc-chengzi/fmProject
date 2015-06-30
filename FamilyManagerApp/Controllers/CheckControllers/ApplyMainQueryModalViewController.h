//
//  ApplyMainQueryModalViewController.h
//  FamilyManagerApp

//  账单高级查询弹出页

//  Created by ESI on 15/6/30.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ApplyMainQueryModalDelegate <NSObject>

@required
@optional
-(void) setApplyMainQueryTime:(NSString *) startTime andEndTime:(NSString *) endTime;

//当前modal页即将关闭时调用
-(void) willDismissViewController:(UIViewController *) vc;

@end

@interface ApplyMainQueryModalViewController : UIViewController
- (IBAction)btnClose_click:(id)sender;
- (IBAction)btnOK_click:(id)sender;
- (IBAction)btnLastTwo_Click:(id)sender;
- (IBAction)btnLast_Click:(id)sender;
- (IBAction)btnCurrent_Click:(id)sender;



@property (weak, nonatomic) IBOutlet UITextField *txtStartTime;
@property (weak, nonatomic) IBOutlet UITextField *txtEndTime;

//代理
@property (weak, nonatomic) id<ApplyMainQueryModalDelegate> queryDelegate;

@end


