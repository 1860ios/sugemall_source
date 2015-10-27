//
//  LBSafeViewController.m
//  SuGeMarket
//
//  账户安全
//  Created by 1860 on 15/7/11.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSafeViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "AppMacro.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "LBBankViewController.h"
#import "LBPayMMViewController.h"
#import "LBBlingViewController.h"
#import "LBBling1ViewController.h"
#import "LBBlingStep1lViewController.h"
#import "LBBlingStepViewController.h"
#import "LBVMoblieViewController.h"
#import "LBValidateIdViewController.h"

static NSString *cid=  @"cid";

@interface LBSafeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *safeTitles;
    NSArray *safeRightTitles;
    NSString *email;
    NSString *isPayPSW;
    UILabel *rightLabel;
    NSString *payMM;
    NSString *mobile;
    
}
@property (nonatomic,strong) UITableView *_tableView;
@end

@implementation LBSafeViewController
@synthesize _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户安全";
    
    safeTitles = @[@"登录密码",@"手机绑定",@"邮箱绑定",@"我的银行卡",@"支付密码"];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.delegate  = self;
        tableView.dataSource = self;
        tableView;
    });
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadIsHaveEmail];
    });
    dispatch_async(queue, ^{
        [self loadIsHavePayMM];
    });
    dispatch_async(queue, ^{

        [self loadIsHaveMob];
    });
    
    
}

//是否绑定手机号
- (void)loadIsHaveMob
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_IS_BLING_MOB parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        
        NSLog(@"是否绑定手机号responObject:%@",responObject);
        mobile = responObject[@"datas"][@"mobile"];
        [_tableView reloadData];
        //        rightLabel.text = email;
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
    

}

//是否邮箱
- (void)loadIsHaveEmail
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_IS_HAV_EMAIL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){

        NSLog(@"是否邮箱responObject:%@",responObject);
        email = responObject[@"datas"][@"email"];
        [_tableView reloadData];
//        rightLabel.text = email;
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
}

//支付密码
- (void)loadIsHavePayMM
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_IS_HAV_PAYMM parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        
        NSLog(@"是否支付密码responObject:%@",responObject);
        if ([responObject[@"datas"] isEqual:@"1"]) {
            isPayPSW = responObject[@"datas"];
        }else{
            isPayPSW = @"0";
        }

        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){

        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return safeTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [safeTitles objectAtIndex:section];
    if (email == nil) {
        email = @"您还未绑定邮箱";
    }
    if (mobile == nil) {
        mobile = @"您还未绑定手机号";
    }
    if (![isPayPSW isEqualToString:@"1"]) {
        payMM = @"设置支付密码";
    }else{
        payMM = @"修改支付密码";
    }
    
    safeRightTitles = @[@"修改密码",mobile,email,@"查看我的银行卡",payMM];
    //
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200, 5, 170, 35)];
    rightLabel.tag = indexPath.row;
    rightLabel.text = [safeRightTitles objectAtIndex:section];
    rightLabel.textColor = [UIColor lightGrayColor];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:rightLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBBlingStep1lViewController *step1 = [[LBBlingStep1lViewController alloc] init];
    LBBlingStepViewController *step = [[LBBlingStepViewController alloc] init];
    LBVMoblieViewController *vmoblie = [[LBVMoblieViewController alloc] init];
    LBValidateIdViewController *valide=[[LBValidateIdViewController alloc]init];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            vmoblie.phoneString=mobile;
        [self.navigationController pushViewController:vmoblie animated:YES];
            break;
            
        case 1:{
            //手机号
            if ([mobile isEqualToString:@"您还未绑定手机号"]) {
                [self.navigationController pushViewController:[LBBlingViewController new] animated:YES];
            }else{
                step.agoNumString=mobile;
                [self.navigationController pushViewController:step animated:YES];
                
            }
        }
            break;
            
        case 2:{
            //邮箱
            if ([email isEqualToString:@"您还未绑定邮箱"] ) {
             [self.navigationController pushViewController:[LBBling1ViewController new] animated:YES];
            }else{
                step1.agoEmailString=email;
             [self.navigationController pushViewController:step1 animated:YES];
            }
            
        }
            break;
        case 3:
            [self.navigationController pushViewController:[LBBankViewController new] animated:YES];
            break;
        case 4:
            valide.numString=mobile;
            [self.navigationController pushViewController:valide animated:YES];

            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

@end
