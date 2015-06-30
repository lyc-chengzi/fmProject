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
        //将LycDialog添加到用户指定的父view中
        [self addSelfToSuperView:sView];
        //如果是模态模式
        if (self.isModalView) {
            //1.创建一个空白view，让用户不能进行其他操作
            _modalView = [[UIView alloc] init];
            _modalView.backgroundColor = [UIColor grayColor];
            _modalView.alpha = self.viewAlpha;
            [self addSubview:_modalView];
            _modalView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSArray *modalH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_modalView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_modalView)];
            NSArray *modalV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_modalView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_modalView)];
            [self addConstraints:modalH];
            [self addConstraints:modalV];
        }
        
        //2. 初始化mainView
        _mainView = [[UIView alloc] init];
        _mainView.translatesAutoresizingMaskIntoConstraints = NO;
        //3.设置mainView的style
        _mainView.layer.masksToBounds = YES;
        _mainView.layer.cornerRadius = 5;
        _mainView.alpha = self.viewAlpha;
        _mainView.backgroundColor = [UIColor blackColor];
        [self addSubview:_mainView];
        [self addConstraints:@[self.widthConstraint, self.heightConstraint]];
        [self addConstraints:@[self.xConstraint, self.yConstraint]];
        
        //4.添加一个加载控件
        self.loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.loadView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mainView addSubview:self.loadView];
        //添加布局约束
        NSLayoutConstraint *loadViewXCon = [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *loadViewYCon = [NSLayoutConstraint constraintWithItem:_mainView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.loadView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
        [_mainView addConstraints:@[loadViewXCon, loadViewYCon]];
        
        
        //5.添加一个label显示提示信息
        self.lblTitle = [[UILabel alloc] init];
        self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.text = [title copy];
        self.lblTitle.font = [UIFont systemFontOfSize:12];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.numberOfLines = 0;
        [_mainView addSubview:self.lblTitle];
        
        //添加布局约束
        NSArray *labelConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[lblTitle(>=20)]" options:0 metrics:nil views:@{@"lblTitle":self.lblTitle}];
        NSArray *labelConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[lblTitle]-|" options:0 metrics:nil views:@{@"lblTitle":self.lblTitle}];
        [_mainView addConstraints:labelConstraintsH];
        [_mainView addConstraints:labelConstraintsV];
        
        [self hideDialog];
    }
    return self;
}

//获得宽度约束
-(NSLayoutConstraint *)widthConstraint
{
    if (!_widthConstraint) {
        _widthConstraint = [NSLayoutConstraint constraintWithItem:self.mainView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:90];
    }
    return _widthConstraint;
}

//获得高度约束
-(NSLayoutConstraint *)heightConstraint
{
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self.mainView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:90];
    }
    return _heightConstraint;
}

//获得x约束
-(NSLayoutConstraint *)xConstraint
{
    if (!_xConstraint) {
        _xConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    }
    return _xConstraint;
}

//获得y约束
-(NSLayoutConstraint *)yConstraint
{
    if (!_yConstraint) {
        _yConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mainView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    }
    return _yConstraint;
}

-(void)addSelfToSuperView:(UIView *) sView
{
    [sView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDic = [NSDictionary dictionaryWithObject:self forKey:@"dialogView"];
    NSArray *bvH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[dialogView]-0-|" options:0 metrics:nil views:viewDic];
    NSArray *bvV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[dialogView]-0-|" options:0 metrics:nil views:viewDic];
    [sView addConstraints:bvH];
    [sView addConstraints:bvV];
}

-(void)showDialog:(NSString *) title
{
    if (title != nil && title.length > 0) {
        self.lblTitle.text = [title copy];
    }
    self.hidden = NO;
    [self.loadView startAnimating];
    
}

-(void)hideDialog
{
    [self.loadView stopAnimating];
    self.hidden = YES;
}
@end
