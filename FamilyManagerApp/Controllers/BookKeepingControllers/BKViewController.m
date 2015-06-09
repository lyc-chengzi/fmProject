//
//  BKViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "BKViewController.h"
#import "AppConfiguration.h"
#import "ReachabilityHelper.h"

#import "LycTableCellViewDefault.h"
#import "LycTableCellViewDefault2.h"
#import "DateFormatterHelper.h"
#import "ASIFormDataRequest.h"
#import "CheckFlowTypeViewController.h"
#import "CheckFeeItemViewController.h"
#import "CheckUserBankViewController.h"

#import "Local_FeeItemDAO.h"
#import "Local_FlowTypeDAO.h"

@interface BKViewController ()
{
    BOOL _isRegistNib;
    NSDateFormatter *_shortDateFormatter;
    NSArray *tableData;
    
    dispatch_queue_t sQueue;//定义一个串行队列
}
@end

@implementation BKViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    _isRegistNib = NO;
    _shortDateFormatter = [DateFormatterHelper getShortDateFormatter];
    [self loadTableViewData];
    self.tableview1.dataSource = self;
    self.tableview1.delegate = self;
    
    
    //设置导航条
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                         style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    [btnRight setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor ]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    _applyDate = [_shortDateFormatter stringFromDate:[NSDate date]];
    
    //初始化控制器属性
    //初始化资金类型
    _flowTypeList = [[NSMutableDictionary alloc] initWithObjects:
                                                [NSArray arrayWithObjects:
                                                    [[NSMutableArray alloc] init],
                                                    [[NSMutableArray alloc] init],
                                                    [[NSMutableArray alloc] init], nil]
                                                forKeys:@[__fm_KPTypeOfCash_String,__fm_KPTypeOfBank_String,__fm_KPTypeOfChange_String]];
    
    [self loadBaseData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //页面将要显示时，重新加载可能被释放掉的对象
    [self initDatePicker];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self disposeDatePicker];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"记账页面收到内存警告！！！！");
    [self disposeResource];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)loadTableViewData
{
    NSArray *arraybase = [NSArray arrayWithObjects:@"记账日期",@"记账类型",@"资金流动类型",@"费用科目",nil];
    NSMutableArray *arraymoney = [NSMutableArray arrayWithObjects:@"出账银行",@"入账银行",nil];
    tableData = [NSArray arrayWithObjects:arraybase,arraymoney, nil];
}

-(void)loadBaseData
{
    //加载所有基础数据
    //加载资金类型数据
    if (!sQueue) {
        sQueue = dispatch_queue_create("chuanxingQueue", DISPATCH_QUEUE_SERIAL);
        //加载资金类型
        dispatch_async(sQueue, ^(void){
            Local_FlowTypeDAO *ftDao = [[Local_FlowTypeDAO alloc] init];
            NSArray *flowTypeList = [ftDao getAllFlowTypes];
            for (int i = 0; i < flowTypeList.count; i++) {
                Local_FlowType *ft = flowTypeList[i];
                
                //转账资金类型
                if (![ft.inOutType isEqual:@"in"] && ![ft.inOutType isEqual:@"out"]) {
                    [[_flowTypeList objectForKey:__fm_KPTypeOfChange_String] addObject:ft];
                    continue;
                }
                
                //银行资金类型
                if (ft.flowType == [NSNumber numberWithInt:1]) {
                    [[_flowTypeList objectForKey:__fm_KPTypeOfBank_String] addObject:ft];
                    continue;
                }
                
                //现金资金类型
                if (ft.flowType == [NSNumber numberWithInt:0]) {
                    [[_flowTypeList objectForKey:__fm_KPTypeOfCash_String] addObject:ft];
                    continue;
                }
            }
        });
        
        //加载费用科目
        dispatch_async(sQueue, ^(void){
            Local_FeeItemDAO *fiDao = [[Local_FeeItemDAO alloc] init];
            NSArray *feeItemList = [fiDao getAllFeeItems];
            _feeItemList = feeItemList;
        });
        //加载用户银行数据
        dispatch_async(sQueue, ^(void){
            //加载完数据后在主线程要执行的代码
            //隐藏等待窗口
            dispatch_async(dispatch_get_main_queue(), ^(void){
                NSLog(@"在主线程中应该要隐藏等待窗口");
            });
            
        });
        
    }
}

