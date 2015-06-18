//
//  WealthViewController.m
//  FamilyManagerApp
//
//  Created by Lyc's computer on 15/6/17.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "WealthViewController.h"
#import "LycScrollCollectionViewCell.h"
#import "AppConfiguration.h"

@interface WealthViewController ()
{
    NSArray *collectionData;
    BOOL _isRegistCell;
}

@end

@implementation WealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjects:@[@"标题11111111",@"dog.png"] forKeys:@[@"title",@"img"]];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:@[@"标题22222222",@"duck.png"] forKeys:@[@"title",@"img"]];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjects:@[@"标题33333333",@"elephant.png"] forKeys:@[@"title",@"img"]];
    NSDictionary *dic4 = [NSDictionary dictionaryWithObjects:@[@"标题44444444",@"frog.png"] forKeys:@[@"title",@"img"]];
    NSDictionary *dic5 = [NSDictionary dictionaryWithObjects:@[@"标题55555555",@"mouse.png"] forKeys:@[@"title",@"img"]];
    NSDictionary *dic6 = [NSDictionary dictionaryWithObjects:@[@"标题66666666",@"rabbit.png"] forKeys:@[@"title",@"img"]];
    collectionData = @[dic1, dic2, dic3, dic4, dic5, dic6];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3000 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionData.count * 1000;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cid";
    
    if (_isRegistCell == NO) {
        UINib *nib = [UINib nibWithNibName:@"LycAutoScrollView" bundle:nil];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellID];
        _isRegistCell = YES;
    }
    LycScrollCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dic = [collectionData objectAtIndex:indexPath.item % collectionData.count];
    UIImage *img = [UIImage imageNamed:dic[@"img"]];
    [cell setContents:dic[@"title"] andImage:img];
    return cell;
}
@end
