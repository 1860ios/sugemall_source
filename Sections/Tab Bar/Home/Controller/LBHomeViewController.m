//
//  LBHomeViewController.m
//  SuGeMarket
//
//  首页
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <AFNetworking.h>
#import "UtilsMacro.h"
#import "AppMacro.h"
#import "LBHomeViewController.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <TSMessage.h>
#import "MobClick.h"
#import "LBSearchViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SUGE_API.h"
#import "LBHomeViewCell.h"
#import "LBGoodsDetailViewController.h"
#import "SVProgressHUD.h"
#import "LBUserInfo.h"
#import "LBLognInViewController.h"
#import "LBAdvListModel.h"
#import "LBAdvItemModel.h"
#import <MJExtension.h>
#import "LBAdvViewController.h"
#import "LBGoodsListViewController.h"
#import "LBMyPointViewController.h"
#import "LBCommissionViewController.h"
#import "LBMyRefereeViewController.h"
#import "LBVoucherHostViewController.h"
#import "MJRefresh.h"
#import "LBMyMessageViewController.h"
#import "LBBaseMethod.h"
#import "RecipeCollectionReusableView.h"
#import "MZTimerLabel.h"
#import "NotificationMacro.h"

@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
static NSString *collectionView_cid = @"collectionViewcid";
static NSString *collectionView_header_cid = @"HeaderView";