//初始化日期选择器视图
-(void) initDatePicker
{
    _isShowDatePicker= NO;
    // Do any additional setup after loading the view.
    _screenFrame = [[UIScreen mainScreen] bounds];
    if (!_datePickerContainer) {
        _datePickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _screenFrame.size.height, _screenFrame.size.width, 180)];
        _datePickerContainer.backgroundColor=[UIColor whiteColor];
        _datePickerContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_datePickerContainer];
    }
    if (!_datePicker) {
        NSDate *now = [NSDate date];
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, _screenFrame.size.width, 150)];
        _datePicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _datePicker.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.date = now;
        _datePicker.tag = 22;
        _datePicker.minimumDate = [now dateByAddingTimeInterval:-60*60*24*30 ];
        _datePicker.maximumDate = now;
        //[_datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
        [_datePickerContainer addSubview:_datePicker];
    }
    if (!_cancelDatePicker) {
        _cancelDatePicker = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 100, 30)];
        [_cancelDatePicker setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelDatePicker setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelDatePicker setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_cancelDatePicker addTarget:self action:@selector(cancelDatePickerClick) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerContainer addSubview:_cancelDatePicker];
    }
    if (!_okDatePicker) {
        _okDatePicker = [[UIButton alloc] initWithFrame:CGRectMake(_screenFrame.size.width-100, 10, 100, 30)];
        [_okDatePicker setTitle:@"确定" forState:UIControlStateNormal];
        [_okDatePicker setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_okDatePicker setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_okDatePicker addTarget:self action:@selector(okDatePickerClick) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerContainer addSubview:_okDatePicker];
    }
}

