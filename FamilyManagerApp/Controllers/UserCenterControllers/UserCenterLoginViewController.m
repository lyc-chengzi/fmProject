//
//  UserCenterLoginViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/6/15.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "UserCenterLoginViewController.h"
#import "AppConfiguration.h"
#import "ASIFormDataRequest.h"
#import "ApiJsonHelper.h"

@interface UserCenterLoginViewController ()
@end

@implementation UserCenterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)btnLogin_click:(id)sender {
    [self.showWait startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    NSString *serverIP = __fm_userDefaults_serverIP;
    ASIFormDataRequest *requestUB= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_doLogin]]];
    requestUB.shouldAttemptPersistentConnection = YES;
    requestUB.requestMethod = @"POST";
    requestUB.delegate = self;
    //requestUB.name = @"登陆操作";
    [requestUB addPostValue:self.txtUserCode.text forKey:@"usercode"];
    [requestUB addPostValue:self.txtUserPwd.text forKey:@"userpwd"];
    [requestUB setDidFinishSelector:@selector(requestFinishLogin:)];
    [requestUB setDidFailSelector:@selector(requestDidFailedCallBack:)];
    [requestUB startAsynchronous];
}

-(void)requestFinishLogin:(ASIHTTPRequest *) request
{
    [self.showWait stopAnimating];
    NSData *result = [request responseData];
    ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:result requestName:@"登陆操作"];
    if (aj.bSuccess == YES) {
        //如果登陆成功，更改app的登陆状态
        NSInteger userID = [[aj.jsonObj objectForKey:@"ID"] integerValue];
        NSString *userCode = [aj.jsonObj objectForKey:@"cUserCode"];
        NSString *userName = [aj.jsonObj objectForKey:@"cUserName"];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setBool:YES forKey:__fm_defaultsKey_loginUser_Status];
        [ud setInteger:userID forKey:__fm_defaultsKey_loginUser_ID];
        [ud setObject:userCode forKey:__fm_defaultsKey_loginUser_code];
        [ud setObject:userName forKey:__fm_defaultsKey_loginUser_name];
        [ud synchronize];
        //关闭当前dialog页面
        [self btnCancel_click:nil];
    }else{
        [self.view setUserInteractionEnabled:YES];
        CAKeyframeAnimation *leftAm = [[CAKeyframeAnimation alloc] init];
        leftAm.keyPath = @"transform.translation.x";
        leftAm.values = @[@0, @20, @-20,@0 ];
        leftAm.duration = 0.2;
        [self.pwdView.layer addAnimation:leftAm forKey:@"dese"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:aj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)requestDidFailedCallBack:(ASIHTTPRequest *) request
{
    [self.view setUserInteractionEnabled:YES];
    [self.showWait stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"与服务器连接失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)btnCancel_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
