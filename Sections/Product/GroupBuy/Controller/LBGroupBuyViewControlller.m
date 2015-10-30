//
//  LBGroupBuyViewControlller.m
//  SuGeMarket
//
//  抢购详情
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBGroupBuyViewControlller.h"
#import <MJRefresh.h>
#import "LBBaseMethod.h"
#import <MWPhotoBrowser.h>
#import "LBGroupBuyStoreCell.h"
#import "LBGroupBuyGoodsCell.h"
#import "LBStoreDetailViewController.h"

static NSString *const GroupBuyStoreCellCid = @"GroupBuyStoreCellCid";
static NSString *const GroupBuyGoodsCellCid = @"GroupBuyGoodsCellCid";

@interface LBGroupBuyViewControlller ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    UIView *headerView;
    UIImageView *goods_imageview;
    //数据
    NSDictionary *store_info_dic;
    NSDictionary *groupbuy_info_dic;
    NSDictionary *goods_attribute_dic;
    //
    UIButton *group_buy_button;
}
@property(strong,nonatomic)UIScrollView *scrollV;
@property(strong,nonatomic)UITableView *tableV;
@property(strong,nonatomic)UIWebView *webV;
@end

@implementation LBGroupBuyViewControlller
@synthesize groupbuy_id;
@synthesize goods_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品详情";
    [self addNoti];
    [self requestGroupDetailDatas];
    [self addTableView];
}
- (void)addNoti{
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(releaseButton:) name:@"postNotReleaseButton" object:nil];
}

- (void)releaseButton:(NSNotification *)not
{
    [group_buy_button setTitle:@"立即抢购" forState:UIControlStateNormal];
    group_buy_button.enabled = YES;
    group_buy_button.backgroundColor = APP_COLOR;
}

#pragma mark 请求

- (void)requestGroupDetailDatas
{
    [self initDatas];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSDictionary *parms = @{@"groupbuy_id":groupbuy_id};
    [LBBaseMethod get:SUGE_GROUP_BUY_DETAIL parms:parms success:^(id json){
        NSLog(@"限时抢购详情数据:%@",json);
        [SVProgressHUD dismiss];
        goods_attribute_dic = json[@"datas"][@"goods_attribute"];
        groupbuy_info_dic = json[@"datas"][@"groupbuy_info"];
        store_info_dic = json[@"datas"][@"store_info"];
        NSString *image_url = groupbuy_info_dic[@"groupbuy_image"];
        [goods_imageview sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:IMAGE(SUGE_PIC)];
        NSString *button_text = groupbuy_info_dic[@"button_text"];
        if ([button_text isEqualToString:@"立即抢购"]) {
            group_buy_button.enabled = YES;
            group_buy_button.backgroundColor = APP_COLOR;
        }else{
            group_buy_button.enabled = NO;
            group_buy_button.backgroundColor = [UIColor lightGrayColor];
        }
        [group_buy_button setTitle:button_text forState:UIControlStateNormal];
        NSLog(@"商品属性:%@,商品详情:%@,店铺详情:%@",goods_attribute_dic,groupbuy_info_dic,store_info_dic);
        [self.tableV reloadData];
    }failture:^(id error){
        [SVProgressHUD dismiss];
    }];
}

- (void)initDatas
{
    groupbuy_info_dic = [NSDictionary dictionary];
    store_info_dic = [NSDictionary dictionary];
    goods_attribute_dic = [NSDictionary dictionary];
}

#pragma mark 加载视图

