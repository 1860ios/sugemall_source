//
//  LBOrderRefundViewController.m
//  SuGeMarket
//
//  订单退换货
//  Created by 1860 on 15/7/16.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderRefundViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import <TSMessage.h>
#import <MBProgressHUD.h>
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import "LBRefundCell.h"
#import <UIImageView+WebCache.h>

static NSString *cid=  @"cid";
@interface LBOrderRefundViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _curpage;
    NSString *curnum;
    NSString *_type;
    NSInteger row;
    NSArray *newRefundArray;
    NSMutableArray *RefundArray;
}

@property (nonatomic, strong)UITableView *_tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation LBOrderRefundViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款/售后";
    _curpage = 1;

    RefundArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadRefundSegmentedControll];
    [self initRefundView];
//    [self setRefundUpFooterRefresh];
    [self loadRefundDatas_curpage:@"1" type:@"1"];
}
#pragma mark-------------request datas---------------
- (void)loadRefundDatas_curpage:(NSString *)curpage type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameters = @{@"key":key,@"curpage":curpage,@"type":type};
    [maneger GET:SUGE_REFUND_INDEX parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"退换货:%@",responObject);
        [self._tableView.footer endRefreshing];
        newRefundArray = nil;
        newRefundArray = responObject[@"datas"];
        if (newRefundArray.count == 0) {
            [self._tableView.footer noticeNoMoreData];
        }else{
        [RefundArray addObjectsFromArray:newRefundArray];
        }
            [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络错误:%@",error);
    }];
    [SVProgressHUD dismiss];
}

#pragma mark-------------setRefundUpFooterRefresh---------------
- (void)setRefundUpFooterRefresh
{
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadRefundNewData)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.footer setTitle:@"加载更多商品..." forState:MJRefreshFooterStateIdle];
    [self._tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self._tableView.footer setTitle:@"到头了~" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
    
}

- (void)loadRefundNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self loadRefundDatas_curpage:curnum type:_type];
}

#pragma mark-------------loadRefundSegmentedControll---------------
- (void)loadRefundSegmentedControll
{
    NSString *installNUM = @"退款申请";
    NSString *lockNUM = @"退货申请";
    NSArray *segmentedArray = @[installNUM,lockNUM];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(10,65,SCREEN_WIDTH-20,35);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _type = @"1";
    _segmentedControl.tintColor = APP_COLOR;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentAction3:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self.view addSubview:_segmentedControl];

}

- (void)segmentAction3:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    
    RefundArray = [NSMutableArray array];
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:
            _type = @"1";
            break;
            
        case 1:
            _type = @"2";
            break;
    }
    [self loadRefundDatas_curpage:@"1" type:_type];
}


#pragma mark-------------tableView delegate/datasource---------------

- (void)initRefundView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,108,SCREEN_WIDTH, SCREEN_HEIGHT-108)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return RefundArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    row = indexPath.section;
    LBRefundCell *cell = nil;
    if (!cell) {
        cell = [[LBRefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.orderidLabel.text=[NSString stringWithFormat:@"订单编号 : %@",RefundArray[row][@"order_sn"]];
    NSString *type;
    if ([_type isEqualToString:@"1"]) {
        type = @"退款";
    }else{
        type = @"退货";
    }
    cell.refundLabel.text=[NSString stringWithFormat:@"%@编号 : %@",type,RefundArray[row][@"refund_sn"]];
    if ([RefundArray[row][@"seller_state"] isEqual:@"1"]) {
        cell.acceptLabel.text=@"待审核";
    }else if ([RefundArray[row][@"seller_state"] isEqual:@"2"]) {
        cell.acceptLabel.text=@"同意";
    }else{
        cell.acceptLabel.text=@"不同意";
    }
    cell.showLabel.text=RefundArray[row][@"goods_name"];
    cell.goodsnumLabel.text=[NSString stringWithFormat:@"x%@",RefundArray[row][@"goods_num"]];
    cell.tradeLabel.text=[NSString stringWithFormat:@"退款金额:¥%@",RefundArray[row][@"refund_amount"]];
    NSString *store_id= RefundArray[row][@"store_id"];
    NSString *goods_image= RefundArray[row][@"goods_image"];
    NSString *url=[NSString stringWithFormat:@"https://sugemall.com/data/upload/shop/store/goods/%@/%@",store_id,goods_image];
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGE(@"dd_03_@2x")];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark-------------viewWillAppear---------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"退换货"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [MobClick endLogPageView:@"退换货"];
}



@end
