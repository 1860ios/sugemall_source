//
//  LBStoreDetailViewController.m
//  SuGeMarket
//
//  店铺
//  Created by Apple on 15/7/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBStoreDetailViewController.h"
#import "UtilsMacro.h"
#import "AFNetworking.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "MXPullDownMenu.h"
#import "LBGoodsListModel.h"
#import "LBGoodsListDatasModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LBGoodsDetailViewController.h"

static NSString *goodsDetail = @"goodsDetail";
static NSString *collectionView_cid = @"collectionViewcid";

@interface LBStoreDetailViewController ()<UITableViewDataSource,UITableViewDelegate,
UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *view1;
    NSMutableDictionary *StoreDetailDictionary;
    int _curpage;
    MXPullDownMenu *menu;
    NSString *ii;
    NSMutableArray *newGoodsListDatas;
    NSMutableArray *goodsListDatas;
    NSString *curnum;
    NSString *key;
    NSArray *tagArray;
    BOOL isHasMore;
}
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic,strong) UICollectionView *goodsCollectionView;
@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *goodsnameLabel;
@property (nonatomic,strong) UILabel *goodspriceLabel;
@end

@implementation LBStoreDetailViewController
@synthesize _tableView;
@synthesize goodsCollectionView;
@synthesize goodsImageView;
@synthesize goodsnameLabel;
@synthesize goodspriceLabel;
@synthesize store_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卖家店铺";
    isHasMore = YES;
    _curpage = 1;
    newGoodsListDatas = [NSMutableArray array];
    goodsListDatas = [NSMutableArray array];

    [self loadcollectionView];
    [self loadStoreDetailTableView];
    [self setUpFooterRefresh];
    [self loadGoodsDetailDatas:store_id];
    [self loadGoodsDatas:store_id key:@"4" curpage:@"1"];
    
}

-(void)loadStoreDetailTableView
{
//#warning 店铺重构
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
}
-(void)loadcollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    goodsCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-230)collectionViewLayout:layout];
    goodsCollectionView.backgroundColor = [UIColor whiteColor];
    goodsCollectionView.delegate = self;
    goodsCollectionView.dataSource = self;
    goodsCollectionView.scrollEnabled  = YES;
    [goodsCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];

}

#pragma mark   --------添加上拉刷新

- (void)loadStoreNewData
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    if (key == nil) {
        key = @"4";
    }
    [self loadGoodsDatas:store_id key:key curpage:curnum];
}

- (void)setUpFooterRefresh
{

    [goodsCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadStoreNewData)];
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

#pragma mark   --------请求数据

//请求店铺信息
- (void)loadGoodsDetailDatas:(NSString *)storeID
{
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"store_id":storeID};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger GET:SUGE_STORE_DETAIL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"店铺详情:responObject:%@",responObject);
        StoreDetailDictionary=responObject[@"datas"][@"store_info"];
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络不佳:%@",error);
    }];
    [SVProgressHUD dismiss];
}

