//
//  LycApplySubCell.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/25.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LycApplySubCellAutoHeight;

@interface LycApplySubCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblCashOrBank;//记账类型
@property (nonatomic, strong) UILabel *lblFlowType;//资金类型
@property (nonatomic, strong) UILabel *lblMoney;//记账金额
@property (nonatomic, strong) UILabel *lblBank1;//银行信息1
@property (nonatomic, strong) UILabel *lblBank2;//银行信息2
@property (nonatomic, strong) UILabel *lblAdd;//备注信息


-(void)setCellValue:(LycApplySubCellAutoHeight *) cellFrame;
@end
