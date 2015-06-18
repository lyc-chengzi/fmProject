//
//  AppConfiguration.h
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#ifndef FamilyManagerApp_AppConfiguration_h
#define FamilyManagerApp_AppConfiguration_h

//调试sql命令：-com.apple.CoreData.SQLDebug 1
#ifdef DEBUG
    #define LYCLog(...) NSLog(__VA_ARGS__)
#else
    #define LYCLog(...) //NSLog(__VA_ARGS__)
#endif


/**************NSDefault参数定义**************/
#define __fm_userDefaults_serverIP [[NSUserDefaults standardUserDefaults] stringForKey:@"string_serverip"]
#define __fm_userDefaults_autoTB [[NSUserDefaults standardUserDefaults] boolForKey:@"bool_autoTB"]

//NSUserDefaults参数 key的 宏定义
#define __fm_defaultsKey_loginUser_Status @"loginUserStatus"
#define __fm_defaultsKey_loginUser_ID @"loginUserID"
#define __fm_defaultsKey_loginUser_code @"loginUserCode"
#define __fm_defaultsKey_loginUser_name @"loginUserName"

#define __fm_defaults_baseDataGetDate_Key @"baseDateGetDate"
#define __fm_defaults_flowTypeGetDate_Key @"flowTypeGetDate"
#define __fm_defaults_feeItemGetDate_Key @"feeItemGetDate"

/**************NSDefault参数定义**************/


/**************公共方法定义**************/
//使用方法:__UIColorFromRGB(0xe8e8e8);
#define __fm_fn_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define __fm_fn_getStringValueByDefaultKey(keyName) [[NSUserDefaults standardUserDefaults] stringForKey:keyName]

#define __fm_fn_IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
/**************公共方法定义**************/



/************获取ios版本************/
#define __fm_IOSVersion_getVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define __fm_IOSVersion_ios6Later ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0)
#define __fm_IOSVersion_ios7Later ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
#define __fm_IOSVersion_ios8Later ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define __fm_IOSVersion_ios9Later ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
/************获取ios版本************/



/**************全局样式定义**************/
#define  __fm_Global_color_blue [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1]
/**************全局样式定义**************/



//记账类型 宏定义
#define __fm_KPTypeOfCash_String @"现金记账"
#define __fm_KPTypeOfBank_String @"银行记账"
#define __fm_KPTypeOfChange_String @"内部转账"




//api相应json对应的key定义
#define __fm_apiJsonKey_bSuccess @"bSuccess"
#define __fm_apiJsonKey_message @"message"
#define __fm_apiJsonKey_jsonObj @"jsonObj"

//服务器ip相关 宏定义
//#define __fm_serverIP @"http://192.168.1.122:5555"
//#define __fm_serverIP @"http://192.168.1.123:5555"

//aip路径
#define __fm_apiPath_getBaseUpdateTime @"/baseDataapi/getupdatetime"   //获得基础数据--费用科目
#define __fm_apiPath_getFeeItem @"/baseDataapi/getFeeItemlist"   //获得基础数据--费用科目
#define __fm_apiPath_getFlowType @"/baseDataapi/getflowtypelist" //获得基础数据--资金类型
#define __fm_apiPath_getUserBanks @"/baseDataapi/GetUserBankList" //获得用户银行信息
#define __fm_apiPath_doCashAccounting @"/applyapi/doCashAccounting" //现金记账接口
#define __fm_apiPath_doBankAccounting @"/applyapi/DoBankAccounting" //银行记账接口
#define __fm_apiPath_doZhuanZhang @"/applyapi/DoZhuanZhang" //转账记账接口
#define __fm_apiPath_doLogin @"/userinfoapi/UserLogin" //登陆接口

#endif
