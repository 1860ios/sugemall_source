//
//  LBMyMessageViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMessageViewController.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import <AFNetworking.h>
#import <MobClick.h>
#import <MJRefresh.h>
#import "LBMyMessageCell.h"
#import "LBOrderMessageCell.h"
#import "LBAddressListViewController.h"
#import "LBOrderRefundViewController.h"
#import "LBOrderDetailViewController.h"
#import "LBMyPointViewController.h"
#import "LBMyBlotterViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";
static NSString * const CellIdentifier1 = @"CellIdentifier1";

@interface LBMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *curnum;
    int _curpage;
    NSMutableArray *messageDatasArray;
    NSMutableArray *newMessageDatasArray;
}
@property (nonatomic, strong) UITableView *_tableView;
@end

@implementation LBMessageViewController
@synthesize _tableView;
@synthesize _type;
@synthesize _title;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title;
    _curpage = 1;
    messageDatasArray = [NSMutableArray array];
    newMessageDatasArray = [NSMutableArray array];
    [self setUpTableView];
    [self setUpFooterRefresh];
    [self loadMessageDatas:@"1"];
    
}
- (void)setUpTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBCOLOR(246,246,246);
    _tableView.tableFooterView = [UIView new];
    if ([_type isEqualToString:@"order_msg"]) {

        [_tableView registerClass:[LBOrderMessageCell class] forCellReuseIdentifier:CellIdentifier1];
    }else{
        
        [_tableView registerClass:[LBMyMessageCell class] forCellReuseIdentifier:CellIdentifier];
    }

     [self.view addSubview:_tableView];
}

- (void)setUpFooterRefresh
{
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMessageNewData)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.footer setTitle:@"加载更多消息..." forState:MJRefreshFooterStateIdle];
    [self._tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self._tableView.footer setTitle:@"到头了~" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
}

- (void)loadMessageNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self loadMessageDatas:curnum];
}

- (void)loadMessageDatas:(NSString *)curpage
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key,@"type":_type,@"curpage":curpage};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_MSG parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"消息列表数据:responObject:%@",responObject);
        [_tableView.footer endRefreshing];
            newMessageDatasArray = responObject[@"datas"][@"msg_list"];
        if (newMessageDatasArray.count == 0) {
            [_tableView.footer noticeNoMoreData];
            _tableView.backgroundView = [[UIImageView alloc] initWithImage:IMAGE(@"no_point")];
        }else{
            [messageDatasArray addObjectsFromArray:newMessageDatasArray];
            _tableView.backgroundView = [UIView new];
        [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
    
    //dimiss HUD
    [SVProgressHUD dismiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return messageDatasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_type isEqualToString:@"order_msg"]) {
        return 400;
    }else{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section;
    if ([_type isEqualToString:@"order_msg"]) {
        
        LBOrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        cell.backgroundColor = RGBCOLOR(246,246,246);
        [cell addValueForOrderMessageCell:messageDatasArray[row]];
        return cell;
        
    }else{
    LBMyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = RGBCOLOR(246,246,246);
    [cell addValueForMessageCell:messageDatasArray[row]];
    return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if ([_type isEqualToString:@"order_msg"]) {
    NSArray *code1 = @[@"redund",@"order",@"points",@"predeposit",@"recharge",@"team"];
    NSString *section_code = messageDatasArray[section][@"action_code"];
    NSString *action_id = messageDatasArray[section][@"action_id"];
    
    for (int i = 0; i<code1.count; i++) {
        NSString *curCode1 = code1[i];
        if ([section_code rangeOfString:curCode1].location != NSNotFound) {
            if ([curCode1 isEqualToString:@"redund"]) {
                LBMyPointViewController *refund = [[LBMyPointViewController alloc] init];
                [self.navigationController pushViewController:refund animated:YES];
            } else if ([curCode1 isEqualToString:@"order"]) {
                
                LBOrderDetailViewController *orderdetail = [[LBOrderDetailViewController alloc] init];
                orderdetail.order_id = action_id;
                [self.navigationController pushViewController:orderdetail animated:YES];
            }else if ([curCode1 isEqualToString:@"points"]) {
                
                LBMyPointViewController *points = [[LBMyPointViewController alloc] init];
                [self.navigationController pushViewController:points animated:YES];
            }else if ([curCode1 isEqualToString:@"predeposit"]) {
                LBMyBlotterViewController *blotter=[[LBMyBlotterViewController alloc]init];
                blotter._title = @"佣金变动情况";
                blotter._type = @"recharge_commis";
                [self.navigationController pushViewController:blotter animated:YES];

            }else if ([curCode1 isEqualToString:@"recharge"]) {
                LBMyBlotterViewController *blotter=[[LBMyBlotterViewController alloc]init];
                blotter._title = @"储值金额";
                [self.navigationController pushViewController:blotter animated:YES];
            }else if ([curCode1 isEqualToString:@"team"]) {
            
                LBAddressListViewController *address = [[LBAddressListViewController alloc] init];
                [self.navigationController pushViewController:address animated:YES];
            }
        }
    }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"我的消息"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的消息"];
}
@end
