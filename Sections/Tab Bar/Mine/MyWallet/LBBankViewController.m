//
//  LBBankViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/7/9.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBBankViewController.h"
#import "LBDetailAddViewController.h"
#import "UtilsMacro.h"
#import "AppMacro.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import <UIImageView+WebCache.h>
//#import "LBAddBankViewController.h"
static NSString *cid=  @"cid";
@interface LBBankViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIButton *setDefaultButton;
    NSMutableArray *bankListDatas;
}
@property (nonatomic, strong) UITableView *_tableView;

@end

@implementation LBBankViewController
@synthesize _tableView;
@synthesize isChangeBank;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡列表";
//    isChangeBank = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"add_bank") style:UIBarButtonItemStylePlain target:self action:@selector(addBank)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _tableView = ({
        UITableView *tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        tableView.delegate =self;
        tableView.dataSource = self;
        tableView;
    });
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
   
}

- (void)loadBankListDatas_URL:(NSString *)URL bankcard_id:(NSString *)bankcard_id type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
    if (bankcard_id == nil) {
        parameter = @{@"key":key};
    }else{
        parameter = @{@"key":key,@"bankcard_id":bankcard_id};
    }

    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:URL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        if ([type isEqualToString:@"0"]) {
            NSLog(@"我的银行卡列表:%@",responObject);
            bankListDatas = responObject[@"datas"];
            if ([bankListDatas isEqual:[NSNull null]]) {
                NSLog(@"银行卡为空");
//                UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没添加银行卡呢,去填写银行卡吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alertView.tag = 101;
//                [alertView show];
                bankListDatas = nil;
                _tableView.backgroundView = [[UIImageView alloc] initWithImage:IMAGE(@"no_record")];
            }else{
                _tableView.backgroundView = [UIView new];
            }
            [_tableView reloadData];
        }
        //删除
        else if ([type isEqualToString:@"1"]){
            NSLog(@"删除我的银行卡:%@",responObject);
            [SVProgressHUD showSuccessWithStatus:@"删除成功" maskType:SVProgressHUDMaskTypeClear];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            [self loadBankListDatas_URL:SUGE_LISTBANK bankcard_id:nil type:@"0"];

        }
        //设为默认
        else if ([type isEqualToString:@"2"]){
            NSLog(@"设为默认我的银行卡:%@",responObject);
            
            [self loadBankListDatas_URL:SUGE_LISTBANK bankcard_id:nil type:@"0"];                
            
        }

        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];
}

