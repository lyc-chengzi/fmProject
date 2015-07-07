//
//  WealthViewController.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/17.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AppDelegate, LycDialogView, ASIFormDataRequest;

@interface WealthViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)refresh_click:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCash;
@property (weak, nonatomic) IBOutlet UILabel *lblBank;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic, readonly) AppDelegate *appDelegate;
@property (strong, nonatomic, readonly) LycDialogView *lycDialog;

@property (weak, nonatomic) ASIFormDataRequest *test_request;

@end
