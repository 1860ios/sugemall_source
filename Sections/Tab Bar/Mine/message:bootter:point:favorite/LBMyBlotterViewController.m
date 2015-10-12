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


static NSString *cid = @"cid";

@interface LBMyBlotterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *BlotterDatas;
    NSDictionary *typeDic;
    UILabel *yueLabel;
    double money1;
}
@property (nonatomic, strong) UITableView *_tableView;
@end

@implementation LBMyBlotterViewController
@synthesize _tableView;
@synthesize _yue;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流水账";
    money1 = [_yue doubleValue];
    self.view.backgroundColor = [UIColor whiteColor];
    typeDic = @{@"order_pay":@"下单支付预存款",@"order_freeze":@"下单冻结预存款",@"order_cancel":@"取消订单解冻预存款",@"order_comb_pay":@"下单支付被冻结的预存款",@"recharge":@"充值",@"cash_apply":@"申请提现冻结预存款",@"cash_pay":@"提现成功",@"cash_del":@"取消提现申请，解冻预存款",@"refund":@"退款"};
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
    yueLabel.text = @"0000";
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
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
    
}

- (void)loadBlotterDatas
{
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *dict = @{@"key":key};
    
    [manager POST:SUGE_PD_LOG_LSIT parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"流水账:%@",responseObject);
        BlotterDatas = responseObject[@"datas"][@"list"];
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
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //
    UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    v1.image = IMAGE(@"liushui3");//绿色liushui2
    [cell addSubview:v1];
//订单号
    UILabel *snLabel = [[UILabel alloc] initWithFrame:CGRectMake(v1.frame.origin.x+v1.frame.size.width, 0, SCREEN_WIDTH/2, 40)];
    snLabel.numberOfLines = 2;
    snLabel.adjustsFontSizeToFitWidth = YES;
    snLabel.text = BlotterDatas[row][@"lg_desc"];

    [cell addSubview:snLabel];
//时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(snLabel.frame.origin.x+snLabel.frame.size.width, 0, SCREEN_WIDTH-snLabel.frame.origin.x-snLabel.frame.size.width-10,20)];
    timeLabel.textAlignment = NSTextAlignmentRight;

    timeLabel.text = BlotterDatas[row][@"lg_add_time"];
    [cell addSubview:timeLabel];
//type

    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(snLabel.frame.origin.x, snLabel.frame.origin.y+snLabel.frame.size.height, snLabel.frame.size.width, 25)];
    typeLabel.numberOfLines = 2;
    NSString *type1 =BlotterDatas[row][@"lg_type"];
    typeLabel.text = [typeDic valueForKey:type1];
    [cell addSubview:typeLabel];
//消费
    UILabel *wasteLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x,typeLabel.frame.origin.y , timeLabel.frame.size.width, 25)];
    wasteLabel.textAlignment = NSTextAlignmentRight;
    wasteLabel.text = BlotterDatas[row][@"lg_av_amount"];
    [cell addSubview:wasteLabel];
    
    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (![_yue isEqual:[NSNull null]]) {
        [yueLabel dd_setNumber:[NSNumber numberWithFloat:money1] duration:2];
//    }

    [MobClick beginLogPageView:@"我的推荐"];
}

@end