@interface LBHomeViewController ()<
                                UIScrollViewDelegate,
                                UITextFieldDelegate,
                                UICollectionViewDelegateFlowLayout,
                                UICollectionViewDataSource,
                                UICollectionViewDelegate>
{

    int timeCount;
    UIView *headerView;
    UIView *qianggouView;
    UIView *zhuantiView;
    MZTimerLabel *qianggou_timer;
    UILabel *qianggou_timer_label;
    UIScrollView *_scrollView;
    UIScrollView *qianggouScrollView;
    UIPageControl *_pageControl;
    UIPageControl *_pageControl_qianggou;
    
    UIImageView *qianggou_imageview;
    UILabel *qianggou_name;
    UILabel *qianggou_price;
    UILabel *qianggou_group_price;
    UILabel *qianggou_time;
    
//    NSDictionary *groupDic;
    NSMutableArray *groupArray;
    NSMutableArray *tagArray;
    
    NSArray *arrayData;
    NSDictionary *dataDict;
    NSDictionary *goodsDict;
    NSArray *goodsArray;
    NSDictionary *singleGood;

    NSDictionary *advListDic;
    NSMutableArray *itemArray;
    NSMutableArray *images;
    
    LBAdvListModel *model;
    LBAdvItemModel *modelItem;
    NSMutableArray *advArray;
    NSMutableArray *advTypeArray;
    
    UIView *homeLine1;
    NSString *home1Datas;
    NSString *home1Type;
    NSString *home1ImageUrl;
    //
    NSMutableArray *ArrayHome1Datas;
    NSMutableArray *ArrayHome1Type;
    NSMutableArray *ArrayHome1ImageUrl;
    
    NSMutableArray *home2Array;
    NSMutableArray *home2TypeArray;
    NSMutableArray *home2DataArray;
    //抢购
    
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArrayDatas];
    [self addNotObserver];

    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    [self requestHomeDatas];
    });
    dispatch_async(queue, ^{
        [self requestQianggouDatas:@"16,18,20"];
    });
    [self loadCollectionView];
     /*
    //初始化tableView
    [self loadNavBar];
    [self initTableView];
    [self setUpTableViewRefresh];
    [self initCollectionView];
    [self setUpCollectionViewRefresh];
    [self loadHomeData];
    */
}
- (void)initArrayDatas
{
//    groupDic= [NSDictionary dictionary];
    tagArray = [NSMutableArray array];
    groupArray = [NSMutableArray array];
    images = [NSMutableArray array];
    ArrayHome1Datas = [NSMutableArray array];
    ArrayHome1Type = [NSMutableArray array];
    ArrayHome1ImageUrl = [NSMutableArray array];
}
- (void)addNotObserver
{
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pushView:) name:@"tuisongxiaoxi" object:nil];
    //广告
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pushImageView:) name:SUGE_GUANGGAO object:nil];
    //专题
    [NOTIFICATION_CENTER addObserver:self selector:@selector(psuhZhuanti:) name:SUGE_ZHUANTI object:nil];
    
}
//imageButton事件
- (void)pushImageView:(NSNotification *)not
{
    NSInteger index = [[[not userInfo] valueForKey:@"index"] integerValue];
    modelItem = model.item[index];
    
    NSString *adv_data = modelItem.data;
    NSString *adv_type = modelItem.type;
    if ([adv_type isEqualToString:@"url"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [adv_data stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];
        
    }else if ([adv_type isEqualToString:@"keyword"]) {
        LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
        goodsList._keyWord = adv_data;
        goodsList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsList animated:YES];
        
    }else if ([adv_type isEqualToString:@"goods"]) {
        LBGoodsDetailViewController *goodsDetail = [[LBGoodsDetailViewController alloc]init];
        goodsDetail._goodsID =adv_data;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}
//专题
- (void)psuhZhuanti:(NSNotification *)not
{
    NSInteger index = [[[not userInfo] valueForKey:@"index"] integerValue];
    NSString *type1 = ArrayHome1Type[index];
    if ([type1 isEqualToString:@"url"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [home1Datas stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];
        
    }else if ([type1 isEqualToString:@"keyword"]) {
        LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
        goodsList._keyWord = home1Datas;
        goodsList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsList animated:YES];
        
        
    }else if ([type1 isEqualToString:@"goods"]) {
        LBGoodsDetailViewController *goodsDetail = [[LBGoodsDetailViewController alloc]init];
        
        goodsDetail._goodsID =home1Datas;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }else if ([type1 isEqualToString:@"special"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *str1 = ArrayHome1Datas[index];
        NSString *str2 = [NSString stringWithFormat:@"http://sugemall.com/wap/special.html?special_id=%@",str1];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [str2 stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        adv.tabBarController.tabBar.hidden=YES;
        
        [self.navigationController pushViewController:adv animated:YES];
        
        
    }
    
}


#pragma mark HTTP request
- (void)requestHomeDatas
{
    NSDictionary *para = @{@"type":@"json"};
//    [LBHttpTool getWirhUrl:SUGE_HOME parms:para success:^(id json){
    [LBBaseMethod get:SUGE_HOME parms:para success:^(id json){
        NSLog(@"homedatas:%@",json);
        NSMutableArray *datas = json[@"datas"];
        for (NSDictionary *dic in datas) {
            NSArray *keysArray = [dic allKeys];
            NSString *keysString = keysArray[0];
            if ([keysString isEqualToString:@"adv_list"]) {
                model = [LBAdvListModel objectWithKeyValues:dic[@"adv_list"]];
                for (int i = 0; i < model.item.count; i++) {
                    modelItem = model.item[i];
                    [images addObject:modelItem.image];
                }
            }else if([keysString isEqualToString:@"home1"]){
                home1ImageUrl = dic[@"home1"][@"image"];
                home1Datas = dic[@"home1"][@"data"];
                home1Type = dic[@"home1"][@"type"];
                [ArrayHome1ImageUrl addObject:home1ImageUrl];
                [ArrayHome1Type addObject:home1Type];
                [ArrayHome1Datas addObject:home1Datas];
                //                NSLog(@"home1ImageUrl:%@ \n home1Datas:%@ \n, home1Type:%@ \n",home1ImageUrl,home1Datas,home1Type);
            }else if([keysString isEqualToString:@"home2"]){
                home2Array = dic[@"home2"];
            }else if([keysString isEqualToString:@"goods"]){
                goodsArray = dic[@"goods"][@"item"];
            }
            NSLog(@"keysArray:%@",keysArray[0]);
        }
        [self.collectionView reloadData];

    }failture:^(id error){
        
    }];
    
}

- (void)requestQianggouDatas:(NSString *)time
{
    NSDictionary *parms = @{@"time":time};
    [LBBaseMethod get:SUGE_GROUP_BUY parms:parms success:^(id json){
        NSLog(@"抢购商品:%@",json);
        NSDictionary *groupListDic = json[@"datas"][@"groupbuy_group_list"];
//        if (!groupListDic) {
        NSDictionary *hoursDic  = json[@"datas"][@"groupbuy_group_list"][@"hours"];
        NSArray *hoursArr = [hoursDic allKeys];
        NSMutableArray *hoursMuArray = [NSMutableArray arrayWithArray:hoursArr];
        [hoursMuArray sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
            return [obj1 intValue] > [obj2 intValue];
        }];
        for (int i = 0; i < hoursMuArray.count; i++) {
            NSDictionary *groupDic = [hoursDic valueForKey: hoursMuArray[i]];
            NSMutableArray *groupArr = [groupDic valueForKey:@"groupbuy_list"];
            
            [groupArray addObjectsFromArray:groupArr];
//            [groupArray insertObject:groupArr atIndex:i];
            NSInteger count = groupArr.count;
            NSNumber *count1=  [NSNumber numberWithInteger:count];
            [tagArray addObject:count1];
        }
        NSLog(@"groupArray:%@,hoursArr:%@",groupArray,hoursArr);
        
//        }
        [self.collectionView reloadData];
    }failture:^(id  error){
        
    }];
    
}

#pragma mark not
- (void)pushView:(NSNotification *)not
{
    NSString *type =  [[not userInfo] valueForKey:@"type"];
    if ([type isEqualToString:@"1"] ) {
        LBMyMessageViewController *mess = [[LBMyMessageViewController alloc] init];
        mess.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mess animated:YES];
    }
    
}
#pragma mark collectionview
- (void)loadCollectionView
{
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)collectionViewLayout:flowLayout];
//    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    //header  height
//    collectionViewLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 164+230+(ArrayHome1ImageUrl.count*(SCREEN_WIDTH*280/540)));
    //注册
    [self.collectionView registerClass:[LBHomeViewCell class]forCellWithReuseIdentifier:collectionView_cid];
    [self.collectionView registerClass:[RecipeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionView_header_cid];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={SCREEN_WIDTH, 50+164+230+(ArrayHome1ImageUrl.count*(SCREEN_WIDTH*280/540))};
    return size;
}

