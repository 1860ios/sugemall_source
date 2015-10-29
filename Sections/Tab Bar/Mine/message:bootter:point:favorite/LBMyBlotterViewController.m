//
//  LBMyBlotterViewController.m
//  SuGeMarket
//
//  流水账
//  Created by 1860 on 15/7/10.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyBlotterViewController.h"
#import "UtilsMacro.h"
#import <MobClick.h>
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "SUGE_API.h"
#import "UILabel+FlickerNumber.h"
#import "LBMyBlotterCell.h"

static NSString *cid = @"cid";

@interface LBMyBlotterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *BlotterDatas;

    UILabel *yueLabel;
    double money1;
}
@property (nonatomic, strong) UITableView *_tableView;
@end

@implementation LBMyBlotterViewController
@synthesize _tableView;
@synthesize _type;
@synthesize _title;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title;
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self loadBlotterTableView];
    [self loadBlotterDatas];
    [self loadBlotterHeaderView];
}

- (void)loadBlotterHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *yueImage = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.center.x-40, headerView.center.y-100, 80, 80)];
    yueImage.image = IMAGE(@"liushui1");
    [headerView addSubview:yueImage];
    //佣金
    yueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, yueImage.frame.origin.y+yueImage.frame.size.height,SCREEN_WIDTH-80, 80)];
    yueLabel.textAlignment = NSTextAlignmentCenter;
//    yueLabel.adjustsFontSizeToFitWidth = YES;
    yueLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:35];
    yueLabel.text = @"00";
    [headerView addSubview:yueLabel];
    
    UIImageView *linView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-40, SCREEN_WIDTH, 25)];
    linView.image = IMAGE(@"yueview");
    [headerView addSubview:linView];
    
    
    _tableView.tableHeaderView = headerView;
}

- (void)loadBlotterTableView
{
    _tableView  = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tableView.delegate =self;
        tableView.dataSource =self;
        tableView;
    
    });
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[LBMyBlotterCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
    
}

- (void)loadBlotterDatas
{
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *dict;
    NSString *url = nil;
    if ([_title isEqualToString:@"账单"]) {
        dict = @{@"key":key};
        url= SUGE_PD_LOG_LSIT;
    }else if ([_title isEqualToString:@"储值金额"]){
        dict = @{@"key":key};
        url= SUGE_YUE_BINADONG;
    }else if ([_type isEqualToString:@"recharge_commis"]){
        dict = @{@"key":key,@"type":_type};
        url= SUGE_PD_LOG_LSIT;
    }else if ([_type isEqualToString:@"cash_pay"]){
        dict = @{@"key":key,@"type":_type};
        url= SUGE_PD_LOG_LSIT;
    }else if ([_type isEqualToString:@"cash_apply"]){
        dict = @{@"key":key,@"type":_type};
        url= SUGE_PD_LOG_LSIT;
    }
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"流水账:%@",responseObject);
        if ([_title isEqualToString:@"储值金额"]){
            BlotterDatas = responseObject[@"datas"][@"recharge_list"];
        }else{
            BlotterDatas = responseObject[@"datas"][@"list"];
            float sum = 0.0;
            for (int i = 0; i < BlotterDatas.count; i++) {
                float amount = [BlotterDatas[i][@"lg_av_amount"] floatValue];
                sum = sum + amount;
            }
            [yueLabel dd_setNumber:[NSNumber numberWithFloat:sum] duration:2];
            }
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"%@",error);
    }];
    [SVProgressHUD dismiss];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return BlotterDatas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    LBMyBlotterCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
   if ([_title isEqualToString:@"储值金额"]){
       [cell addValueForBlotterCell2:BlotterDatas[row]];
   }else{
       [cell addValueForBlotterCell1:BlotterDatas[row]];
   }
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"我的推荐"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    _title = nil;
}

@end
