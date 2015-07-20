//
//  AppDelegate.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfiguration.h"
#import "Reachability.h"
#import "ReachabilityHelper.h"
#import "ASIFormDataRequest.h"
#import "ApiJsonHelper.h"
#import "Local_UserBankDAO.h"

#import "FMLoginUser.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate ()
{
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate
@synthesize isConnectNet = _isConnectNet;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self checkSettingBundle];//检查配置信息是否有默认值
    /***********设置状态栏***********/
    application.statusBarStyle = UIStatusBarStyleLightContent;
    self.window.backgroundColor = [UIColor whiteColor];
    /***********设置导航条背景色和标题颜色***********/
    UINavigationBar *shareNB = [UINavigationBar appearance];
    [shareNB setBarTintColor:__fm_Global_color_blue];//设置背景色
    [shareNB setTintColor:[UIColor whiteColor]];//箭头颜色
    //设置标题文字颜色
    [shareNB setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置按钮文字颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    /***********设置导航条背景色和标题颜色***********/
    
    /********设置联网状态*******/
    NSString *serverIP = [NSString stringWithFormat:@"%@", __fm_userDefaults_serverIP];
    //_appReachability_host = [Reachability reachabilityWithHostName:serverIP];
    _appReachability_internet = [Reachability reachabilityForInternetConnection];
        _isConnectNet = NO;
    NetworkStatus status = [self.appReachability_internet currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            _isConnectNet = NO;
            break;
        default:
            _isConnectNet = YES;
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStateNotificationCallBack:) name:kReachabilityChangedNotification object:nil];
    //让reach对象开启被监听状态
    [_appReachability_internet startNotifier];
    
    //如果联网且已登陆，更新用户银行信息
    FMLoginUser *loginUser = [FMLoginUser sharedFMLoginUser];
    BOOL isLogin = loginUser.isLogin;
    if (_isConnectNet == YES && isLogin == YES) {
        //第1个任务，下载用户银行信息
        ASIFormDataRequest *requestUB= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[serverIP stringByAppendingString:__fm_apiPath_getUserBanks]]];
        requestUB.shouldAttemptPersistentConnection = YES;
        requestUB.requestMethod = @"POST";
        requestUB.delegate = self;
        //requestUB.name = @"下载用户银行信息";
        NSInteger userID = loginUser.loginUserID;
        [requestUB addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userid"];
        [requestUB setDidFinishSelector:@selector(requestFinishGetUserBank:)];
        [requestUB setDidFailSelector:@selector(requestDidFailedCallBack:)];
        [requestUB startAsynchronous];
    }
    
    //设置百度地图
    _mapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [_mapManager start:@"2DEDlIVYMNvTYHgGwxz13KbC"  generalDelegate:nil];
    if (!ret) {
        LYCLog(@"百度地图启动失败!");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
//asiHttp回调函数
-(void)requestFinishGetUserBank:(ASIHTTPRequest *) re
{
    FMLoginUser *loginUser = [FMLoginUser sharedFMLoginUser];
    NSInteger userID = loginUser.loginUserID;
    ApiJsonHelper *ah = [[ApiJsonHelper alloc] initWithData:[re responseData] requestName:@"获取用户银行信息"];
    if (ah.bSuccess == YES) {
        Local_UserBankDAO *ubDao = [[Local_UserBankDAO alloc] init];
        [ubDao deleteAllUserBanksWithUserID:(int)userID];
        [ubDao addUserBanks:ah.jsonObj toUserID:(int)userID];
    }
    ah.jsonObj = nil;
}
-(void)requestDidFailedCallBack:(ASIHTTPRequest *) requests
{
    NSError *errors = requests.error;
    LYCLog(@"failed,result string is %@",errors);
    if (errors.code == 1) {
        LYCLog(@"网络未连接");
    }
    if (errors.code == 2) {
        LYCLog(@"连接超时");
    }
}

-(void)netStateNotificationCallBack:(NSNotification *) note
{
    //获取被监听的reach对象
    Reachability *reach = [note object];
    //获取网络状态
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        LYCLog(@"网络已经断开");
        _isConnectNet = NO;
    }
    else
    {
        LYCLog(@"网络已连接");
        _isConnectNet = YES;
    }
}

//检查是否有值
-(void)checkSettingBundle
{
    
    if (!__fm_userDefaults_serverIP) {
        LYCLog(@"没有serverIP，默认配置成：http://192.168.1.122:5555");
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setValue:@"http://192.168.1.122:5555" forKey:@"string_serverip"];
        [de synchronize];
    }
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "lycstar.FamilyManagerApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FamilyManagerApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FamilyManagerApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