-(void)cancelDatePickerClick
{
    [self showDatePicker];
}
-(void)okDatePickerClick
{
    [self setTheApplyDate:[_shortDateFormatter stringFromDate:_datePicker.date]];
    [self showDatePicker];
}
-(void) showDatePicker
{
    if( _isShowDatePicker == NO)
    {
        [UIView animateWithDuration:0.1 delay:0.0 options:0 animations:^{
                             [_datePickerContainer setFrame:CGRectMake(0, _screenFrame.size.height - 200 - 50, _screenFrame.size.width, 200)];
                         } completion:^(BOOL finished) {
                             _isShowDatePicker = !_isShowDatePicker;
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.1 delay:0.0 options:0 animations:^{
                             [_datePickerContainer setFrame:CGRectMake(0, _screenFrame.size.height, _screenFrame.size.width, 200)];
                         } completion:^(BOOL finished) {
                             _isShowDatePicker = !_isShowDatePicker;
                         }];
    }
}

-(void)hideKeyBoard
{
    [self.txtMoney resignFirstResponder];
    [self.txtRemark resignFirstResponder];
}

-(void)disposeResource
{
    NSLog(@"释放资源");
    _flowTypeController = nil;
    _checkFlowType = nil;
    _checkFeeItem = nil;
    _inUserBank = nil;
    _outUserBank = nil;
    [self disposeDatePicker];
}
/*销毁日期选择器相关view*/
-(void)disposeDatePicker
{
    /*销毁日期选择器相关view*/
    [_datePicker removeFromSuperview];
    _datePicker = nil;
    [_okDatePicker removeFromSuperview];
    _okDatePicker = nil;
    [_cancelDatePicker removeFromSuperview];
    _cancelDatePicker = nil;
    [_datePickerContainer removeFromSuperview];
    _datePickerContainer = nil;
}

//提交记账数据
-(void)submit
{
    [self hideKeyBoard];
    if ([ReachabilityHelper isConnectInternet] == NO) {
        [[[UIAlertView alloc] initWithTitle:@"网络未连接" message:@"当前版本必须联网才能记账！"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.applyDate == nil) {
        [[[UIAlertView alloc] initWithTitle:@"请填写完整信息" message:@"记账日期必须选择"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.keepType == nil) {
        [[[UIAlertView alloc] initWithTitle:@"请填写完整信息" message:@"记账类型必须选择"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.checkFlowType == nil) {
        [[[UIAlertView alloc] initWithTitle:@"请填写完整信息" message:@"资金类型必须选择"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([self.checkFlowType.inOutType isEqual:@"out"] && self.checkFeeItem == nil) {
        [[[UIAlertView alloc] initWithTitle:@"请填写完整信息" message:@"支出记账必须选择费用科目"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if ([self.txtMoney.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"请填写完整信息" message:@"请填写正确的金额，必须大于0"
                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    //现金记账
    if ([self.keepType isEqualToString:__fm_KPTypeOfCash_String]) {
        NSString *requestURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_doCashAccounting];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 100;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInt:13] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        [request addPostValue:self.checkFeeItem.feeItemID forKey:@"feeItemID"];
        [request addPostValue:self.checkFeeItem.feeItemName forKey:@"feeItemName"];
        [request addPostValue:[NSNumber numberWithDouble:[self.txtMoney.text doubleValue]] forKey:@"money"];
        [request addPostValue:self.txtRemark.text forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    //银行记账
    else if ([self.keepType isEqualToString:__fm_KPTypeOfBank_String])
    {
        NSString *requestURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_doBankAccounting];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 200;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInt:13] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        [request addPostValue:self.checkFeeItem.feeItemID forKey:@"feeItemID"];
        [request addPostValue:self.checkFeeItem.feeItemName forKey:@"feeItemName"];
        [request addPostValue:[NSNumber numberWithDouble:[self.txtMoney.text doubleValue]] forKey:@"money"];
        //如果是银行收入，只选择入账银行即可
        if ([self.checkFlowType.inOutType isEqualToString:@"in"]) {
            [request addPostValue:self.inUserBank.userBankID forKey:@"inUBID"];
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"outUBID"];
            NSLog(@"inUserBankID:%ld",[self.inUserBank.userBankID integerValue]);
            NSLog(@"inUserBankName:%@",[self.inUserBank bankName]);
        }
        //如果是银行支出，只选择出账银行即可
        else if ([self.checkFlowType.inOutType isEqualToString:@"out"])
        {
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"inUBID"];
            [request addPostValue:self.outUserBank.userBankID forKey:@"outUBID"];
            NSLog(@"outUserBankID:%ld",[self.outUserBank.userBankID integerValue]);
            NSLog(@"outUserBankName:%@",[self.outUserBank bankName]);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择资金类型"
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [request addPostValue:self.txtRemark.text forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    //转账
    else if ([self.keepType isEqualToString:__fm_KPTypeOfChange_String])
    {
        NSString *requestURL = [__fm_serverIP stringByAppendingString:__fm_apiPath_doZhuanZhang];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 300;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInt:13] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        [request addPostValue:self.checkFeeItem.feeItemID forKey:@"feeItemID"];
        [request addPostValue:self.checkFeeItem.feeItemName forKey:@"feeItemName"];
        [request addPostValue:[NSNumber numberWithDouble:[self.txtMoney.text doubleValue]] forKey:@"money"];
        [request addPostValue:self.inUserBank.userBankID forKey:@"inUBID"];
        [request addPostValue:self.outUserBank.userBankID forKey:@"outUBID"];
        [request addPostValue:self.txtRemark.text forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择一个记账类型"
                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

-(void)bookKeepFinished:(ASIHTTPRequest *) request
{
    NSString *bkType = @"记账成功";
    NSLog(@"返回的字符串:%@",[request responseString]);
    if ([[request responseString] containsString:@"bSuccess\":true"] ) {
        if (request.tag == 100)
        {
            bkType = @"现金记账成功";
        }
        else if (request.tag == 200)
        {
            bkType = @"银行记账成功";
        }
        else if (request.tag == 300)
        {
            bkType = @"转账记账成功";
        }
    }else{
        if (request.tag == 100)
        {
            bkType = @"现金记账失败";
        }
        else if (request.tag == 200)
        {
            bkType = @"银行记账失败";
        }
        else if (request.tag == 300)
        {
            bkType = @"转账记账失败";
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:bkType message:[request responseString]
                                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)bookKeepFailed:(ASIHTTPRequest *) request
{
    [[[UIAlertView alloc] initWithTitle:@"记账失败" message:[request responseString]
                          delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual: @"jumpToCheckFeeItemPage"]) {
        [(CheckFeeItemViewController *)[segue destinationViewController] setDelegate:self];
    }
}

/*********************tableView代理********************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    static NSString *cellBankID = @"cellBankID";
    if (!_isRegistNib) {
        UINib *nib = [UINib nibWithNibName:@"LycTableCellViewDefault" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _isRegistNib = !_isRegistNib;
        
        UINib *nib2 = [UINib nibWithNibName:@"LycTableCellViewDefault2" bundle:nil];
        [tableView registerNib:nib2 forCellReuseIdentifier:cellBankID];
        _isRegistNib = !_isRegistNib;
    }
    NSInteger sectioinNo = indexPath.section;
    NSInteger rowNo = indexPath.row;
    if (sectioinNo == 0) {
        LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[tableView dequeueReusableCellWithIdentifier:cellID];
        cell.lblTitle.text = [[tableData objectAtIndex:sectioinNo] objectAtIndex:rowNo];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //给可能的value赋一个默认值
        if ([cell.lblValue.text isEqual:@""]) {
            if (sectioinNo == 0) {
                if (rowNo == 0) {
                    cell.lblValue.text = [_shortDateFormatter stringFromDate:[NSDate date]];
                }
            }
        }
        return cell;
    }
    else if (sectioinNo == 1) {
        LycTableCellViewDefault2 *cell = (LycTableCellViewDefault2 *)[tableView dequeueReusableCellWithIdentifier:cellBankID];
        cell.lblTitle.text = [[tableData objectAtIndex:sectioinNo] objectAtIndex:rowNo];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[tableView cellForRowAtIndexPath:indexPath];*/
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showDatePicker];
    }
    //点击记账类型cell，跳转到选择资金类型页面
    else if (indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)) {
        if (!self.flowTypeController) {
            CheckFlowTypeViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"checkflowtypeNib"];
            cv.delegate = self;
            _flowTypeController = cv;
        }
        [self.navigationController pushViewController:self.flowTypeController animated:YES];
    }
    //如果点击费用科目，跳转到费用科目选择页面
    else if (indexPath.section == 0 && indexPath.row == 3) {
        //UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckFlowTypeViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"checkFeeItemNib"];
        cv.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:cv animated:YES completion:nil];
        });
        //[self performSegueWithIdentifier:@"jumpToCheckFeeItemPage" sender:@"checkFeeItem"];
    }
    //如果点击费用科目，跳转到费用科目选择页面
    else if (indexPath.section == 1) {
        //UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckUserBankViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"checkUserBankNib"];
        cv.delegate = self;
        if(indexPath.row == 0)
        {
            cv.inOutBankType = @"out";
        }
        else if (indexPath.row == 1)
        {
            cv.inOutBankType = @"in";
        }
        else
        {
            cv.inOutBankType = @"";
        }
        [self.navigationController pushViewController:cv animated:YES];
    }
}
/*********************tableView代理********************/



/****************实现页面数据委托相关方法****************/
//获得所有费用科目，keys为一级费用科目
-(NSArray *)getTheFeeItemList
{
    return _feeItemList;
}
//获得所有资金类型，keys为记账类型，values为资金类型
-(NSDictionary *)getTheFlowTypeList
{
    return _flowTypeList;
}

//设置记账日期
-(void)setTheApplyDate:(NSString *) appDate
{
    _applyDate = appDate;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.lblValue.text = appDate;
}
//设置记账类型
-(void)setTheKeepType:(NSString *) kType
{
    _keepType = kType;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.lblValue.text = kType;
}
//设置资金类型
-(void)setTheCheckFlowType:(Local_FlowType *) lft
{
    _checkFlowType = lft;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.lblValue.text = lft.name;
}
//设置费用科目
-(void)setTheCheckFeeItem:(Local_FeeItem *) lfi
{
    _checkFeeItem = lfi;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.lblValue.text = lfi.feeItemName;
}
//设置出账银行
-(void)setTheOutUserBank:(Local_UserBank *) oub
{
    _outUserBank = oub;
    LycTableCellViewDefault2 *cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.lblValueTop.text = oub.bankName;
    cell.lblValueBottom.text = oub.cardNo;
}
//设置入账银行
-(void)setTheInUserBank:(Local_UserBank *) iub
{
    _inUserBank = iub;
    LycTableCellViewDefault2 *cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.lblValueTop.text = iub.bankName;
    cell.lblValueBottom.text = iub.cardNo;
}
//设置记账金额
-(void)setTheApplyMoney:(CGFloat) money
{
    _applyMoney = money;
}

-(void)setTheTest:(Local_UserBank *)a
{
    _test = a;
}
/****************实现页面数据委托相关方法****************/
@end