- (void)addBank
{
    LBDetailAddViewController *add = [[LBDetailAddViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bankListDatas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
//
    }
    if (isChangeBank) {
        
//        NSLog(@"选择银行卡");
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //银行卡图标
    UIImageView *bankIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [bankIcon sd_setImageWithURL:[NSURL URLWithString:bankListDatas[row][@"bank"][@"bank_logo"]] placeholderImage:IMAGE(@"")];
    [cell addSubview:bankIcon];
    //银行卡ming
    UILabel *bankName = [[UILabel alloc] initWithFrame:CGRectMake(bankIcon.frame.origin.x+bankIcon.frame.size.width+10, 0, 200, 20)];
    bankName.text = bankListDatas[row][@"bank"][@"bank_name"];
    bankName.font = BFONT(15);
    [cell addSubview:bankName];
    //支行名
    UILabel *branchName = [[UILabel alloc] initWithFrame:CGRectMake(bankName.frame.origin.x, bankName.frame.origin.y+bankName.frame.size.height, SCREEN_WIDTH-20-bankIcon.frame.origin.x-bankIcon.frame.size.width, 20)];
   branchName.text = bankListDatas[row][@"branch_name"];
    branchName.textAlignment=NSTextAlignmentLeft;
    branchName.font = BFONT(15);
    [cell addSubview:branchName];

    //账户名
    UILabel *accountName = [[UILabel alloc] initWithFrame:CGRectMake(branchName.frame.origin.x, branchName.frame.origin.y+branchName.frame.size.height, 100, 30)];
    accountName.font  = FONT(14);
    accountName.textColor = [UIColor grayColor];
    accountName.text = [NSString stringWithFormat:@"账户名:%@",bankListDatas[row][@"account_name"]];
    [cell addSubview:accountName];
    //银行卡号
    UILabel *bankNum = [[UILabel alloc] initWithFrame:CGRectMake(accountName.frame.origin.x+accountName.frame.size.width, accountName.frame.origin.y, SCREEN_WIDTH-(accountName.frame.origin.x+accountName.frame.size.width)-20, 30)];
    bankNum.font  = FONT(14);
    bankNum.textAlignment = NSTextAlignmentRight;
    bankNum.textColor = [UIColor grayColor];
    bankNum.text = bankListDatas[row][@"bankcard_number"];
    [cell addSubview:bankNum];
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, accountName.frame.origin.y+accountName.frame.size.height+5, SCREEN_WIDTH-40, 1)];
    line.backgroundColor =  [UIColor lightGrayColor];
    [cell addSubview:line];
    
    
    setDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setDefaultButton.frame=  CGRectMake(20, line.frame.origin.y+line.frame.size.height+10, 25, 25);
    [setDefaultButton setTag:[bankListDatas[row][@"bankcard_id"] integerValue]];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check1@2x") forState:0];
    [setDefaultButton setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
    [setDefaultButton addTarget:self action:@selector(setDefaultBank:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:setDefaultButton];
    NSString *is_default = bankListDatas[row][@"is_default"];
    if ([is_default isEqualToString:@"1"]) {
        setDefaultButton.selected  =YES;
    }
    
    UILabel *setDefaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(setDefaultButton.frame.origin.x+setDefaultButton.frame.size.width, setDefaultButton.frame.origin.y, 80, 25)];
    setDefaultLabel.font = FONT(13);
    setDefaultLabel.text = @"设为默认";
    [cell addSubview:setDefaultLabel];
    
    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleButton.frame=  CGRectMake(SCREEN_WIDTH-80, line.frame.origin.y+line.frame.size.height+10, 60, 25);
    [deleButton setBackgroundColor:APP_COLOR];
    [deleButton setTitle:@"删除" forState:0];
    [deleButton setTag:[bankListDatas[row][@"bankcard_id"] integerValue]];
    [deleButton setTitleColor:[UIColor whiteColor] forState:0];
    [deleButton addTarget:self action:@selector(deleBank:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleButton];

    return cell;
}
//删除银行卡
- (void)deleBank:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSString *row1 = [NSString stringWithFormat:@"%ld",(long)row];
    NSLog(@"row1:%@",row1);
    [self loadBankListDatas_URL:SUGE_DELBANK bankcard_id:row1 type:@"1"];
}

//设为默认
- (void)setDefaultBank:(UIButton *)btn
{
    NSInteger row = btn.tag;
    NSString *row1 = [NSString stringWithFormat:@"%ld",(long)row];
    NSLog(@"row1:%@",row1);
   
   [self loadBankListDatas_URL:SUGE_DEFAULTBANK bankcard_id:row1 type:@"2"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *bankname = bankListDatas[row][@"bank"][@"bank_name"];
    NSString *accouname =bankListDatas[row][@"account_name"];
    NSString *num =bankListDatas[row][@"bankcard_number"];
    NSDictionary *value = @{@"bankname":bankname,@"bankno":num,@"bankuser":accouname};
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isChangeBank) {
        [NOTIFICATION_CENTER postNotificationName:@"CHANGE_BANK" object:nil userInfo:value];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"选择银行卡");
    }else{
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (buttonIndex == 1){
            [self.navigationController pushViewController:[LBDetailAddViewController new] animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadBankListDatas_URL:SUGE_LISTBANK bankcard_id:nil type:@"0"];
}

@end
