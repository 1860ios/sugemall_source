//
//  LBMyMessageViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMyMessageViewController.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import <AFNetworking.h>
#import <MobClick.h>
#import <MJRefresh.h>
#import "LBMyMessageCell.h"
static NSString *cid = @"cid";

@interface LBMyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *curnum;
    int _curpage;
    NSMutableArray *messageDatasArray;
    NSMutableArray *newMessageDatasArray;
}
@property (nonatomic, strong) UITableView *_tableView;
@end

@implementation LBMyMessageViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    _curpage = 1;
    messageDatasArray = [NSMutableArray array];
    newMessageDatasArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
//    [_tableView registerClass:[LBMyMessageCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
    [self setUpFooterRefresh];
    [self loadMessageDatas:@"1"];
    
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
    NSDictionary *parameter = @{@"key":key,@"page":@"20",@"curpage":curpage};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_MSG parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"我的消息:responObject:%@",responObject);
        [_tableView.footer endRefreshing];
            newMessageDatasArray = responObject[@"datas"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageDatasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"Cell";
    //自定义cell类
    LBMyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LBMyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        cell.title.text = messageDatasArray[row][@"push_title"];
        cell.time.text = messageDatasArray[row][@"push_time"];
        [cell setIntroductionText:messageDatasArray[row][@"push_content"]];
    
    
    return cell;
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