- (void)addTableView
{
    IOS_NAVBAR
    //控件添加到视图上
    [self.view addSubview:self.scrollV];
    [self.scrollV addSubview:self.tableV];
    [self.scrollV addSubview:self.webV];
    [self loadImageView];
    [self loadButton_top];
    //设置UITableView 上拉加载
    __weak typeof(self) weakSelf = self;
    [self.tableV addLegendFooterWithRefreshingBlock:^{
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.scrollV.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
        }completion:^(BOOL finished){
            [weakSelf.tableV.footer endRefreshing];
        }];
    }];
    // 隐藏时间
    self.tableV.header.updatedTimeHidden = YES;
    // 设置文字
    [self.tableV.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [self.tableV.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    //设置UIWebView 有下拉操作
    [weakSelf.webV.scrollView addLegendHeaderWithRefreshingBlock:^{
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.scrollV.contentOffset = CGPointMake(0, 0);
        }completion:^(BOOL finished){
            [weakSelf.webV.scrollView.header endRefreshing];
        }];
    }];
    self.webV.scrollView.header.updatedTimeHidden = YES;
    // 设置文字
    [self.webV.scrollView.header setTitle:@"下拉返回" forState:MJRefreshHeaderStateIdle];
    [self.webV.scrollView.header setTitle:@"" forState:MJRefreshHeaderStateRefreshing];
}

#pragma mark 抢购button  top button
- (void)loadButton_top
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-115, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    group_buy_button = [UIButton buttonWithType:UIButtonTypeCustom];
    group_buy_button.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 40);
    [group_buy_button setTitle:@"立即抢购" forState:UIControlStateNormal];
    [group_buy_button setBackgroundColor:APP_COLOR];
    [group_buy_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [group_buy_button addTarget:self action:@selector(pushQianggouView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:group_buy_button];
    
    UIButton *top_button = [UIButton buttonWithType:UIButtonTypeCustom];
    top_button.frame = CGRectMake(SCREEN_WIDTH-20-50, bottomView.frame.origin.y-60, 50, 50);
    [top_button setImage:IMAGE(@"shouye_top") forState:UIControlStateNormal];
    [top_button addTarget:self action:@selector(topTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:top_button];
}

- (void)pushQianggouView:(UIButton *)btn
{
    
}

- (void)topTableView:(UIButton *)btn
{
    [self.scrollV scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark viewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&goods_id=%@",SUGE_GOODS_BODY,goods_id]]]];
    
}
                                                     
#pragma mark -- UITableView DataSource && Delegate

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
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 160;
    }else{
        return 250;
    }
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        LBGroupBuyGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupBuyGoodsCellCid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addValueForGroupBuyGoodsCell:groupbuy_info_dic];
        return cell;
    }else{
        LBGroupBuyStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupBuyStoreCellCid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addValueForGroupBuyStoreCell:store_info_dic];
        [cell.all_goods_button addTarget:self action:@selector(go_store_method:) forControlEvents:UIControlEventTouchUpInside];
        [cell.go_store_button addTarget:self action:@selector(go_store_method:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)go_store_method:(UIButton *)btn
{
    NSString *storeid = store_info_dic[@"store_id"];
    LBStoreDetailViewController *store = [[LBStoreDetailViewController alloc] init];
    store.store_id = storeid;
    [self.navigationController pushViewController:store animated:YES];

}

                                                         
#pragma mark ---- get
                                                         
-(UIScrollView *)scrollV
{
    if (_scrollV == nil)
    {
        _scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollV.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
        //设置分页效果
        _scrollV.pagingEnabled = YES;
        //禁用滚动
        _scrollV.scrollEnabled = NO;
    }
    return _scrollV;
}
                                                         
-(UITableView *)tableV
{
    if (_tableV == nil)
    {
        _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = RGBCOLOR(246,246,246);
        [_tableV registerClass:[LBGroupBuyGoodsCell class] forCellReuseIdentifier:GroupBuyGoodsCellCid];
        [_tableV registerClass:[LBGroupBuyStoreCell class] forCellReuseIdentifier:GroupBuyStoreCellCid];
    }
    return _tableV;
}
                                                         
-(UIWebView *)webV
{
    if (_webV == nil)
    {
        _webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _webV;
}

#pragma mark -----------------***初始化滚动视图***---------------------

- (void)loadImageView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*3/5 )];
    goods_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    [headerView addSubview:goods_imageview];
    self.tableV.tableHeaderView = headerView;
    
}


@end
