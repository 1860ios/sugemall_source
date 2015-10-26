//
//  LBMyPointViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/15.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyPointViewController.h"
#import "UtilsMacro.h"
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import <TSMessage.h>
#import "LBUserInfo.h"
#import <MobClick.h>

static NSString *cid = @"cid";

@interface LBMyPointViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *myPointLabel;
    NSString *myUid;
    NSMutableArray *pointDatas;
}
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation LBMyPointViewController
@synthesize _tableView;
@synthesize _point;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积分明细";
    self.view.backgroundColor  =[UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self loadPointSegmentedControll];
    [self initMyPointView];
    [self loadMyPointDatas:@"1"];
}

- (void)loadPointSegmentedControll
{
    NSString *installNUM = @"不可用";
    NSString *lockNUM = @"可用";
    NSArray *segmentedArray = @[installNUM,lockNUM];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(10,5,SCREEN_WIDTH-20,35);
    _segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segmentedControl.tintColor = APP_COLOR;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentAction1:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self.view addSubview:_segmentedControl];
}
- (void)segmentAction1:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSString *tmp;
    NSLog(@"Index %li", (long)Index);
    switch (Index) {
        case 0:
            tmp = @"1";
            break;
            
        case 1:
            tmp = @"0";
            break;
    }
    [self loadMyPointDatas:tmp];
}

- (void)initMyPointView
{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50,SCREEN_WIDTH, SCREEN_HEIGHT-50)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (void)loadMyPointDatas:(NSString *)tmp
{
    
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSString *_key = [LBUserInfo sharedUserSingleton].userinfo_key;
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameters = nil;
    parameters = @{@"tmp":tmp,@"key":_key};
    [maneger GET:SUGE_MYPOINT_2 parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"积分明细:%@",responObject);
        pointDatas = responObject[@"datas"];
        if (pointDatas.count == 0) {
            self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"no_point")];
        }else{
            self._tableView.backgroundView = [UIView new];
        }
        [self._tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"分类错误:%@",error);
    }];
        [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return pointDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        
    }
    NSInteger row = indexPath.section;
    //日期图标
    UIImageView *dateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    dateIcon.image = IMAGE(@"time_01");
    [cell.contentView addSubview:dateIcon];
    
    //时间
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateIcon.frame.size.width+dateIcon.frame.origin.x, dateIcon.frame.origin.y, 250, 30)];
    dateLabel.text = pointDatas[row][@"time"];
    dateLabel.font  =FONT(14);
//    dateLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:dateLabel];

    //我的积分图标
    UIImageView *pointIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, dateIcon.frame.origin.y, 30, 30)];
    pointIcon.image = IMAGE(@"point_02");
    [cell.contentView addSubview:pointIcon];
    
    //我的积分
    UILabel *desciption = [[UILabel alloc] initWithFrame:CGRectMake(pointIcon.frame.origin.x+pointIcon.frame.size.width, pointIcon.frame.origin.y, SCREEN_WIDTH-pointIcon.frame.size.width-pointIcon.frame.origin.x, 30)];
    desciption.text = pointDatas[row][@"points"];
    desciption.font =  FONT(15);
    [cell.contentView addSubview:desciption];
    
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(10, dateIcon.frame.origin.y+dateIcon.frame.size.height+5, SCREEN_WIDTH-20, 1)];
    lin1.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lin1];
    
    
    //订单号图标
    UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(dateIcon.frame.origin.x, lin1.frame.origin.y+lin1.frame.size.height+5, 30, 30)];
    orderIcon.image = IMAGE(@"point_03");
    [cell.contentView addSubview:orderIcon];
    
    //订单号
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderIcon.frame.origin.x+orderIcon.frame.size.width+5, orderIcon.frame.origin.y, 200, 30)];
    nameLabel.text = pointDatas[row][@"order_sn"];
    nameLabel.font  =FONT(14);
//    nameLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:nameLabel];

    //订单金额图标
    UIImageView *orderMenoyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(dateIcon.frame.origin.x, orderIcon.frame.origin.y+orderIcon.frame.size.height+5, 30, 30)];
    orderMenoyIcon.image = IMAGE(@"point_04");
    [cell.contentView addSubview:orderMenoyIcon];
    
    //订单金额
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderMenoyIcon.frame.origin.x+orderMenoyIcon.frame.size.width+5, orderMenoyIcon.frame.origin.y, 60, 30)];
    pointLabel.text = pointDatas[row][@"order_amount"];
    pointLabel.font  =FONT(14);
//    pointLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:pointLabel];
    
    //订单状态
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(pointLabel.frame.origin.x+pointLabel.frame.size.width, pointLabel.frame.origin.y, 90, 30)];
    NSString *stutes = pointDatas[row][@"order_state"];
    NSString *des;
    
    if ([stutes isEqualToString:@"10"]){
        des = @"(未付款...)";
    }else if ([stutes isEqualToString:@"20"]){
        des = @"(已支付...)";
//        time.textColor = [UIColor blueColor];
    }else if ([stutes isEqualToString:@"30"]){
        des = @"(已发货...)";
    }else if ([stutes isEqualToString:@"40"]){
        des = @"(已收货...)";
    }else if ([stutes isEqualToString:@"60"]){
        des = @"(交易成功...)";
//        cell.backgroundColor = [UIColor greenColor];
    }

    time.text =des;
    time.font =  FONT(15);
    [cell.contentView addSubview:time];
    
    return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.translucent = NO;
//    self.tabBarController.tabBar.translucent = NO;
    [MobClick beginLogPageView:@"我的积分"];
}

@end
