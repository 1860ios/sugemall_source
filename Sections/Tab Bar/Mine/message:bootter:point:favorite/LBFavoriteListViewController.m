//
//  LBFavoriteListViewController.m
//  SuGeMarket
//
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//
#import <TSMessage.h>
#import "LBFavoriteListViewController.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MobClick.h"
#import "MJRefresh.h"
#import "LBGoodsDetailViewController.h"
static NSString *collectionView_cid=@"collectionView_cid";

@interface LBFavoriteListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    //网络数据
    NSMutableArray *_favorites;

    
    UIView *view1;
    NSMutableDictionary *StoreDetailDictionary;
    int _curpage;
    NSString *ii;
    NSMutableArray *newGoodsListDatas;
    NSMutableArray *goodsListDatas;
    NSString *curnum;
    NSString *key;
    NSArray *tagArray;
    BOOL isHasMore;
}
@property (nonatomic, strong) UICollectionView *favoriteCollectionView;


@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic,strong) UICollectionView *goodsCollectionView;
@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *goodsnameLabel;
@property (nonatomic,strong) UILabel *goodspriceLabel;

@end

@implementation LBFavoriteListViewController
@synthesize favoriteCollectionView;

@synthesize _tableView;
@synthesize goodsCollectionView;
@synthesize goodsImageView;
@synthesize goodsnameLabel;
@synthesize goodspriceLabel;
#pragma mark viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收藏";
    _favorites = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self drawFavoriteCollectionView];
    [self setUpRefresh];
}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    
    [self loadDatas];
   
     [MobClick beginLogPageView:@"我的收藏"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的收藏"];
}
#pragma mark 初始化CollectionView

-(void)drawFavoriteCollectionView
{
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    favoriteCollectionView= [[UICollectionView alloc]initWithFrame:CGRectMake(10,0,SCREEN_WIDTH,SCREEN_HEIGHT)collectionViewLayout:flowLayout];
//    //注册
//    [favoriteCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
//    //设置代理
//    favoriteCollectionView.delegate = self;
//    favoriteCollectionView.dataSource = self;
//    favoriteCollectionView.scrollEnabled  =YES;
//    favoriteCollectionView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:favoriteCollectionView];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    goodsCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)collectionViewLayout:layout];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    goodsCollectionView.backgroundColor = [UIColor whiteColor];
    goodsCollectionView.delegate = self;
    goodsCollectionView.dataSource = self;
    goodsCollectionView.scrollEnabled  = YES;
    [goodsCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
    [self.view addSubview:goodsCollectionView];

}
#pragma mark CollectionView delegate
#pragma mark  --------collectionView  代理方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _favorites.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
//    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
//    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.borderWidth = 1.0f;
//    
//    while ([cell.contentView.subviews lastObject]) {
//        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
        cell.layer.borderColor = [UIColor colorWithWhite:0.90 alpha:0.93].CGColor;
        cell.layer.borderWidth = 1.0f;
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    goodsImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH/2-30, SCREEN_WIDTH/2-20);
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:_favorites[row][@"goods_image_url"] ] placeholderImage:IMAGE(@"dd_03_@2x")];
    [cell.contentView addSubview:goodsImageView];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(goodsImageView.frame.origin.x+goodsImageView.frame.size.width-60,goodsImageView.frame.origin.y+goodsImageView.frame.size.height-40,60,35)];
    view.backgroundColor=[UIColor colorWithWhite:0.30 alpha:0.50];
    [cell.contentView addSubview:view];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    goodspriceLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width,view.frame.size.height)];
    goodspriceLabel.adjustsFontSizeToFitWidth =YES;
    goodspriceLabel.textAlignment=NSTextAlignmentCenter;
    goodspriceLabel.text=[NSString stringWithFormat:@"￥%@",_favorites[row][@"goods_price"]];
    goodspriceLabel.textColor = [UIColor whiteColor];
    [view addSubview:goodspriceLabel];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-10,SCREEN_WIDTH/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 0, 2 );
}
#pragma mark 设置下拉刷新
- (void)setUpRefresh
{
    __weak typeof(self) weakSelf = self;
    [goodsCollectionView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadDatas];
    }];
    // 隐藏时间
    goodsCollectionView.header.updatedTimeHidden = YES;
    // 设置文字
    [goodsCollectionView.header setTitle:APP_REFRESH_TEXT_STATID forState:MJRefreshHeaderStateIdle];
    [goodsCollectionView.header setTitle:APP_REFRESH_TEXT_PULLING forState:MJRefreshHeaderStatePulling];
    [goodsCollectionView.header setTitle:APP_REFRESH_TEXT_REFRESHING forState:MJRefreshHeaderStateRefreshing];

    // 设置字体
    goodsCollectionView.header.font = APP_REFRESH_FONT_SIZE;

    // 设置颜色
    goodsCollectionView.header.textColor = APP_COLOR;
}



