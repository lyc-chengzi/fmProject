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

#import "AppDelegate.h"
#import "LycDialogView.h"
#import "ASIFormDataRequest.h"
#import "ApiJsonHelper.h"

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
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _lycDialog = [[LycDialogView alloc] initWithTitle:@"正在加载" andSuperView:self.view isModal:NO];
    
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
    
    [self loadCaichan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCaichan
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [ud boolForKey:__fm_defaultsKey_loginUser_Status];
    NSString *serverIP = __fm_userDefaults_serverIP;
    if (self.appDelegate.isConnectNet == YES && isLogin == YES) {
        [self.lycDialog showDialog:nil];
        //第1个任务，下载用户银行信息
        ASIFormDataRequest *requestUB= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_queryZiChan]]];
        __weak ASIFormDataRequest *request_weak = requestUB;//使用block回调函数时，要使用弱指针对象调用，不然会导致循环引用，ASI对象无法释放，导致内存泄漏
        _test_request = requestUB;
        requestUB.shouldAttemptPersistentConnection = YES;
        requestUB.requestMethod = @"POST";
        NSInteger userID = [ud integerForKey:__fm_defaultsKey_loginUser_ID];
        [requestUB addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userid"];
        [requestUB setFailedBlock:^{
            [self.lycDialog hideDialog];
        }];
        [requestUB setCompletionBlock:^{
            NSData *data = [request_weak responseData];
            ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:data requestName:@"获取资产"];
            if (aj.bSuccess == YES) {
                NSString *cashMoney = [aj.jsonObj objectForKey:@"cashMoney"];
                NSString *bankMoney = [aj.jsonObj objectForKey:@"bankMoney"];
                NSString *totalMoney = [aj.jsonObj objectForKey:@"totalMoney"];
                self.lblCash.text = [NSString stringWithFormat:@"¥ %@", cashMoney];
                self.lblBank.text = [NSString stringWithFormat:@"¥ %@", bankMoney];
                self.lblTotal.text = [NSString stringWithFormat:@"¥ %@", totalMoney];
            }
            [self.lycDialog hideDialog];
        }];
        [requestUB startAsynchronous];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**************UICollectionView 委托**************/
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
//刷新tap事件
- (IBAction)refresh_click:(id)sender {
    [self loadCaichan];
}

@end
