//
//  BKViewController.m
//  FamilyManagerApp
//
//  Created by ESI on 15/5/14.
//  Copyright (c) 2015年 LYC. All rights reserved.
//

#import "BKViewController.h"
#import "AppConfiguration.h"
#import "AppDelegate.h"
#import "LycTableCellViewDefault.h"
#import "LycTableCellViewDefault2.h"
#import "ASIFormDataRequest.h"
#import "CheckFlowTypeViewController.h"
#import "CheckFeeItemViewController.h"
#import "CheckUserBankViewController.h"

#import "Local_FeeItemDAO.h"
#import "Local_FlowTypeDAO.h"

@interface BKViewController ()
{
    BOOL _isRegistNib;
    int _isEditTextIndex;//0：正在编辑金额; 1：正在编辑备注
    NSDateFormatter *_shortDateFormatter;
    NSMutableArray *_arraybase;
    NSMutableArray *_arrayBank;
    NSArray *_arrayMoney;
    NSArray *tableData;
    dispatch_queue_t sQueue;//定义一个串行队列
}
@end

@implementation BKViewController

/*********************View生命周期监听**********************/
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些view的样式
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.DatePickerBox.hidden = YES;
    _dialogView = [[LycDialogView alloc] initWithTitle:@"正在加载" andSuperView:self.view];
    
    //设置table的数据源并初始化数据
    _arrayMoney = [NSArray arrayWithObjects:@"金额",@"备注", nil];
    _isRegistNib = NO;
    _shortDateFormatter = [DateFormatterHelper getShortDateFormatter];
    _applyDate = [_shortDateFormatter stringFromDate:[NSDate date]];
    [self loadTableViewData];
    self.tableview1.dataSource = self;
    self.tableview1.delegate = self;
    
    //设置导航条
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                         style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    [btnRight setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor ]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnRight;
    
    //初始化控制器属性
    //初始化资金类型
    _flowTypeList = [[NSMutableDictionary alloc] initWithObjects:
                                                [NSArray arrayWithObjects:
                                                    [[NSMutableArray alloc] init],
                                                    [[NSMutableArray alloc] init],
                                                    [[NSMutableArray alloc] init], nil]
                                                forKeys:@[__fm_KPTypeOfCash_String,__fm_KPTypeOfBank_String,__fm_KPTypeOfChange_String]];
    
    [self loadBaseData];
    
    //注册键盘事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearHandler:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_tapGesture == nil) {
        //轻点手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        tapGesture.numberOfTapsRequired = 1;
        _tapGesture = tapGesture;
        [_tapGesture setEnabled:NO];
        [self.tableview1 addGestureRecognizer:self.tapGesture];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    LYCLog(@"记账页面收到内存警告！！！！");
    [self disposeResource];
}

-(void)dealloc
{
    LYCLog(@"记账页面被销毁了");
    LYCLog(@"keepType -- %@",_keepType);
    _keepType = nil;     //记账类型
    _checkFeeItem = nil;    //选择的费用科目
    _dialogView = nil;
    //清除本控制器监听的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btnOKDate_Click:(id)sender {
    [self hideDatePickerBox];
    
    [self setTheApplyDate:[_shortDateFormatter stringFromDate:self.dataPicker.date]];
}

- (IBAction)btnCancelDate_Click:(id)sender {
    [self hideDatePickerBox];
}

/*********************View生命周期监听**********************/


/*********************私有方法*********************/
-(void)loadTableViewData
{
    _arraybase = [NSMutableArray arrayWithObjects:@"记账日期",@"记账类型",@"资金流动类型",@"费用科目",nil];
    _arrayBank = [NSMutableArray arrayWithObjects:@"出账银行",@"入账银行",nil];
    tableData = @[_arraybase,_arrayBank, _arrayMoney];
}