//请求店铺商品列表信息
- (void)loadGoodsDatas:(NSString *)storeID key:(NSString *)_key  curpage:(NSString *)curpage
{
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    NSDictionary *parameters = @{@"key":_key,@"store_id":storeID,@"page":@"20",@"curpage":curpage};

    [maneger GET:SUGE_STORE_LIST parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"店铺商品列表:reponObject:%@",responObject);

        NSString *hasmore = responObject[@"hasmore"];
        newGoodsListDatas = nil;
        newGoodsListDatas = responObject[@"datas"][@"goods_list"];
        if (isHasMore) {
            [goodsListDatas addObjectsFromArray:newGoodsListDatas];
            [goodsCollectionView reloadData];
        }else{
            [goodsCollectionView.footer noticeNoMoreData];
        }
        if ([hasmore isEqual:@0]) {
            // 变为没有更多数据的状态
            isHasMore = NO;
        }else{
           isHasMore = YES;
        }
        
        [goodsCollectionView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络错误:%@",error);
    }];
    [SVProgressHUD dismiss];
}
#pragma mark  --------tableview delegate/datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int section = (int)indexPath.section;
    switch (section) {
       
        case 0:{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:goodsCollectionView];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return SCREEN_HEIGHT-150;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    view1 =[[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 150)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    UIImageView *storeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,25, 25)];
    storeImageView.image=IMAGE(@"store_image.png");
    [view1 addSubview:storeImageView];
    //商店名
    UILabel *sellernameLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeImageView.frame.origin.x+storeImageView.frame.size.width+10,storeImageView.frame.origin.y, 300, 35)];
    sellernameLabel.font = [UIFont systemFontOfSize:15];
    sellernameLabel.textColor = [UIColor blackColor];
    sellernameLabel.text = StoreDetailDictionary[@"store_name"];
    sellernameLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:sellernameLabel];
    
    UILabel *gradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeImageView.frame.origin.x,sellernameLabel.frame.origin.y+sellernameLabel.frame.size.height, 80, 35)];
    gradeLabel.font = [UIFont systemFontOfSize:15];
    gradeLabel.textColor = [UIColor blackColor];
    gradeLabel.textAlignment = NSTextAlignmentLeft;
    gradeLabel.text=@"综合评分:";
    [view1 addSubview:gradeLabel];
    for (int i = 0; i<5; i++) {
        UIImageView *heartImageView=[[UIImageView alloc]initWithFrame:CGRectMake(gradeLabel.frame.origin.x+gradeLabel.frame.size.width+(35*i),gradeLabel.frame.origin.y,35,35)];
        heartImageView.image = IMAGE(@"heart1");
        [view1 addSubview:heartImageView];
    }
    
    UILabel *storeLabel=[[UILabel alloc]initWithFrame:CGRectMake(gradeLabel.frame.origin.x,gradeLabel.frame.origin.y+gradeLabel.frame.size.height, 80, 35)];
    storeLabel.font = [UIFont systemFontOfSize:15];
    storeLabel.textColor = [UIColor blackColor];
    storeLabel.textAlignment = NSTextAlignmentLeft;
    storeLabel.text=@"公司名:";
    [view1 addSubview:storeLabel];
   
    
    UILabel *storenameLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeLabel.frame.origin.x+storeLabel.frame.size.width,storeLabel.frame.origin.y, SCREEN_WIDTH-storeLabel.frame.size.width, 35)];
    storenameLabel.text = StoreDetailDictionary[@"store_company_name"];
    storenameLabel.font = [UIFont systemFontOfSize:15];
    storenameLabel.textColor = [UIColor blackColor];
    storenameLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:storenameLabel];
    
    //地址
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeLabel.frame.origin.x,storeLabel.frame.origin.y+storeLabel.frame.size.height, 80, 35)];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textColor = [UIColor blackColor];
    placeLabel.textAlignment = NSTextAlignmentLeft;
    placeLabel.text=@"所在地:";
    [view1 addSubview:placeLabel];
    
    UILabel *placenameLabel=[[UILabel alloc]initWithFrame:CGRectMake(storenameLabel.frame.origin.x,storenameLabel.frame.origin.y+storenameLabel.frame.size.height, storenameLabel.frame.size.width, 35)];
    placenameLabel.text = StoreDetailDictionary[@"store_address"];
    placenameLabel.font = [UIFont systemFontOfSize:15];
    placenameLabel.textColor = [UIColor blackColor];
    placenameLabel.textAlignment = NSTextAlignmentLeft;
    [view1 addSubview:placenameLabel];

    /*
    menu = [[MXPullDownMenu alloc] initWithArray:_titles selectedColor:APP_COLOR];
    menu.delegate = self;
    menu.frame = CGRectMake(0,placeLabel.frame.origin.y+placeLabel.frame.size.height,SCREEN_WIDTH,45);
    [view1 addSubview:menu];
    */
    tagArray = @[@"4",@"3",@"2",@"1"];
    NSArray *normalNameArray = @[@"xinpin_normal",@"jiage_normal",@"xiaoliang_normal",@"renqi_normal"];
    NSArray *selectNameArray = @[@"xinpin_select",@"jiage_select",@"xiaoliang_select",@"renqi_select"];
    for (int i = 0; i<4; i++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(EACH_W(4 * i)+5, placeLabel.frame.origin.y+placeLabel.frame.size.height, 70, 30);
        //        button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button1 setTitleColor:[UIColor whiteColor] forState:0];
        [button1 setImage:IMAGE(normalNameArray[i]) forState:UIControlStateNormal];
        [button1 setImage:IMAGE(selectNameArray[i]) forState:UIControlStateSelected];
        NSInteger tag = [tagArray[i] integerValue];
        button1.tag = tag;
        [button1 addTarget:self action:@selector(segmentedMethod:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:button1];
    }

    return view1;
}

