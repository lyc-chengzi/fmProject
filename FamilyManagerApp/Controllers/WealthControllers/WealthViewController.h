//
//  WealthViewController.h
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/17.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WealthViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