-(void)reloadTableViewData
{
    if ([self.checkFlowType.inOutType isEqualToString:@"out"])
    {
        //如果是支出，要显示费用科目的选项
        [_arraybase removeAllObjects];
        [_arraybase addObject:@"记账日期"];
        [_arraybase addObject:@"记账类型"];
        [_arraybase addObject:@"资金流动类型"];
        [_arraybase addObject:@"费用科目"];

    }
    else
    {
        //如果是收入或者转账，要隐藏掉费用科目的选项
        [_arraybase removeAllObjects];
        [_arraybase addObject:@"记账日期"];
        [_arraybase addObject:@"记账类型"];
        [_arraybase addObject:@"资金流动类型"];
    }
    
    
    //如果是现金记账，隐藏选择银行的section
    if ([self.keepType isEqualToString:__fm_KPTypeOfCash_String]) {
        [_arrayBank removeAllObjects];
    }
    //如果是银行记账
    else if ([self.keepType isEqualToString:__fm_KPTypeOfBank_String])
    {
        //如果是收入，只显示入账银行选项
        if ([self.checkFlowType.inOutType isEqualToString:@"in"]) {
            [_arrayBank removeAllObjects];
            [_arrayBank addObject:@"入账银行"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString:@"out"])
        {
            //如果是支出，只显示出账银行选项
            [_arrayBank removeAllObjects];
            [_arrayBank addObject:@"出账银行"];
        }
    }
    //如果是内部转账
    else
    {
        if ([self.checkFlowType.inOutType isEqualToString:@"取现"]) {
            [_arrayBank removeAllObjects];
            [_arrayBank addObject:@"出账银行"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString:@"存钱"])
        {
            [_arrayBank removeAllObjects];
            [_arrayBank addObject:@"入账银行"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString:@"内部转账"])
        {
            [_arrayBank removeAllObjects];
            [_arrayBank addObject:@"出账银行"];
            [_arrayBank addObject:@"入账银行"];
        }
    }
    if (_arrayBank.count == 0) {
        tableData = @[_arraybase, _arrayBank, _arrayMoney];
    }else
    {
        tableData = @[_arraybase,_arrayBank, _arrayMoney];
    }
    [self.tableview1 reloadData];
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
                
            });
            
        });
        
    }
}

//键盘出现、隐藏通知
-(void)keyboardAppearHandler:(NSNotificationCenter *) noti
{
    NSDictionary *notInfo = [noti valueForKey:@"userInfo"];
    CGRect keyBoardRect = [notInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [notInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, keyBoardRect.origin.y - self.view.frame.size.height);
    }];
}

//隐藏日期选择box
-(void)hideDatePickerBox
{
    self.datePickerBottomConstraint.constant = -50;
    [UIView animateWithDuration:0.3 animations:^(void){
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.DatePickerBox.hidden = YES;
        }
    }];
    
    _isShowDatePicker = NO;
}

//显示日期选择box
-(void)showDatePickerBox
{
    self.DatePickerBox.hidden = NO;
    [self.datePickerBottomConstraint setConstant:200];
    [UIView animateWithDuration:0.3 animations:^(void){
        [self.view layoutIfNeeded];
    }];
    _isShowDatePicker = YES;
}

//隐藏键盘
-(void)hideKeyBoard
{
    /*
    UITableViewCell *cell = [self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_isEditTextIndex inSection:2]];
    [[cell viewWithTag:302] resignFirstResponder];*/
    [self.view endEditing:YES];
    [_tapGesture setEnabled:NO];
}

-(void)disposeResource
{
    LYCLog(@"释放资源");
    _flowTypeController = nil;  //释放选择资金类型controller
    _checkFlowType = nil;       //释放已选资金类型
    _checkFeeItem = nil;        //释放已选费用科目
    _inUserBank = nil;          //释放已选入账银行
    _outUserBank = nil;         //释放已选出账银行
    _applyRemark = nil;         //释放备注信息
    _keepType = nil;
    //[self disposeDatePicker];   //释放日期选择控件
    //释放轻击table隐藏键盘 手势检测器
    [self.tableview1 removeGestureRecognizer:_tapGesture];
    _tapGesture = nil;
}


