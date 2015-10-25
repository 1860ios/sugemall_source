//
//  LBGoodsListViewController.m
//  SuGeMarket
//
//  商品列表
//  Created by 1860 on 15/5/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsListViewController.h"
#import "UtilsMacro.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "UIView+Extension.h"
#import "LBGoodsDetailViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "LBGoodsListModel.h"
#import "LBGoodsListDatasModel.h"
#import "MJExtension.h"
#import "LBGoodsListCell.h"
#import "MJRefresh.h"
#import "MXPullDownMenu.h"
#import "LBSearchViewController.h"

static NSString *cid = @"cid";

@interface LBGoodsListViewController ()<MXPullDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
    LBGoodsListModel *modelList1;
    LBGoodsListDatasModel *model;
    NSString *curnum;
    MXPullDownMenu *menu;
    NSString *ii;

    UIView *navView;
    UITextField *searchText;
    UIButton *_back;
    
    int _curpage;
    
    NSMutableArray *goodsDatasArray;
    NSArray *newGoodsDatasArray;
}
@property (nonatomic, copy) NSArray *titles;


@end

@implementation LBGoodsListViewController
@synthesize _tableView;
@synthesize isSearch;
- (void)viewDidLoad {
    [super viewDidLoad];

    newGoodsDatasArray = [[NSArray alloc] init];
    goodsDatasArray = [[NSMutableArray alloc] init];
    self.title = @"商品列表";
    _curpage = 1;
    _titles = @[@[@"综合",@"浏览量"],@[@"销量"],@[@"价格升序",@"价格降序"]];
    
    
    [self loadNavView];
    [self loadGoodsListTableView];
    [self loadSegmentedControll];
    ii = __keyWord;
    NSLog(@"关键字:%@",ii);
    [self loadGoodsDatasKeyWord:ii orGC_ID:__goodsID key:@"" order:@"" curpage:@"1"];
    [self setUpFooterRefresh];
}

- (void)loadNavView
{
    self.view.backgroundColor = APP_Grey_COLOR;
    
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT+5)];
    navView.backgroundColor=[UIColor whiteColor];
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(60, navView.frame.origin.y+35, SCREEN_WIDTH-120, 35)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索商品关键字";
    searchText.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.97];
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.leftView = [[UIImageView alloc] initWithImage:IMAGE(@"suge_search_te")];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.layer.cornerRadius = 5;
    searchText.layer.masksToBounds = YES;
    searchText.userInteractionEnabled = YES;
    _back = [UIButton buttonWithType:UIButtonTypeCustom];
    _back.frame =CGRectMake(10,30,40,40);
    [_back setImage:IMAGE(@"back_list") forState:0];
    [_back addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchText];
    [navView addSubview:_back];
    [self.view addSubview:navView];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (isSearch) {
    [self.navigationController pushViewController:[LBSearchViewController new] animated:YES];
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self loadGoodsDatasKeyWord:ii orGC_ID:__goodsID key:@"1" order:@"1" curpage:curnum];
}

- (void)setUpFooterRefresh
{
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.footer setTitle:@"加载更多商品..." forState:MJRefreshFooterStateIdle];
    [self._tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self._tableView.footer setTitle:@"万件商品更新中,敬请期待..." forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
}

- (void)loadGoodsDatasKeyWord:(NSString *)keyword orGC_ID:(NSString *)gc_id  key:(NSString *)key order:(NSString *)order curpage:(NSString *)curpage
{
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *parameters = nil;
    if (keyword!=nil) {
        parameters = @{@"key":key,@"order":order,@"keyword":keyword,@"page":@"20",@"curpage":curpage};

    }else{

        parameters = @{@"key":key,@"order":order,@"gc_id":gc_id,@"page":@"20",@"curpage":curpage};
    }

    [maneger POST:SUGE_GOODS_LIST parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"reponObject:%@",responObject);
        [self._tableView.footer endRefreshing];
//        NSString *page_num = responObject[@"page_total"];
        NSArray *datas = responObject[@"datas"][@"goods_list"];
        if (datas.count == 0) {
            // 变为没有更多数据的状态
            [self._tableView.footer noticeNoMoreData];
        }else{

            newGoodsDatasArray = [LBGoodsListModel objectArrayWithKeyValuesArray:datas];
            [goodsDatasArray addObjectsFromArray:newGoodsDatasArray];
            
            [_tableView reloadData];
        }

    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络错误:%@",error);
    }];
    [SVProgressHUD dismiss];
}

#pragma mark- tableview / seg

- (void)loadGoodsListTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+35+5, SCREEN_WIDTH, SCREEN_HEIGHT-35-NavigationBar_HEIGHT-5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[LBGoodsListCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:_tableView];
}

- (void)loadSegmentedControll
{
    menu = [[MXPullDownMenu alloc] initWithArray:_titles selectedColor:APP_COLOR];
    menu.delegate = self;
    menu.frame = CGRectMake(0,NavigationBar_HEIGHT+5,SCREEN_WIDTH,35);
    [self.view addSubview:menu];
}
// 实现代理.
#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu
didSelectRowAtColumn:(NSInteger)column
                 row:(NSInteger)row{
    
     NSString *key = nil;
     NSString *order = nil;
    if (column == 0) {
        switch (row) {
            case 0:
                key = @"";
                order = @"";
                break;
                
            case 1:
                key = @"2";
                order = @"2";
                break;
        
        }
    }else if (column == 1){
        switch (row) {
            case 0:
                key = @"1";
                order = @"2";
                break;
                
        }
    }else if (column == 2){
        switch (row) {
            case 0:
                key = @"3";
                order = @"1";
                break;
                
            case 1:
                key = @"3";
                order = @"2";
                break;
        
        }
    }
    goodsDatasArray =  [NSMutableArray array];
    newGoodsDatasArray = [NSArray array];
    [self loadGoodsDatasKeyWord:ii orGC_ID:__goodsID key:key order:order curpage:@"1"];
//    [_tableView reloadData];
}
/*
-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li", (long)Index);
    NSString *key = nil;
    NSString *order = nil;
    switch (Index) {
        case 0:
            key = @"3";
            order = @"1";
            break;
        case 1:
            key = @"3";
            order = @"2";
            break;
        case 2:
            key = @"3";
            order = @"3";
            break;
    }
    [self loadGoodsDatasKeyWord:__keyWord orGC_ID:__goodsID key:key order:order curpage:@"1"];
    [_tableView reloadData];
}

 */
#pragma mark- tableview - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goodsDatasArray.count;
}

#pragma mark  heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
//    modelList = model.goods_list[row];
    modelList1 = goodsDatasArray[row];
    LBGoodsListCell *cell = nil;
    if (!cell) {
        cell = [[LBGoodsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    [cell addTheValue:modelList1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelList1 = goodsDatasArray[row];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBGoodsDetailViewController *detailVC = [[LBGoodsDetailViewController alloc] init];
    detailVC._goodsID = modelList1.goods_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark --页面统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    [MobClick beginLogPageView:@"商品列表"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"商品列表"];
    self.navigationController.navigationBar.hidden = NO;
}



@end
