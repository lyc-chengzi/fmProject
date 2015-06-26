//
//  LycTableViewCellAutoHeight.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/25.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LycApplySubCellAutoHeight.h"
#import "ApplySubViewModel.h"

@interface LycApplySubCellAutoHeight()
{
    CGFloat _applySubFrame_xBegin;
    CGFloat _applySubFrame_yBegin;
    CGFloat _applySubFrame_defaultWidth;
    CGFloat _applySubFrame_defaultHeight;
}
@end
@implementation LycApplySubCellAutoHeight

-(instancetype)init
{
    self = [super init];
    if (self) {
        _applySubFrame_xBegin = 20.0;
        _applySubFrame_yBegin = 5.0;
        _applySubFrame_defaultWidth = 80.0;
        _applySubFrame_defaultHeight = 20.0;
        
        _cellHeight = 0; //初始化cell的高度
        
        //1. 设置记账类型label的frame
        _cashTypeFrame = CGRectMake(_applySubFrame_xBegin, _applySubFrame_yBegin, _applySubFrame_defaultWidth, _applySubFrame_defaultHeight);
        _cellHeight += _cashTypeFrame.size.height + _cashTypeFrame.origin.y;
        
        //2. 设置资金类型的frame
        _flowTypeFrame = CGRectMake(_applySubFrame_xBegin, _cashTypeFrame.origin.y + _cashTypeFrame.size.height, 180, _applySubFrame_defaultHeight);
        _cellHeight += _flowTypeFrame.size.height;
        
        //3. 设置金额的frame
        _iMoneyFrame = CGRectMake(130, _applySubFrame_yBegin, 170, 20);
    }
    return self;
}

//重写model的set方法，在赋值时计算各个lbl的frame
-(void)setApplySubModel:(ApplySubViewModel *)applySubModel
{
    if (_applySubModel != applySubModel) {
        _applySubModel = nil;
        _applySubModel = applySubModel;
        
        //如果是银行业务的收入或者支出记账，则只显示第一个银行的信息
        if (self.applySubModel.userBankID > 0) {
            //4. 设置第一个银行位置的frame
            _bankFrame1 = CGRectMake(_applySubFrame_xBegin, _flowTypeFrame.origin.y + _flowTypeFrame.size.height, 180, _applySubFrame_defaultHeight);
            _cellHeight += _bankFrame1.size.height;
            
            //5. 设置备注的frame
            if (self.applySubModel.cAdd != nil && self.applySubModel.cAdd.length > 0) {
                [self setRemarkFrameByOtherFrame:_bankFrame1];
            }
            
        } else if (self.applySubModel.inUserBankID > 0){
            //如果是转账记账，则只显示两个银行的信息
            //4. 设置第一个银行位置的frame
            _bankFrame1 = CGRectMake(_applySubFrame_xBegin, _flowTypeFrame.origin.y + _flowTypeFrame.size.height, 180, _applySubFrame_defaultHeight);
            _cellHeight += _bankFrame1.size.height;
            //5. 设置第二个银行位置的frame
            _bankFrame2 = CGRectMake(_applySubFrame_xBegin, _bankFrame1.origin.y + _bankFrame1.size.height, 180, _applySubFrame_defaultHeight);
            _cellHeight += _bankFrame2.size.height;
            
            //6. 设置备注的frame
            if (self.applySubModel.cAdd != nil && self.applySubModel.cAdd.length > 0) {
                [self setRemarkFrameByOtherFrame:_bankFrame2];
            }
            
        } else {
            //如果不涉及银行账户的记账，则无需显示银行信息
            //4. 设置备注的frame
            if (self.applySubModel.cAdd != nil && self.applySubModel.cAdd.length > 0) {
                [self setRemarkFrameByOtherFrame:_flowTypeFrame];
            }
        }
    }
}


//根据提供的目标frame来确定备注的frame
-(void)setRemarkFrameByOtherFrame:(CGRect) rect
{
    _remarkFrame = CGRectMake(_applySubFrame_xBegin, rect.origin.y + rect.size.height, 290, 30);
    _cellHeight += _remarkFrame.size.height;
}
@end
