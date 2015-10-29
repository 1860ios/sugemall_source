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
//#import "LBMyMessageViewController.h"
#import "LBBaseMethod.h"
#import "RecipeCollectionReusableView.h"
#import "MZTimerLabel.h"
#import "NotificationMacro.h"
#import "LBShoppingCarViewController.h"
#import "LBClassifyPageView.h"
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
    NSMutableArray *datasArray;
    NSMutableArray *datas1Array;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"苏格时代商城";
    self.navigationItem.title =@"苏格时代商城";
    [self initArrayDatas];
    [self addNotObserver];
    [self setUpNavBar];
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    [self requestHomeDatas];
    });
    dispatch_async(queue, ^{
        [self requestQianggouDatas:@"16,18,20"];
    });
    dispatch_async(queue, ^{
        [self loadONEclassicfy];
    });
    [self loadCollectionView];
    [self loadOthersButton];
    
}
- (void)loadONEclassicfy{
    [LBBaseMethod get:SUGE_1_FENLEI parms:nil success:^(id json){
        NSLog(@"一级分类:%@",json);
        datasArray = [NSMutableArray array];
        datas1Array = [NSMutableArray array];
        NSMutableArray *datas = json[@"datas"][@"class_list"];
        for (int i = 0; i < datas.count; i++) {
            NSString *name = datas[i][@"gc_name"];
            NSString *gc_id= datas[i][@"gc_id"];
            [datasArray addObject:name];
            [datas1Array addObject:gc_id];
        }
    }failture:^(id error){
        
    }];
}
//
- (void)loadOthersButton
{
    NSArray *bottonImage = @[@"shouye_car",@"shouye_kefu",@"shouye_top"];
    for (int i = 0; i < 3; i++) {
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 2) {
            otherButton.frame = CGRectMake(SCREEN_WIDTH-15-50, SCREEN_HEIGHT-120, 50, 50);
        }else{
            otherButton.frame = CGRectMake(15+i*60, SCREEN_HEIGHT-120, 50, 50);
        }
        [otherButton setImage:IMAGE(bottonImage[i]) forState:UIControlStateNormal];
        otherButton.tag = 76+i;
        [otherButton addTarget:self action:@selector(otherButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:otherButton];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIColor *color = [UIColor blueColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
//        CGFloat alpha = 1 - ((64 - offsetY) / 64);
//        self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
        [UIView animateWithDuration:0.4 animations:^{
            self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
        }];
        
    } else {
//        self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:0];
        [UIView animateWithDuration:0.4 animations:^{
//            self.tabBarController.tabBar.hidden = NO;
        self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
        }];

    }
}

- (void)otherButtonMethod:(UIButton *)btn
{
    long btn_tag = btn.tag-76;
    switch (btn_tag) {
        case 0:{
            LBShoppingCarViewController *car = [LBShoppingCarViewController new];
            car.isPushIn = YES;
            car.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:car animated:YES];
        }
        break;
            
        case 1:{

            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"037763533999"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        break;
    
        case 2:{
            [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
        break;
    
    }
}

- (void)setUpNavBar
{
    UIImageView *left_image = [[UIImageView alloc] initWithImage:IMAGE(@"left")];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:left_image];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLeftView:)];
    [left_image addGestureRecognizer:tap1];
    self.navigationItem.leftBarButtonItem = left;
    UIImageView *right_image = [[UIImageView alloc] initWithImage:IMAGE(@"search")];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:right_image];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchView:)];
    [right_image addGestureRecognizer:tap2];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)pushLeftView:(UIBarButtonItem *)btn
{
    [NOTIFICATION_CENTER postNotificationName:@"pushleftView" object:nil];
}
#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
- (void)pushSearchView:(UIBarButtonItem *)btn
{
    LBSearchViewController *searchView = [[LBSearchViewController alloc] init];
    searchView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchView animated:YES];
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
    //一级分类
    [NOTIFICATION_CENTER addObserver:self selector:@selector(psuhFenlei:) name:@"pushclassify" object:nil];
    
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
//分类
- (void)psuhFenlei:(NSNotification *)not
{
    NSString *gcid = [[not userInfo] valueForKey:@"gc_id"];
    LBClassifyPageView *classify = [LBClassifyPageView new];
    classify.nameArray = datasArray;
    classify.idArray = datas1Array;
    classify.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classify animated:YES];
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
//        NSDictionary *groupListDic = json[@"datas"][@"groupbuy_group_list"];
//        if (!groupListDic) {
        NSArray *json1 = json[@"datas"][@"groupbuy_group_list"];
        if (json1.count != 0) {
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
        NSLog(@"groupArray:%@,hoursArr:%@,tagArray:%@",groupArray,hoursArr,tagArray);
        
//        }
        [self.collectionView reloadData];
        }
    }failture:^(id  error){
        
    }];
    
}

#pragma mark not
- (void)pushView:(NSNotification *)not
{
//    NSString *type =  [[not userInfo] valueForKey:@"type"];
//    if ([type isEqualToString:@"1"] ) {
//        LBMyMessageViewController *mess = [[LBMyMessageViewController alloc] init];
//        mess.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:mess animated:YES];
//    }
    
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

@end
