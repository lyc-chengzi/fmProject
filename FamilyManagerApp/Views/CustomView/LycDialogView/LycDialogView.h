//
//  LycDialogView.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/12.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LycDialogView : UIView

@property (nonatomic) BOOL isModalView; //是否模态窗口
@property (nonatomic, strong, readonly) UIView *modalView; //模态view
@property (nonatomic, strong, readonly) UIView *mainView;  //主view，菊花控件和提示文字添加到此view中
@property (nonatomic, strong) UIActivityIndicatorView *loadView; //菊花控件
@property (nonatomic, strong) UILabel *lblTitle; //提示文字Label
@property (nonatomic, readonly, strong) NSLayoutConstraint *widthConstraint; //宽度约束
@property (nonatomic, readonly, strong) NSLayoutConstraint *heightConstraint; //高度约束
@property (nonatomic, readonly, strong) NSLayoutConstraint *xConstraint; //x坐标约束
@property (nonatomic, readonly, strong) NSLayoutConstraint *yConstraint; //y坐标约束

//默认开启模态模式
-(instancetype)initWithTitle:(NSString *) title andSuperView:(UIView *) sView;
//使用者自己选择是否开启模态模式
-(instancetype)initWithTitle:(NSString *) title andSuperView:(UIView *) sView isModal:(BOOL) isM;

-(void)showDialog:(NSString *)title;
-(void)hideDialog;
@end