#pragma mark collection headerview
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        //广告图
     RecipeCollectionReusableView *R_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionView_header_cid forIndexPath:indexPath ];
        
        [R_headView addValueForReusableView:images];
        [R_headView addValueForZhuantiView:ArrayHome1ImageUrl];
        [R_headView addValueForQianggouView:groupArray];
        [R_headView addTagArray:tagArray];
        reusableview = R_headView;
    }
    return reusableview;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return goodsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LBHomeViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
    
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    
    //    while ([cell.contentView.subviews lastObject]) {
    //        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    //    }
    NSInteger  row = indexPath.row;
    singleGood = goodsArray[row];
    [cell addValueForCell:singleGood];
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
    LBGoodsDetailViewController *detailVC = [[LBGoodsDetailViewController alloc] init];
    singleGood = goodsArray[row];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC._goodsID = singleGood[@"goods_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}





/*
- (void)initArrayDatas
{
    ArrayHome1Datas = [NSMutableArray array];
    ArrayHome1Type = [NSMutableArray array];
    ArrayHome1ImageUrl = [NSMutableArray array];
}



- (void)setUpCollectionViewRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf._tableView setContentOffset:CGPointMake(0,0) animated:YES];
        [weakSelf.collectionView.header endRefreshing];
    }];
    // 隐藏时间
    self.collectionView.header.updatedTimeHidden = YES;
    self.collectionView.header.stateHidden = YES;


}


- (void)initCollectionView
{
 
}

- (void)loadNavBar
{
//    self.navigationController.navigationBar.hidden = YES;
    UIBarButtonItem *liftNavBarItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:IMAGE(@"zhuye_suge")]];
    self.navigationItem.leftBarButtonItem = liftNavBarItem;
    
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 35)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索商品关键字";
    searchText.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.99];
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.leftView = [[UIImageView alloc] initWithImage:IMAGE(@"suge_search_te")];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.layer.cornerRadius = 5;
    searchText.layer.masksToBounds = YES;
    searchText.userInteractionEnabled = YES;
//    UIBarButtonItem *rightNavBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchText];
    self.navigationItem.titleView = searchText;
    //    self.navigationItem.titleView = searchText;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    LBSearchViewController *search = [[LBSearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
    return YES;
}

-(void)loadHomeData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *para = @{@"type":@"json"};
    [manager GET:SUGE_HOME parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"首页接口:%@",responseObject);
        [self._tableView.header endRefreshing];
        NSMutableArray *datas = responseObject[@"datas"];
        for (NSDictionary *dic in datas) {
            NSArray *keysArray = [dic allKeys];
            NSString *keysString = keysArray[0];
            if ([keysString isEqualToString:@"adv_list"]) {
                model = [LBAdvListModel objectWithKeyValues:dic[@"adv_list"]];
            }else if([keysString isEqualToString:@"home1"]){
                home1ImageUrl = dic[@"home1"][@"image"];
                home1Datas = dic[@"home1"][@"data"];
                home1Type = dic[@"home1"][@"type"];
                [ArrayHome1ImageUrl addObject:home1ImageUrl];
                [ArrayHome1Type addObject:home1Type];
                [ArrayHome1Datas addObject:home1Datas];
//                NSLog(@"home1ImageUrl:%@ \n home1Datas:%@ \n, home1Type:%@ \n",home1ImageUrl,home1Datas,home1Type);
            }else if([keysString isEqualToString:@"home2"]){
                home2Array = dic[@"home2"];
            }else if([keysString isEqualToString:@"goods"]){
                goodsArray = dic[@"goods"][@"item"];
            }
            NSLog(@"keysArray:%@",keysArray[0]);
        }
        //初始化滚动视图
        [self initScrollView];
        [self._tableView reloadData];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"homeError:%@",error);
    }];
}

//
- (void)setUpTableViewRefresh
{
    __weak typeof(self) weakSelf = self;
    [self._tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadHomeData];
    }];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    self._tableView.header.stateHidden = YES;
}

-(void)refrshUI
{
    [self._tableView setContentOffset:CGPointMake(0, -64-64) animated:YES];
    [self._tableView.header beginRefreshing];
    [self loadHomeData];
}
//---------------------------------Table view-------------------------------------------
#pragma mark - 初始化tableView
- (void)initTableView
{
    self._tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+35) style:UITableViewStyleGrouped];
    self._tableView.delegate = self;
    self._tableView.dataSource = self;
    self._tableView.pagingEnabled = NO;
    self._tableView.showsHorizontalScrollIndicator = YES;
    self._tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;

    [self.view addSubview:self._tableView];
    
}

#pragma mark - Table view delegate / data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-49-63-65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"新品推荐";
}

//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//分区下多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_collectionView];
    return cell;

}





//---------------------------------滚动视图-------------------------------------------
#pragma mark - 初始化滚动视图

- (void)initScrollView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80+(ArrayHome1ImageUrl.count*(SCREEN_WIDTH*280/540))+(SCREEN_WIDTH/2-0.5)*(600/500))];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 164)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * model.item.count, 164);
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;     
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [headerView addSubview:_scrollView];
    //广告图
    [self advListView];
    //初始化page
    [self initPageControl];
    //
    [self home1];
    [self home_one];
    __tableView.tableHeaderView = headerView;
    
}
//积分_佣金_会员_代金券
- (void)home1
{

    NSArray *home1Button = @[@"icon_index_commison",@"icon_index_member",@"icon_index_points",@"icon_index_voucher"];
    NSArray *home1Title = @[@"佣金",@"会员",@"积分",@"代金券"];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(EACH_W(4 * i)+20, _scrollView.frame.origin.y+_scrollView.frame.size.height+10, 45, 45);
        [btn setImage:[UIImage imageNamed:home1Button[i]] forState:UIControlStateNormal];
        [btn setTag:212+i];
        [btn addTarget:self action:@selector(pushMine:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height, btn.frame.size.width, 20)];
        homeLabel.text = home1Title[i];
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.textColor = [UIColor lightGrayColor];
//        homeLabel.adjustsFontSizeToFitWidth  = YES;
        homeLabel.font = FONT(13);
        [headerView addSubview:homeLabel];
    }
    
    homeLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.origin.y+_scrollView.frame.size.height+70+10-0.5, SCREEN_WIDTH, 0.5)];
    homeLine1.backgroundColor = [UIColor lightGrayColor];
    homeLine1.alpha = 0.5;
    [headerView addSubview:homeLine1];
}

///积分_佣金_会员_代金券/
- (void)pushMine:(UIButton *)btn
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    if (key==nil) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        LBLognInViewController *logn=[[LBLognInViewController alloc]init];
        [self.navigationController pushViewController:logn animated:YES];
    }else{
    NSInteger index = btn.tag -212;
    LBMyPointViewController *point = [[LBMyPointViewController alloc] init];
    LBCommissionViewController *commission = [[LBCommissionViewController alloc] init];
    LBMyRefereeViewController *refree = [[LBMyRefereeViewController alloc] init];
    LBVoucherHostViewController *voucher = [[LBVoucherHostViewController alloc] init];
    NSArray *mine = @[commission,refree,point,voucher];
    point.hidesBottomBarWhenPushed = YES;
    commission.hidesBottomBarWhenPushed = YES;
    refree.hidesBottomBarWhenPushed = YES;
    voucher.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mine[index] animated:YES];
    }
}


//板块1
- (void)home_one
{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushHome2:)];
    /*
    //左
    UIImageView *model1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, homeLine1.frame.origin.y, SCREEN_WIDTH/2-0.5, (SCREEN_WIDTH/2-0.5)*(600/500))];
        [model1 addGestureRecognizer:tap1];
//    model1.backgroundColor = [UIColor blueColor];
    model1.userInteractionEnabled = YES;
    model1.tag = 1111;
    [model1 sd_setImageWithURL:[NSURL URLWithString:[home2Array valueForKey:@"square_image"]] placeholderImage:IMAGE(@"")];
    [headerView addSubview:model1];
    
    UIView *modelLine1 = [[UIView alloc] initWithFrame:CGRectMake(model1.frame.size.width, model1.frame.origin.y, 0.5, model1.frame.size.height)];
    modelLine1.backgroundColor = [UIColor lightGrayColor];
    modelLine1.alpha  =0.5;
    [headerView addSubview:modelLine1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushHome2:)];
    //右上
    UIImageView *model2 = [[UIImageView alloc] initWithFrame:CGRectMake(modelLine1.frame.origin.x+modelLine1.frame.size.width, modelLine1.frame.origin.y, SCREEN_WIDTH-model1.frame.size.width, modelLine1.frame.size.height/2-0.5)];
    [model2 addGestureRecognizer:tap2];
    model2.userInteractionEnabled = YES;
    model2.tag = 1112;
    [model2 sd_setImageWithURL:[NSURL URLWithString:[home2Array valueForKey:@"rectangle1_image"]] placeholderImage:IMAGE(@"")];
    //    model2.backgroundColor = [UIColor yellowColor];
    [headerView addSubview:model2];
    
    UIView *modelLine2 = [[UIView alloc] initWithFrame:CGRectMake(model2.frame.origin.x, model2.frame.origin.y+model2.frame.size.height, model2.frame.size.width,0.5)];
    modelLine2.backgroundColor = [UIColor lightGrayColor];
    modelLine2.alpha  =0.5;
    [headerView addSubview:modelLine2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushHome2:)];
    //右下
    UIImageView *model3 = [[UIImageView alloc] initWithFrame:CGRectMake(modelLine2.frame.origin.x, modelLine2.frame.origin.y+modelLine2.frame.size.height, modelLine2.frame.size.width , model2.frame.size.height)];
    [model3 addGestureRecognizer:tap3];
    model3.tag = 1113;
    model3.userInteractionEnabled = YES;
    [model3 sd_setImageWithURL:[NSURL URLWithString:[home2Array valueForKey:@"rectangle2_image"]] placeholderImage:IMAGE(@"")];
    [headerView addSubview:model3];
    
    UIView *modelLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, model1.frame.origin.y+model1.frame.size.height, SCREEN_WIDTH,0.5)];
    modelLine3.backgroundColor = [UIColor lightGrayColor];
    modelLine3.alpha  =0.5;
    [headerView addSubview:modelLine3];
     
    //
    home2DataArray = [[NSMutableArray alloc] initWithObjects:[home2Array valueForKey:@"square_data"],[home2Array valueForKey:@"rectangle1_data"],[home2Array valueForKey:@"rectangle2_data"], nil];
    home2TypeArray = [[NSMutableArray alloc] initWithObjects:[home2Array valueForKey:@"square_type"],[home2Array valueForKey:@"rectangle1_type"],[home2Array valueForKey:@"rectangle2_type"], nil];
    for (int i = 0; i<ArrayHome1ImageUrl.count; i++) {
        UIImageView *model4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, homeLine1.frame.origin.y+homeLine1.frame.size.height+i*(SCREEN_WIDTH*280/540), SCREEN_WIDTH, SCREEN_WIDTH*280/540)];
        model4.userInteractionEnabled = YES;
        model4.tag = 2323+i;
        [model4 sd_setImageWithURL:[NSURL URLWithString:ArrayHome1ImageUrl[i]] placeholderImage:IMAGE(@"")];
        UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PsuhHome1:)];
        [model4 addGestureRecognizer:tap];
        //    model4.backgroundColor = [UIColor cyanColor];
        [headerView addSubview:model4];
    }
   
}
//最下图
- (void)PsuhHome1:(UIGestureRecognizer*)sender
{
    NSInteger index = sender.view.tag-2323;
    NSString *type1 = ArrayHome1Type[index];
    if ([type1 isEqualToString:@"url"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [home1Datas stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];

    }else if ([type1 isEqualToString:@"keyword"]) {
        LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
        goodsList._keyWord = home1Datas;
        goodsList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsList animated:YES];
        

    }else if ([type1 isEqualToString:@"goods"]) {
        LBGoodsDetailViewController *goodsDetail = [[LBGoodsDetailViewController alloc]init];
        
        goodsDetail._goodsID =home1Datas;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }else if ([type1 isEqualToString:@"special"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *str1 = ArrayHome1Datas[index];
        NSString *str2 = [NSString stringWithFormat:@"http://sugemall.com/wap/special.html?special_id=%@",str1];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [str2 stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        adv.tabBarController.tabBar.hidden=YES;

        [self.navigationController pushViewController:adv animated:YES];
        

    }

}

//上图
- (void)pushHome2:(UIGestureRecognizer*)sender
{
    NSInteger index = sender.view.tag-1111;
    NSString *home2Type = home2TypeArray[index];
    NSString *home2Data = home2DataArray[index];
    if ([home2Type isEqualToString:@"url"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [home2Data stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];
        
    }else if ([home2Type isEqualToString:@"keyword"]) {
        LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
        goodsList._keyWord = home2Data;
        goodsList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsList animated:YES];
        
        
    }else if ([home2Type isEqualToString:@"goods"]) {
        LBGoodsDetailViewController *goodsDetail = [[LBGoodsDetailViewController alloc]init];
        goodsDetail._goodsID =home2Data;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
    
}


//广告位
- (void)advListView
{
    for (int i = 0; i < model.item.count; i++) {
        modelItem = model.item[i];
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:imageButton.frame];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:modelItem.image] placeholderImage:IMAGE(@"dd_03_@2x")];
        [imageButton setBackgroundColor:[UIColor clearColor]];
        [imageButton setTag:100+i];
        [imageButton addTarget:self action:@selector(pushImageView:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:iamgeView];
        [_scrollView addSubview:imageButton];
    }


}


//imageButton事件
- (void)pushImageView:(UIButton *)btn
{
        NSUInteger index = btn.tag-100;
        modelItem = model.item[index];
    
    NSString *adv_data = modelItem.data;
    NSString *adv_type = modelItem.type;
    if ([adv_type isEqualToString:@"url"]) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
        NSString *url = [adv_data stringByAppendingString:apingd];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];

    }else if ([adv_type isEqualToString:@"keyword"]) {
        LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
        goodsList._keyWord = adv_data;
        goodsList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsList animated:YES];

    }else if ([adv_type isEqualToString:@"goods"]) {
        LBGoodsDetailViewController *goodsDetail = [[LBGoodsDetailViewController alloc]init];
        goodsDetail._goodsID =adv_data;
        goodsDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

//初始化pageControll
- (void)initPageControl
{
    __pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-20, SCREEN_WIDTH, 20)];
    __pageControl.numberOfPages = model.item.count;
    __pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [__pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    __pageControl.currentPage = 0;
    [headerView addSubview:__pageControl];
    
    timeCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}
//page动画
- (void)pageTurn:(UIPageControl *)aPage
{
    NSInteger whichPage = aPage.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * whichPage, 0) animated:YES];
    }];
}
//自动滚动
- (void)scrollTimer
{
    timeCount ++;
    __pageControl.currentPage = timeCount;
    if (timeCount == 3) {
        timeCount =0;
        __pageControl.currentPage = timeCount;
    }
    [_scrollView scrollRectToVisible:CGRectMake(timeCount * SCREEN_WIDTH, 65.0, SCREEN_WIDTH, SCREEN_HEIGHT/3) animated:YES];
}


#pragma mark --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.translucent = YES;
    [MobClick beginLogPageView:@"首页"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}
*/
@end
