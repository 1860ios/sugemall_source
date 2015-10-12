//
//  LBSetViewController.m
//  SuGeMarket
//
//  设置
//  Created by 1860 on 15/8/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSetViewController.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import "NotificationMacro.h"
#import "LBUserInfo.h"
#import "MBProgressHUD.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import "LBAboutViewController.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
static NSString *cid = @"cid";

@interface LBSetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *kUrl;
    UIButton *LognOut;//注销
}
@property (nonatomic,strong) UITableView *_tableView;
@end

@implementation LBSetViewController
@synthesize _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
}
- (void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    
    //    __tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cid];
    }
//    cell.imageView.image =
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"关于我们";
    if (section == 0){
        cell.textLabel.text =@"版本更新";
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        cell.detailTextLabel.text = appVersion;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//        footerView.backgroundColor = [UIColor yellowColor];
        LognOut = [UIButton buttonWithType:UIButtonTypeCustom];
        LognOut.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, 40);
        [LognOut setTitle:@"退出当前账号" forState:0];
        LognOut.titleLabel.font = [UIFont systemFontOfSize:20];
        //        LognOut.layer.cornerRadius = 5;
        //        LognOut.layer.borderWidth = 1.5;
        //        LognOut.layer.borderColor = [APP_COLOR CGColor];
        [LognOut setBackgroundColor:RGBCOLOR(246, 29, 74)];
        [LognOut setTitleColor:[UIColor whiteColor] forState:0];
        [LognOut addTarget:self action:@selector(lognOut) forControlEvents:UIControlEventTouchUpInside];
        
        [footerView addSubview:LognOut];
        return footerView;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self._tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    switch (section) {
        case 1:{
            LBAboutViewController *about = [[LBAboutViewController alloc] init]
            ;
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case 0:{
                [self loadVersionDatas];
        }
            break;
    }
}

//注销登录
#pragma mark  注销方法
- (void)lognOut
{
    NSString *username = [LBUserInfo sharedUserSingleton].userinfo_username;
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    if (username&&key) {
        [SVProgressHUD showWithStatus:@"正在注销" maskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"username":username,@"key":key,@"client":@"ios"};
        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_LOGOUT parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
            NSLog(@"responObject:%@",responObject);
            NSString *str1 = responObject[@"datas"];
            NSLog(@"%@",str1);
            
           
            [NOTIFICATION_CENTER postNotificationName:SUGE_NOT_LOGNOUT1 object:nil];

            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"注销成功" subtitle:@"谢谢您的使用~" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
            NSLog(@"注销失败:%@",error);
        }];
        
    }else{
        [TSMessage showNotificationWithTitle:@"您还没登陆呢" subtitle:@"请登陆后使用~" type:TSMessageNotificationTypeWarning];
    }
    
}


//检查更新版本
- (void)loadVersionDatas
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [manager GET:SUGE_VERSION parameters:nil success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"版本更新:%@",responObject);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *kVersion = responObject[@"datas"][@"version"];
        kUrl = responObject[@"datas"][@"url"];
        if ([kVersion isEqualToString:appVersion]) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最新版本!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
        }else{
            UIAlertView *alertView= [[UIAlertView alloc]initWithTitle:@"提示" message:@"有新的版本更新，是否前往更新?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10001;
            [alertView show];
            
        }
    }failure:^(AFHTTPRequestOperation *op,NSError *error){
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10001) {
        if (buttonIndex==1) {
            //            NSURL *url = [NSURL URLWithString:kUrl];
            NSString *kurl = @"http://sugemall.com/app/?package/sugemall.ipa";
            NSURL *url = [NSURL URLWithString:kurl];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

@end
