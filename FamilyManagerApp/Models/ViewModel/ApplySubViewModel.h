//
//  ApplySubViewModel.h
//  FamilyManagerApp
//
//  Created by ESI on 15/6/24.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplySubViewModel : NSObject

@property (nonatomic) int applyMainID;
@property (nonatomic) int applySubID;
@property (nonatomic) int cashOrBank;//0现金，1银行
@property (nonatomic) int flowTypeID;//资金类型
@property (nonatomic, copy) NSString *flowTypeName;
@property (nonatomic, copy) NSString *inOutType;//in,out,other
@property (nonatomic) int feeItemID;//费用科目ID
@property (nonatomic, copy) NSString *feeItemName;
@property (nonatomic) NSDecimalNumber *iMoney;//记账金额
@property (nonatomic) int userBankID;//银行记账才会用到此字段
@property (nonatomic, copy) NSString *userBankName;
@property (nonatomic, copy) NSString *bChange;//是否内部转账记录 "Y" or "N"
@property (nonatomic) int inUserBankID;//转账入账银行，转账才会用到
@property (nonatomic, copy) NSString *inUserBankName;
@property (nonatomic) int outUserBankID;//转账出账银行，转账才会用到
@property (nonatomic, copy) NSString *outUserBankName;
@property (nonatomic, copy) NSString *cAdd;//备注信息
@property (nonatomic, copy) NSString *createDate;//记账时间

@end
