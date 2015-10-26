//
//  LBWithdrawalViewController.m
//  SuGeMarket
//  余额提现
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBWithdrawalViewController.h"
#import "UtilsMacro.h"
#import "LBrecordViewController.h"
#import "LBBankViewController.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import <FXBlurView.h>
#import "AppMacro.h"
#import <UIImageView+WebCache.h>
#import "LBBankViewController.h"
#import "ZCTradeView.h"
#import "LBrecordViewController.h"

static NSString *cid = @"cid";

@interface LBWithdrawalViewController ()<UITableViewDataSource,UITableViewDelegate,ZCTradeViewDelegate,UITextFieldDelegate>
{
    NSArray *nameArray,*numArray;
    UITableView *WithdrawalTableView;
    UIButton *recordButton,*withdrawalButton;
    
    UILabel *useMenoyLabel;
    UITextField *tixianText;
    UILabel *bankLabel;
    UILabel *timeLabel;
    
    NSString *kBankName;
    NSString *kBankNum;
    NSString *kBankUserName;
    NSString *psw;
    ZCTradeView *pswVC;
    NSString *_predeposit;
}
@end

@implementation LBWithdrawalViewController
@synthesize moeny;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"佣金提现";
    _predeposit = moeny;
    [NOTIFICATION_CENTER addObserver:self selector:@selector(changeBank:) name:@"CHANGE_BANK" object:nil];
    nameArray = @[@[@"可提现金额",@"提现金额"],@[@"提现到银行卡",@"预计到账时间"]];

    [self initMyWithdrawalView];
    ;
    pswVC = [[ZCTradeView alloc] init];
}

//通知传值
- (void)changeBank:(id)sender
{
    kBankName = [[sender userInfo] objectForKey:@"bankname"];
    kBankNum = [[sender userInfo] objectForKey:@"bankno"];
    kBankUserName  = [[sender userInfo] objectForKey:@"bankuser"];
    bankLabel.text  =kBankName;
}

-(void)initMyWithdrawalView
{
    WithdrawalTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    WithdrawalTableView.delegate = self;
    WithdrawalTableView.dataSource = self;
    WithdrawalTableView.showsHorizontalScrollIndicator = YES;
    WithdrawalTableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [WithdrawalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    WithdrawalTableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];

   // WithdrawalTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:WithdrawalTableView];
    
    
    withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawalButton.frame = CGRectMake(WithdrawalTableView.frame.origin.x+5,WithdrawalTableView.frame.origin.y+280, SCREEN_WIDTH-10, 50);
    [withdrawalButton setImage:IMAGE(@"tixianjj") forState:0];
    [withdrawalButton addTarget:self action:@selector(tixianMoney:) forControlEvents:UIControlEventTouchUpInside];
    [WithdrawalTableView addSubview:withdrawalButton];
    
    recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake(WithdrawalTableView.frame.origin.x+5, withdrawalButton.frame.origin.y+withdrawalButton.frame.size.height+10, SCREEN_WIDTH-10, 50);
    [recordButton addTarget:self action:@selector(pushrecordView:)forControlEvents:UIControlEventTouchUpInside];
    [recordButton setTitle:@"佣金提现记录" forState:0];
    [recordButton setTitleColor:[UIColor blackColor] forState:0];
    [recordButton setBackgroundColor:RGBCOLOR(240, 240,240)];
    
    [WithdrawalTableView addSubview:recordButton];
    
}
//记录
-(void)pushrecordView:(UIButton *)btn
{
    LBrecordViewController *record=[[LBrecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
    
}

//提现
- (void)tixianMoney:(UIButton *)btn
{
    float useMM = [moeny floatValue];
    float tixianMM = [tixianText.text floatValue];
    if (tixianMM >useMM||tixianText.text.length == 0||[tixianText.text floatValue]==0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的金额有误,请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }else if ([bankLabel.text isEqualToString:@"请选择银行卡"]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有选择选择银行卡呢!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }else if (tixianMM<10){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"提现金额不能少于10元" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }else{
        
        psw  = nil;
        [pswVC show];
        __weak typeof(self) weakSelf = self;
        pswVC.finish = ^(NSString *passWord){
            psw = passWord;
            [weakSelf loadTixianDatas];
        };

        /*
        psw = nil;
        UIAlertView *pswView = [[UIAlertView alloc] initWithTitle:@"交易密码" message:@"请输入交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        pswView.tag = 1010;
        [pswView setAlertViewStyle:UIAlertViewStyleSecureTextInput];

        [pswView show];
        */
        
    }
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 1010) {
//        NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
//        UITextField * text1 = [alertView textFieldAtIndex:0];
//        text1.keyboardType = UIKeyboardTypeDefault;
//        psw = text1.text;
//    
//        if ([btnTitle isEqualToString:@"确定"] ) {
//            [self loadTixianDatas];
//        }
//    }
//    
//}

//提现请求

- (void)loadTixianDatas
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key,@"pdc_bank_name":kBankName,@"pdc_bank_no":kBankNum,@"pdc_bank_user":kBankUserName,@"password":psw,@"pdc_amount":tixianText.text};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_PD_CASH_ADD parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"提现:%@",responObject);
        NSDictionary *datas = responObject[@"datas"];
        NSArray *kk = [datas allKeys];
        NSString *kk1 = kk[0];
        if ([kk1 isEqual:@"predeposit"]) {
            
            [TSMessage showNotificationWithTitle:@"提现成功!" type:TSMessageNotificationTypeSuccess];
            _predeposit  = responObject[@"datas"][@"predeposit"];
            [WithdrawalTableView reloadData];
//            LBrecordViewController *record = [[LBrecordViewController alloc] init];
//            
//            [self.navigationController pushViewController:record animated:YES];
           NSLog(@"提现成功...");
        }else{
            [TSMessage showNotificationWithTitle:@"密码错误!请重新输入." type:TSMessageNotificationTypeWarning];
            
            NSLog(@"提现不成功...");
        }
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        
    }
    cell.textLabel.text=[[nameArray objectAtIndex:section] objectAtIndex:row];

    if (section == 0) {
        if (row == 0) {
            useMenoyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            useMenoyLabel.textAlignment = NSTextAlignmentRight;

            useMenoyLabel.text = _predeposit;
            cell.accessoryView = useMenoyLabel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (row ==1){
            tixianText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
            tixianText.font = FONT(17);
            tixianText.delegate = self;
            tixianText.textAlignment = NSTextAlignmentRight;
//            tixianText.keyboardType =  UIKeyboardTypeNumberPad;
            tixianText.placeholder = @"请输入提现金额";
            cell.accessoryView = tixianText;

        }
    }else if (section == 1){
        if (row == 0) {
            bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
            bankLabel.textAlignment = NSTextAlignmentRight;
            bankLabel.text = @"请选择银行卡>>>";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = bankLabel;
        }else if (row ==1){
            timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
            timeLabel.font = FONT(15);
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.textColor = [UIColor lightGrayColor];
            timeLabel.text = @"3个工作日内到账";
            cell.accessoryView = timeLabel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    

    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return nameArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[nameArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section =indexPath.section;
    NSInteger row = indexPath.row;
    [WithdrawalTableView deselectRowAtIndexPath:indexPath animated:YES];
    LBBankViewController *bank = [[LBBankViewController alloc] init];
    if (section == 1) {
        if (row == 0) {
            bank.isChangeBank = YES;
            [self.navigationController pushViewController:bank animated:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tixianText resignFirstResponder];
    return YES;
}

@end
