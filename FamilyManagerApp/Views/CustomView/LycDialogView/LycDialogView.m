//
//  LycDialogView.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/12.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "LycDialogView.h"
@interface LycDialogView()
@property (nonatomic) CGFloat viewAlpha;
@end

@implementation LycDialogView
@synthesize widthConstraint = _widthConstraint;
@synthesize heightConstraint = _heightConstraint;
@synthesize xConstraint = _xConstraint;
@synthesize yConstraint = _yConstraint;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//默认开启模态模式
-(instancetype)initWithTitle:(NSString *) title andSuperView:(UIView *) sView
{
    return [self initWithTitle:title andSuperView:sView isModal:YES];
}
//使用者自己选择是否开启模态模式
-(instancetype)initWithTitle:(NSString *)title andSuperView:(UIView *)sView isModal:(BOOL)isM
{
    self = [self init];
    if (self) {
        //设置默认透明度
        self.viewAlpha = 0.75;
        self.isModalView = isM;
        //如果是模态模式
        if (self.isModalView) {
            //1.创建一个空白view，让用户不能进行其他操作
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor grayColor];
            backView.alpha = self.viewAlpha;
            [sView addSubview:backView];
            backView.translatesAutoresizingMaskIntoConstraints = NO;
            NSArray *bvH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)];
            NSArray *bvV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)];
            [sView addConstraints:bvH];
            [sView addConstraints:bvV];
            backView.hidden = YES;
            //2.将黑色背景view添加到空白view上
            [self addSelfToSuperView:backView];
        }
        else
        {
            //2.将黑色背景view添加到用户指定的view上
            [self addSelfToSuperView:sView];
            self.alpha = self.viewAlpha;
        }
        
        //3.设置当前view的style
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor blackColor];
        
        //4.添加一个加载控件
        self.loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.loadView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.loadView];
        //添加布局约束
        NSLayoutConstraint *loadViewXCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *loadViewYCon = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.loadView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
        [self addConstraints:@[loadViewXCon, loadViewYCon]];
        
        
        //5.添加一个label显示提示信息
        self.lblTitle = [[UILabel alloc] init];
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.text = [title copy];
        self.lblTitle.font = [UIFont systemFontOfSize:10];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.numberOfLines = 0;
        [self addSubview:self.lblTitle];
        
        //添加布局约束
        NSArray *labelConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[lblTitle(>=20)]" options:0 metrics:nil views:@{@"lblTitle":self.lblTitle}];
        NSArray *labelConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[lblTitle]-|" options:0 metrics:nil views:@{@"lblTitle":self.lblTitle}];
        [self addConstraints:labelConstraintsH];
        [self addConstraints:labelConstraintsV];
    }
    return self;
}

//获得宽度约束
-(NSLayoutConstraint *)widthConstraint
{
    if (!_widthConstraint) {
        _widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:90];
    }
    return _widthConstraint;
}

//获得高度约束
-(NSLayoutConstraint *)heightConstraint
{
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:90];
    }
    return _heightConstraint;
}

//获得x约束
-(NSLayoutConstraint *)xConstraint
{
    if (!_xConstraint) {
        _xConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    }
    return _xConstraint;
}

//获得y约束
-(NSLayoutConstraint *)yConstraint
{
    if (!_yConstraint) {
        _yConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    }
    return _yConstraint;
}

-(void)addSelfToSuperView:(UIView *) sView
{
    [sView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraints:@[self.widthConstraint, self.heightConstraint]];
    [self.superview addConstraints:@[self.xConstraint, self.yConstraint]];
}

-(void)showDialog:(NSString *) title
{
    if (title != nil && title.length > 0) {
        self.lblTitle.text = [title copy];
    }
    [self.loadView startAnimating];
    if (self.isModalView) {
        self.superview.hidden = NO;
    }
    else
    {
        self.hidden = NO;
    }
    
}

-(void)hideDialog
{
    [self.loadView stopAnimating];
    if (self.isModalView) {
        self.superview.hidden = YES;
    }
    else
    {
        self.hidden = YES;
    }
}
@end