#pragma mark 加载数据
- (void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key1 = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"key":key1};
    [manager POST:SUGE_FAVORITE_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"responObject:%@",responObject);
        //miss提示
        [SVProgressHUD dismiss];
        _favorites = responObject[@"datas"][@"favorites_list"];
        
        //判断收藏数组是否为空
        if (_favorites.count == 0) {
            NSLog(@"收藏数组为空");
            goodsCollectionView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"suge_no_favoritegoods")];
        }else{
            goodsCollectionView.backgroundView = [UIView new];
        }
        //刷新tableview
        [goodsCollectionView reloadData];
        //结束刷新
        [goodsCollectionView.header endRefreshing];
        
           } failure:^(AFHTTPRequestOperation *op,NSError *error){
               [SVProgressHUD dismiss];
               [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
               NSLog(@"error:%@",error);
    }];
    
}

//#pragma mark 收藏的tableview
//- (void)drawFavoriteTableView
//{
//    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//    __tableView.delegate =self;
//    __tableView.dataSource =self;
//    //    __tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
//    __tableView.tableFooterView = [UIView new];
//    [__tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
//    [self.view addSubview:__tableView];
//    
//}
//#pragma mark tableview  delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger row = indexPath.row;
//    //商品编号
//    NSString *goodsID = _favorites[row][@"goods_id"];
//    NSLog(@"goodsID:%@",goodsID);
//    LBGoodsDetailViewController *goodsVC = [[LBGoodsDetailViewController alloc]init];
//    goodsVC._goodsID = goodsID;
//    [self.navigationController pushViewController:goodsVC animated:YES];
//
//}
//
//#pragma mark tableview  datasource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    return _favorites.count;
//
//}
//#pragma mark
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    NSInteger row = indexPath.row;
//    UITableViewCell *cell = nil;
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
//        //平滑
//        cell.layer.shouldRasterize = YES;
//        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//
//    //商品图
//    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 120)];
//    goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:_favorites[row][@"goods_image_url"] ] placeholderImage:IMAGE(@"dd_03_@2x")];
//    [cell.contentView addSubview:goodsImageView];
//    //商品名
//    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.frame.size.width+15, 5, SCREEN_WIDTH-140, 40)];
//    goodsName.numberOfLines = 2;
////    goodsName.font = [UIFont systemFontOfSize:19];
//    goodsName.text = _favorites[row][@"goods_name"];
////    goodsName.adjustsFontSizeToFitWidth = YES;
//        goodsName.font = FONT(14);
//    [cell.contentView addSubview:goodsName];
//    
//    //商品价格
//    UILabel *goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x, 90, 60, 25)];
//    goodsPrice.textColor = [UIColor redColor];
//    goodsPrice.text = [NSString stringWithFormat:@"￥%@",_favorites[row][@"goods_price"]];
//    goodsPrice.adjustsFontSizeToFitWidth = YES;
//    [cell.contentView addSubview:goodsPrice];
//    }
//    return cell;
//}
//
//#pragma mark  heightForRowAtIndexPath
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 130;
//}
//
//#pragma mark  滑动删除
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//#pragma mark
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        //提示
//        [SVProgressHUD showWithStatus:@"删除中..." maskType:SVProgressHUDMaskTypeClear];
//        NSInteger row = indexPath.row;
//        //登陆key
//        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
//        //收藏编号
//        NSString *fav_id = _favorites[row][@"fav_id"];
//        NSLog(@"fav_id:%@",fav_id);
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
//        NSDictionary *parameter =@{@"fav_id":fav_id,@"key":key};
//        
//        [manager POST:SUGE_FAVORITE_DEL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
//            
//            [SVProgressHUD dismiss];
//            NSLog(@"responObject:%@",responObject);
//
//            if ([responObject[@"datas"] isEqualToString:@"1"]) {
//
//                //再次请求数据
//                [self loadDatas];
//            }
//            } failure:^(AFHTTPRequestOperation *op,NSError *error){
//        }];
//
//    }
//
//}



@end