//提交记账数据
-(void)submit
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //获取app参数
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [ud boolForKey:__fm_defaultsKey_loginUser_Status];

    NSString *warnTitle;
    NSString *warnInfo;
    if (app.isConnectNet == NO) {
        warnTitle = @"网络未连接";
        warnInfo = @"当前版本必须联网才能记账！";
    }
    else if (isLogin == NO){
        warnTitle = @"您还未登陆";
        warnInfo = @"当前版本必须登陆后才能记账！";
    }
    else if (self.applyDate == nil) {
        warnTitle = @"请填写完整信息";
        warnInfo = @"记账日期必须选择！";
    }
    else if (self.keepType == nil) {
        warnTitle = @"请填写完整信息";
        warnInfo = @"记账类型必须选择！";
    }
    else if (self.checkFlowType == nil) {
        warnTitle = @"请填写完整信息";
        warnInfo = @"资金类型必须选择！";
    }
    else if ([self.checkFlowType.inOutType isEqual:@"out"] && self.checkFeeItem == nil) {
        warnTitle = @"请填写完整信息";
        warnInfo = @"支出记账必须选择费用科目！";
    }
    else if (self.applyMoney <= 0) {
        warnTitle = @"请填写完整信息";
        warnInfo = @"请填写正确的金额，必须大于0！";
    }
    //如果有警告信息，提示框弹出，终止提交操作
    if (warnTitle != nil) {
        UIAlertView *warnAlert = [[UIAlertView alloc] initWithTitle:warnTitle message:warnInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [warnAlert show];
        return;
    }
    
    [_dialogView showDialog:nil];
    
    NSInteger userID = [ud integerForKey:__fm_defaultsKey_loginUser_ID];
    //现金记账
    if ([self.keepType isEqualToString:__fm_KPTypeOfCash_String]) {
        NSString *requestURL = [__fm_userDefaults_serverIP stringByAppendingString:__fm_apiPath_doCashAccounting];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 100;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        //如果是现金收入，费用项目传空字符串
        if ([self.checkFlowType.inOutType isEqualToString: @"in"])
        {
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"feeItemID"];
            [request addPostValue:@"" forKey:@"feeItemName"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString: @"out"])
        {
            [request addPostValue:self.checkFeeItem.feeItemID forKey:@"feeItemID"];
            [request addPostValue:self.checkFeeItem.feeItemName forKey:@"feeItemName"];
        }
        else
        {
            [_dialogView hideDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择资金类型"
                                                      delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [request addPostValue:[NSNumber numberWithDouble:self.applyMoney] forKey:@"money"];
        [request addPostValue:self.applyRemark forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    //银行记账
    else if ([self.keepType isEqualToString:__fm_KPTypeOfBank_String])
    {
        NSString *requestURL = [__fm_userDefaults_serverIP stringByAppendingString:__fm_apiPath_doBankAccounting];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 200;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        [request addPostValue:[NSNumber numberWithDouble:self.applyMoney] forKey:@"money"];
        //如果是银行收入，只选择入账银行即可
        if ([self.checkFlowType.inOutType isEqualToString:@"in"]) {
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"feeItemID"];
            [request addPostValue:@"" forKey:@"feeItemName"];
            [request addPostValue:self.inUserBank.userBankID forKey:@"inUBID"];
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"outUBID"];
        }
        //如果是银行支出，只选择出账银行即可
        else if ([self.checkFlowType.inOutType isEqualToString:@"out"])
        {
            [request addPostValue:self.checkFeeItem.feeItemID forKey:@"feeItemID"];
            [request addPostValue:self.checkFeeItem.feeItemName forKey:@"feeItemName"];
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"inUBID"];
            [request addPostValue:self.outUserBank.userBankID forKey:@"outUBID"];
        }
        else
        {
            [_dialogView hideDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择资金类型"
                                                      delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [request addPostValue:self.applyRemark forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    //转账
    else if ([self.keepType isEqualToString:__fm_KPTypeOfChange_String])
    {
        NSString *requestURL = [__fm_userDefaults_serverIP stringByAppendingString:__fm_apiPath_doZhuanZhang];
        ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
        request.tag = 300;
        request.delegate = self;
        request.shouldAttemptPersistentConnection = YES;
        request.requestMethod = @"POST";
        [request addPostValue:[NSNumber numberWithInteger:userID] forKey:@"userID"];
        [request addPostValue:self.applyDate forKey:@"ApplyDate"];
        [request addPostValue:self.checkFlowType.flowTypeID forKey:@"FlowTypeID"];
        [request addPostValue:[NSNumber numberWithInt:0] forKey:@"feeItemID"];
        [request addPostValue:@"" forKey:@"feeItemName"];
        [request addPostValue:[NSNumber numberWithDouble:self.applyMoney] forKey:@"money"];
        if ([self.checkFlowType.inOutType isEqualToString: @"存钱"])
        {
            [request addPostValue:self.inUserBank.userBankID forKey:@"inUBID"];
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"outUBID"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString: @"取现"])
        {
            [request addPostValue:[NSNumber numberWithInt:0] forKey:@"inUBID"];
            [request addPostValue:self.outUserBank.userBankID forKey:@"outUBID"];
        }
        else if ([self.checkFlowType.inOutType isEqualToString: @"内部转账"])
        {
            [request addPostValue:self.inUserBank.userBankID forKey:@"inUBID"];
            [request addPostValue:self.outUserBank.userBankID forKey:@"outUBID"];
        }
        else
        {
            [_dialogView hideDialog];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择资金类型"
                                                           delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [request addPostValue:self.applyRemark forKey:@"cAdd"];
        [request setDidFinishSelector:@selector(bookKeepFinished:)];
        [request setDidFailSelector:@selector(bookKeepFailed:)];
        [request startAsynchronous];
    }
    else{
        [_dialogView hideDialog];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账错误" message:@"请重新选择一个记账类型"
                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//记账完成回调函数
-(void)bookKeepFinished:(ASIHTTPRequest *) request
{
    [_dialogView hideDialog];
    NSString *bkType = @"记账成功";
    NSData *responseData = [request responseData];
    ApiJsonHelper *aj = [[ApiJsonHelper alloc] initWithData:responseData requestName:bkType];
    if (aj.bSuccess == YES) {
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:bkType message:aj.message
                                              delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//记账失败回调函数
-(void)bookKeepFailed:(ASIHTTPRequest *) request
{
    [_dialogView hideDialog];
    NSString *responseString = [request responseString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"记账失败" message:responseString
                          delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - Navigation

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
        //section == 2
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell"];
        UILabel *lbltitle = (UILabel *)[cell viewWithTag:301];
        lbltitle.text = [[tableData objectAtIndex:sectioinNo] objectAtIndex:rowNo];
        UITextField *txtValue = (UITextField *)[cell viewWithTag:302];
        if (rowNo == 0) {
            txtValue.placeholder = @"请输入金额";
        }
        else
        {
            txtValue.placeholder = @"如有需要可输入备注信息";
        }
        txtValue.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
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
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击日期弹出日期选择
    if (indexPath.section == 0 && indexPath.row == 0) {
        //[self showDatePicker];
        if (_isShowDatePicker == NO) {
            [self showDatePickerBox];
        }else { [self hideDatePickerBox]; }
        
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
    }
    //如果点击费用科目，跳转到费用科目选择页面
    else if (indexPath.section == 1) {
        //UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CheckUserBankViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"checkUserBankNib"];
        cv.delegate = self;
        if (_arrayBank.count == 0) {
            return;
        }
        else if (_arrayBank.count == 1) {
            if([_arrayBank[0] isEqualToString:@"出账银行"])
            {
                cv.inOutBankType = @"out";
            }
            else
            {
                cv.inOutBankType = @"in";
            }
        }
        else
        {
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
    //self.ccontroller.B_keepType = self.keepType;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.lblValue.text = kType;
}
//设置资金类型
-(void)setTheCheckFlowType:(Local_FlowType *) lft
{
    _checkFlowType = lft;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.lblValue.text = lft.name;
    //设置相关选项的隐藏和显示
    [self reloadTableViewData];
}
//设置费用科目
-(void)setTheCheckFeeItem:(Local_FeeItem *) lfi
{
    _checkFeeItem = lfi;
    //self.ccontroller.B_checkFeeItem = self.checkFeeItem;
    LycTableCellViewDefault *cell = (LycTableCellViewDefault *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.lblValue.text = lfi.feeItemName;
}
//设置出账银行
-(void)setTheOutUserBank:(Local_UserBank *) oub
{
    _outUserBank = oub;
    LycTableCellViewDefault2 *cell;
    if (_arrayBank.count == 2) {
        cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    else if (_arrayBank.count == 1 && [_arrayBank[0] isEqualToString:@"出账银行"])
    {
        cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    cell.lblValueTop.text = oub.bankName;
    cell.lblValueBottom.text = oub.cardNo;
}
//设置入账银行
-(void)setTheInUserBank:(Local_UserBank *) iub
{
    _inUserBank = iub;
    LycTableCellViewDefault2 *cell;
    if (_arrayBank.count == 2) {
        cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    }
    else if (_arrayBank.count == 1 && [_arrayBank[0] isEqualToString:@"入账银行"])
    {
        cell = (LycTableCellViewDefault2 *)[self.tableview1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }
    cell.lblValueTop.text = iub.bankName;
    cell.lblValueBottom.text = iub.cardNo;
}
//设置记账金额
-(void)setTheApplyMoney:(CGFloat) money
{
    _applyMoney = money;
}

/****************实现页面数据委托相关方法****************/


/*******************textFieldDelegate实现*******************/

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"请输入金额"]) {
        _isEditTextIndex = 0;
    }
    else
    {
        _isEditTextIndex = 1;
    }
    [_tapGesture setEnabled:YES];
}

//文本编辑结束后给相关记账属性赋值
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 302) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_isEditTextIndex inSection:2];
        UITextField *txt = (UITextField *)[[self.tableview1 cellForRowAtIndexPath:index] viewWithTag:302];
        if (_isEditTextIndex == 0) {
            _applyMoney = [txt.text doubleValue];
        }
        else
        {
            _applyRemark = txt.text;
        }
    }
}

/*******************textFieldDelegate实现*******************/












/************暂不使用的方法************/
//初始化日期选择器视图(不使用)
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
    if (!_mydatePicker) {
        NSDate *now = [NSDate date];
        _mydatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, _screenFrame.size.width, 150)];
        _mydatePicker.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _mydatePicker.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mydatePicker.datePickerMode = UIDatePickerModeDate;
        _mydatePicker.date = now;
        _mydatePicker.tag = 22;
        _mydatePicker.minimumDate = [now dateByAddingTimeInterval:-60*60*24*30 ];
        _mydatePicker.maximumDate = now;
        //[_datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
        [_datePickerContainer addSubview:_mydatePicker];
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
//(不使用)
-(void)cancelDatePickerClick
{
    [self showDatePicker];
}
//(不使用)
-(void)okDatePickerClick
{
    [self setTheApplyDate:[_shortDateFormatter stringFromDate:_mydatePicker.date]];
    [self showDatePicker];
}
//(不使用)
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

/*销毁日期选择器相关view(不使用)*/
-(void)disposeDatePicker
{
    /*销毁日期选择器相关view*/
    [_mydatePicker removeFromSuperview];
    _mydatePicker = nil;
    [_okDatePicker removeFromSuperview];
    _okDatePicker = nil;
    [_cancelDatePicker removeFromSuperview];
    _cancelDatePicker = nil;
    [_datePickerContainer removeFromSuperview];
    _datePickerContainer = nil;
}
@end