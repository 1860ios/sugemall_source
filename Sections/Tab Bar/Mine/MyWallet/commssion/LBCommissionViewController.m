//
//  LBCommissionViewController.m
//  SuGeMarket
//  我的佣金
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBCommissionViewController.h"
#import "UtilsMacro.h"
#import "LBWithdrawalViewController.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import <UIImageView+WebCache.h>
#import "UILabel+FlickerNumber.h"

static NSString *celid=@"celid";
@interface LBCommissionViewController ()
{
    //成员变量(全局)
    UIView *comview1,*comview2,*comview3;
    UIButton *withdrawalButton;
    UIButton *recordButton;
    UIImageView *headpimageView,*pointimageView,*balanceimageView;
    UILabel *pointLabel,*balanceLabel;
    UITextField *pointField,*balanceField;
    NSString *pointString,*balanceString;
    NSString *yu_e;
    NSString *jifen;
    NSString *yongjin;
}
@end

@implementation LBCommissionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的佣金";
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
    
    [self initMyCommissionView];
    
}
- (void)requestMyComissionDatas
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key,@"client":@"ios"};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_MY_SUGE parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSString *iconUrl = responObject[@"datas"][@"member_info"][@"avator"];
        [headpimageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:IMAGE(@"user_no_image.png")];
        jifen = responObject[@"datas"][@"member_info"][@"point"];
//        pointLabel.text = [NSString stringWithFormat:@"积分:%0.2f",[po floatValue]];
        yongjin = responObject[@"datas"][@"member_info"][@"predepoit"];
        yu_e = yongjin;
//        balanceLabel.text = [NSString stringWithFormat:@"佣金:%@",yu_e];
        [pointLabel dd_setNumber:[NSNumber numberWithDouble:[jifen doubleValue]] duration:2];
        [balanceLabel dd_setNumber:[NSNumber numberWithDouble:[yongjin doubleValue]] duration:2];

    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];

}

-(void)initMyCommissionView
{
    comview1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 200)];
    comview2=[[UIView alloc]initWithFrame:CGRectMake(5, comview1.frame.size.height+5,(SCREEN_WIDTH-15)/2, 100)];
    comview3=[[UIView alloc]initWithFrame:CGRectMake(comview2.frame.origin.x+comview2.frame.size.width+5, comview2.frame.origin.y,comview2.frame.size.width, comview2.frame.size.height)];

    comview1.backgroundColor=[UIColor whiteColor];
    comview2.backgroundColor=[UIColor whiteColor];
    comview3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:comview1];
    [self.view addSubview:comview2];
    [self.view addSubview:comview3];
    
    withdrawalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawalButton.frame = CGRectMake(comview2.frame.origin.x, comview2.frame.origin.y+comview3.frame.size.height+10, SCREEN_WIDTH-10, 45);
    [withdrawalButton setImage:IMAGE(@"yue") forState:0];
    [withdrawalButton addTarget:self action:@selector(pushwithdrawalView:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawalButton];
    //头像
    headpimageView = [[UIImageView alloc] initWithFrame:CGRectMake(comview1.center.x-40,comview1.center.y-30,80,80)];
    headpimageView.image=[UIImage imageNamed:@"qianbao_2.png"];
    headpimageView.layer.masksToBounds = YES;
    headpimageView.layer.cornerRadius = 40;
    [comview1 addSubview:headpimageView];
    
    //
    pointimageView = [[UIImageView alloc] initWithFrame:CGRectMake(comview2.center.x-20,comview1.frame.origin.y+15,40,40)];
    pointimageView.image=[UIImage imageNamed:@"yongjin1"];
    [comview2 addSubview:pointimageView];
    
    pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(comview2.frame.origin.x, pointimageView.frame.origin.y+pointimageView.frame.size.height,comview2.frame.size.width, 40)];
//    pointLabel.text=@"积分:";
    pointLabel.textAlignment = NSTextAlignmentCenter;
    pointLabel.textColor=[UIColor blackColor];
    [comview2 addSubview:pointLabel];
    

    balanceimageView = [[UIImageView alloc] initWithFrame:CGRectMake(comview3.frame.size.width/2-20,comview1.frame.origin.y+15,40,40)];
    balanceimageView.image=[UIImage imageNamed:@"yongjin"];
    [comview3 addSubview:balanceimageView];
    
    balanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, balanceimageView.frame.origin.y+balanceimageView.frame.size.height,comview3.frame.size.width, 40)];
//    balanceLabel.text=@"佣金:";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor=[UIColor blackColor];
    [comview3 addSubview:balanceLabel];
    

}
-(void)pushwithdrawalView:(UIButton *)btn
{
    LBWithdrawalViewController *withdrawal=[[LBWithdrawalViewController alloc]init];
    withdrawal.moeny = yu_e;
    [self.navigationController pushViewController:withdrawal animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestMyComissionDatas];
    
}



@end

