//
//  LycApplySubCell.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/25.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LycApplySubCell.h"
#import "ApplySubViewModel.h"
#import "LycApplySubCellAutoHeight.h"

@implementation LycApplySubCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加记账类型
        self.lblCashOrBank = [[UILabel alloc] init];
        self.lblCashOrBank.font = [UIFont systemFontOfSize:15];
        self.lblCashOrBank.textColor = [UIColor colorWithRed:0.8 green:0.28 blue:0.15 alpha:1.0];
        [self.contentView addSubview:self.lblCashOrBank];
        
        //添加资金类型
        self.lblFlowType = [[UILabel alloc] init];
        self.lblFlowType.font = [UIFont systemFontOfSize:15];
        self.lblFlowType.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.lblFlowType];
        
        //添加记账金额
        self.lblMoney = [[UILabel alloc] init];
        self.lblMoney.textColor = [UIColor colorWithRed:0.33 green:0.7 blue:0.95 alpha:1.0];
        [self.contentView addSubview:self.lblMoney];
        
        //添加银行信息1
        self.lblBank1 = [[UILabel alloc] init];
        self.lblBank1.font = [UIFont systemFontOfSize:15];
        self.lblBank1.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.lblBank1];
        
        //添加银行信息2
        self.lblBank2 = [[UILabel alloc] init];
        self.lblBank2.font = [UIFont systemFontOfSize:15];
        self.lblBank2.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.lblBank2];
        
        //添加备注信息
        self.lblAdd = [[UILabel alloc] init];
        self.lblAdd.font = [UIFont systemFontOfSize:13];
        self.lblAdd.textColor = [UIColor darkGrayColor];
        self.lblAdd.numberOfLines = 2;
        [self.contentView addSubview:self.lblAdd];
        
    }
    return self;
}

-(void)setCellValue:(LycApplySubCellAutoHeight *) cellFrame
{
    ApplySubViewModel *sub = cellFrame.applySubModel;
    
    //显示记账类型
    self.lblCashOrBank.frame = cellFrame.cashTypeFrame;
    self.lblCashOrBank.text = sub.cashOrBank == 0 ? @"现金业务" : @"银行业务";
    
    //显示资金类型
    if ([sub.inOutType isEqualToString:@"out"]) {
        self.lblFlowType.text = [NSString stringWithFormat:@"%@ - %@", sub.flowTypeName, sub.feeItemName];
    }else {
        self.lblFlowType.text = [NSString stringWithFormat:@"%@", sub.flowTypeName];
    }
    self.lblFlowType.frame = cellFrame.flowTypeFrame;
    
    //显示记账金额
    self.lblMoney.text = [NSString stringWithFormat:@"¥%@", sub.iMoney];
    self.lblMoney.frame = cellFrame.iMoneyFrame;
    
    //如有需要，显示银行相关信息
    if (sub.userBankID > 0) {
        if ([sub.inOutType isEqualToString:@"in"]) {
            self.lblBank1.text = [NSString stringWithFormat:@"入账银行 - %@", sub.userBankName];
        } else {
            self.lblBank1.text = [NSString stringWithFormat:@"出账银行 - %@", sub.userBankName];
        }
        self.lblBank1.frame = cellFrame.bankFrame1;
    } else if (sub.inUserBankID > 0){
        self.lblBank1.text = [NSString stringWithFormat:@"入账银行 - %@", sub.inUserBankName];
        self.lblBank1.frame = cellFrame.bankFrame1;
        self.lblBank2.text = [NSString stringWithFormat:@"出账银行 - %@", sub.outUserBankName];
        self.lblBank2.frame = cellFrame.bankFrame2;
    }
    
    //如有备注，显示备注信息
    if (sub.cAdd.length > 0) {
        self.lblAdd.text = sub.cAdd;
        self.lblAdd.frame = cellFrame.remarkFrame;
    }
}
@end