- (void)segmentedMethod:(UIButton *)btn
{
    for (int i = 0; i<4; i++) {
        NSInteger tag = [tagArray[i] integerValue];
        UIButton *button2 = (UIButton *)[self.view viewWithTag:tag];
        button2.selected = NO;
    }
    btn.selected  = YES;
    NSString *type = [NSString stringWithFormat:@"%li",(long)btn.tag];
    newGoodsListDatas = [NSMutableArray array];
    goodsListDatas = [NSMutableArray array];
    isHasMore = YES;
    [self loadGoodsDatas:store_id key:type curpage:@"1"];
}

#pragma mark  --------MXPullDownMenu代理方法
/*
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu
didSelectRowAtColumn:(NSInteger)column
                 row:(NSInteger)row{
    newGoodsListDatas = [NSMutableArray array];
    goodsListDatas = [NSMutableArray array];

    switch (column) {
        case 0:
        key = @"4";
            break;
            
        case 1:
        key = @"3";
            break;
        case 2:
        key = @"2";
            break;
        case 3:
        key = @"1";
            break;
    }

    [self loadGoodsDatas:store_id key:key curpage:@"1"];

}

*/
#pragma mark  --------collectionView  代理方法


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return goodsListDatas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    goodsImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH/2-30-10, SCREEN_WIDTH/2-30-10);
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:[goodsListDatas objectAtIndex:row][@"goods_image_url"]] placeholderImage:IMAGE(@"dd_03_@2x")];
    [cell.contentView addSubview:goodsImageView];
    
    UIView *linView =[[UIView alloc]initWithFrame:CGRectMake(0,goodsImageView.frame.origin.y+goodsImageView.frame.size.height+2,SCREEN_WIDTH/2-10 , 1)];
    [linView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:linView];

    
    goodsnameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.frame.origin.x,goodsImageView.frame.origin.y+goodsImageView.frame.size.height,goodsImageView.frame.size.width,45)];
//    goodsnameLabel.font = FONT(13);
    goodsnameLabel.numberOfLines = 2;
    goodsnameLabel.text=[goodsListDatas objectAtIndex:row][@"goods_name"];
    goodsnameLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:goodsnameLabel];
    
    goodspriceLabel =  [[UILabel alloc] initWithFrame:CGRectMake(goodsnameLabel.frame.origin.x,goodsnameLabel.frame.origin.y+goodsnameLabel.frame.size.height,goodsnameLabel.frame.size.width,20)];
    goodspriceLabel.adjustsFontSizeToFitWidth = YES;
    goodspriceLabel.textAlignment=NSTextAlignmentCenter;
    goodspriceLabel.text=[goodsListDatas objectAtIndex:row][@"goods_price"];
    goodspriceLabel.textColor = APP_COLOR;
    [cell.contentView addSubview:goodspriceLabel];
    
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
    NSString *good_ID = [goodsListDatas objectAtIndex:row][@"goods_id"];
    LBGoodsDetailViewController *deVC =[[LBGoodsDetailViewController alloc] init];
    deVC._goodsID = good_ID;
    [self.navigationController pushViewController:deVC animated:YES];
}



@end
