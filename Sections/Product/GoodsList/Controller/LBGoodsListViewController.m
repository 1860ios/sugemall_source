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
#import "LBShoppingCarViewController.h"

static NSString *collectionView_cid = @"collectionView_cid";

@interface LBGoodsListViewController ()<MXPullDownMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
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
@property (nonatomic,strong) UICollectionView *goodsCollectionView;

@end

@implementation LBGoodsListViewController
@synthesize goodsCollectionView;
@synthesize isSearch;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initDatas];
    [self loadNavView];
    [self loadGoodsListTableView];
    [self loadSegmentedControll];
    ii = __keyWord;
    [self loadGoodsDatasKeyWord:ii orGC_ID:__goodsID key:@"" order:@"" curpage:@"1"];
    [self setUpFooterRefresh];
    [self addOtherBuuton];
}
- (void)addOtherBuuton
{
    NSArray *bottonImage = @[@"shouye_car",@"shouye_top"];
    for (int i = 0; i < 2; i++) {
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 1) {
            otherButton.frame = CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-120, 50, 50);
        }else{
            otherButton.frame = CGRectMake(15, SCREEN_HEIGHT-120, 50, 50);
        }
        [otherButton setImage:IMAGE(bottonImage[i]) forState:UIControlStateNormal];
        otherButton.tag = 716+i;
        [otherButton addTarget:self action:@selector(otherBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherButton];
    }

}
- (void)otherBtnMethod:(UIButton *)btn
{
    long btn_tag = btn.tag-716;
    switch (btn_tag) {
        case 0:{
            LBShoppingCarViewController *car = [LBShoppingCarViewController new];
            car.isPushIn = YES;
            [self.navigationController pushViewController:car animated:YES];
        }
            break;
            
        case 1:{
            [goodsCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
            break;
            
    }

}

- (void)initDatas
{
    newGoodsDatasArray = [[NSArray alloc] init];
    goodsDatasArray = [[NSMutableArray alloc] init];
    self.title = @"商品列表";
    _curpage = 1;
    _titles = @[@[@"综合",@"浏览量"],@[@"销量"],@[@"价格升序",@"价格降序"]];
    
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
    [goodsCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    goodsCollectionView.header.updatedTimeHidden = YES;
    // 设置文字
    [goodsCollectionView.footer setTitle:@"加载更多商品..." forState:MJRefreshFooterStateIdle];
    [goodsCollectionView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [goodsCollectionView.footer setTitle:@"万件商品更新中,敬请期待..." forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    goodsCollectionView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    goodsCollectionView.header.textColor = APP_COLOR;
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
        [goodsCollectionView.footer endRefreshing];
//        NSString *page_num = responObject[@"page_total"];
        NSArray *datas = responObject[@"datas"][@"goods_list"];
        if (datas.count == 0) {
            // 变为没有更多数据的状态
            [goodsCollectionView.footer noticeNoMoreData];
        }else{

            newGoodsDatasArray = [LBGoodsListModel objectArrayWithKeyValuesArray:datas];
            [goodsDatasArray addObjectsFromArray:newGoodsDatasArray];
            
            [goodsCollectionView reloadData];
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
  
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    goodsCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+35+5, SCREEN_WIDTH, SCREEN_HEIGHT-35-NavigationBar_HEIGHT-5)collectionViewLayout:layout];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    goodsCollectionView.backgroundColor = [UIColor whiteColor];
    goodsCollectionView.delegate = self;
    goodsCollectionView.dataSource = self;
    goodsCollectionView.scrollEnabled  = YES;
    [goodsCollectionView registerClass:[LBGoodsListCell class]forCellWithReuseIdentifier:collectionView_cid];
    [self.view addSubview:goodsCollectionView];
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
#pragma mark CollectionView delegate
#pragma mark  --------collectionView  代理方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return goodsDatasArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    LBGoodsListCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
    cell.layer.borderColor = [UIColor colorWithWhite:0.90 alpha:0.93].CGColor;
    cell.layer.borderWidth = 1.0f;
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    modelList1 = goodsDatasArray[row];
    [cell addTheValue:modelList1];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-10,SCREEN_WIDTH/2+40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 0, 2 );
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelList1 = goodsDatasArray[row];
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
