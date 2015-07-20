//
//  BKViewController.h
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Local_FeeItem, Local_FlowType, Local_UserBank;
@class CheckViewController, LycDialogView;
@protocol BKViewControllerDataSourceDelegate <NSObject>

//@optional
@required
//获得所有费用科目，keys为一级费用科目
-(NSArray *)getTheFeeItemList;
//获得所有资金类型，keys为记账类型，values为资金类型
-(NSDictionary *)getTheFlowTypeList;

//设置记账日期
-(void)setTheApplyDate:(NSString *) appDate;
//设置记账类型
-(void)setTheKeepType:(NSString *) kType;
//设置资金类型
-(void)setTheCheckFlowType:(Local_FlowType *) lft;
//设置费用科目
-(void)setTheCheckFeeItem:(Local_FeeItem *) lfi;
//设置入账银行
-(void)setTheInUserBank:(Local_UserBank *) iub;
//设置出账银行
-(void)setTheOutUserBank:(Local_UserBank *) oub;
//设置记账金额
-(void)setTheApplyMoney:(NSDecimalNumber *) money;

@end

@interface BKViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BKViewControllerDataSourceDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    UIView *_datePickerContainer;
    UIDatePicker *_mydatePicker;
    BOOL _isShowDatePicker;
    CGRect _screenFrame;
    UIButton *_cancelDatePicker;
    UIButton *_okDatePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview1;
@property (weak, nonatomic) IBOutlet UIButton *btnOKDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelDate;

@property (weak, nonatomic) IBOutlet UIView *DatePickerBox;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
- (IBAction)btnOKDate_Click:(id)sender;
- (IBAction)btnCancelDate_Click:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomConstraint;

@property (weak, nonatomic) CheckViewController *ccontroller;

//已通过
@property (strong, nonatomic, readonly) NSString *applyDate;    //记账日期
@property (strong, nonatomic, readonly) Local_FlowType *checkFlowType;  //选择的资金类型
@property (strong, nonatomic) Local_UserBank *inUserBank;   //入账银行
@property (strong, nonatomic) Local_UserBank *outUserBank;  //出账银行

@property (nonatomic) NSString *applyRemark;//备注信息
@property (nonatomic, readonly) NSDecimalNumber *applyMoney;         //记账金额

@property (strong, nonatomic, readonly) NSMutableDictionary *flowTypeList;  //资金类型列表，按记账类型标记好了
@property (strong, nonatomic, readonly) NSArray *feeItemList;               //费用科目列表，使用时再处理

@property (strong, nonatomic, readonly) UITapGestureRecognizer *tapGesture;//taptableview时隐藏键盘
@property (strong, nonatomic, readonly) UIViewController *flowTypeController;   //资金类型选择页面

@property (strong, nonatomic, readonly) LycDialogView *dialogView;

//未测试通过

@property (strong, nonatomic, readonly) NSString *keepType;     //记账类型
@property (strong, nonatomic, readonly) Local_FeeItem *checkFeeItem;    //选择的费用科目


@end
