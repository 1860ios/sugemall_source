//
//  LBMyRefereeViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/9.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyRefereeViewController.h"
#import "myRefereTableViewCell.h"
#import "UtilsMacro.h"
#import <MobClick.h>
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "SUGE_API.h"
#import <MJRefresh.h>

@interface LBMyRefereeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger num;
    NSMutableArray *offlineArray;
    NSArray *newOfflineArray;
    
    NSUInteger numPeople;
    int _curpage;
    NSString *curnum;
    NSString *type;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@implementation LBMyRefereeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的客户";
    _curpage = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    offlineArray = [NSMutableArray array];
    newOfflineArray = [NSArray array];

    [self loadSegmentedControll];
    [self loadGoodsListTableView];
     [self setUpFooterRefresh];
    [self loadRefereeDatas_type:@"0" curpage:@"1"];
    
}

- (void)setUpFooterRefresh
{
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyPointNewData)];
    // 隐藏时间
    _tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [_tableView.footer setTitle:@"加载更多..." forState:MJRefreshFooterStateIdle];
    [_tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [_tableView.footer setTitle:@"到头了~" forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    _tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    _tableView.header.textColor = APP_COLOR;
}

- (void)loadMyPointNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    if (type == nil) {
        type = @"1";
    }
    [self loadRefereeDatas_type:type curpage:curnum];
}


#pragma mark- tableview / seg

- (void)loadGoodsListTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                50, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[myRefereTableViewCell class] forCellReuseIdentifier:@"myRefereTableViewCell"];
    [self.view addSubview:_tableView];
}

- (void)loadSegmentedControll
{

    NSString *installNUM = [NSString stringWithFormat:@"已安装/关注(%d)人",0];
    NSString *lockNUM = [NSString stringWithFormat:@"已锁定(%d)人",0];
    NSArray *segmentedArray = @[installNUM,lockNUM];
    //初始化UISegmentedControl
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(10,5,SCREEN_WIDTH-20,35);
    _segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
    _segmentedControl.tintColor = APP_COLOR;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self.view addSubview:_segmentedControl];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;

    offlineArray = [[NSMutableArray alloc] init];
    switch (Index) {
        case 0:
            type = @"1";
            break;
            
        case 1:
            type = @"0";
            break;
    }
    [self loadRefereeDatas_type:type curpage:@"1"];

}

-(void)loadRefereeDatas_type:(NSString *)_type curpage:(NSString *)curpage
{
    [SVProgressHUD showWithStatus:@"正在加载数据..." maskType:SVProgressHUDMaskTypeBlack];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *dict = @{@"key":key,@"type":_type,@"curpage":curpage};
    
    [manager GET:SUGE_OFFLINE parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_tableView.footer endRefreshing];
        NSLog(@"我的下线:%@",responseObject
              );
        NSString *count_active =responseObject[@"datas"][@"count_active"];
        NSString *count_unactive =responseObject[@"datas"][@"count_unactive"];
        [_segmentedControl setTitle:[NSString stringWithFormat:@"已安装/关注(%@)人",count_active] forSegmentAtIndex:0];
        [_segmentedControl setTitle:[NSString stringWithFormat:@"已锁定(%@)人",count_unactive] forSegmentAtIndex:1];
        newOfflineArray = nil;

        newOfflineArray  =  responseObject[@"datas"][@"my_group"];
        

        if ([newOfflineArray isEqual:[NSNull null]]) {
            _tableView.backgroundView  = [[UIImageView alloc]initWithImage:IMAGE(@"no_firend")];
           
        }else{
            if (newOfflineArray.count == 0) {
                [_tableView.footer noticeNoMoreData];
            }else{
                [offlineArray addObjectsFromArray:newOfflineArray];
            }
            _tableView.backgroundView  = [UIView new];
        }
                        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"%@",error);
    }];
    [SVProgressHUD dismiss];
}

#pragma mark- tableview - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([offlineArray isEqual:[NSNull null]]) {
        return 0;
    }else{
        return offlineArray.count;
    }
    return 0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

#pragma mark  heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.section;
    myRefereTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myRefereTableViewCell"];
//    while ([cell.contentView.subviews lastObject]) {
//        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
    
    NSDictionary *offlineDict = offlineArray[row];
//    NSLog(@"%@",offlineDict);
    NSURL *refereeIconURL = [NSURL URLWithString:offlineDict[@"member_avatar"]];
    cell.refereeName.text = [NSString stringWithFormat:@"昵称:%@",offlineDict[@"member_name"]];
    [cell.refereeIcon sd_setImageWithURL:refereeIconURL placeholderImage:[UIImage imageNamed:@"user_no_image"]];
        
    cell.joinTime.text = [NSString stringWithFormat:@"%@",offlineDict[@"join_time"]];
    cell.refereePoints.text = [NSString stringWithFormat:@"%@",offlineDict[@"index"]];
    cell.refereePointsIcon.image = IMAGE(@"myrefrere_Icon");
    cell.luckNum.text = [NSString stringWithFormat:@"幸运号:%@",offlineDict[@"member_id"]];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [MobClick beginLogPageView:@"我的人气"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的人气"];
}



@end
