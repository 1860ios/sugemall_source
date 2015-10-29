//
//  LBGoodsDetailViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsDetailViewController.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "MobClick.h"
#import "UtilsMacro.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+WebCache.h"
#import "LBGoodsInfoCell.h"
#import "LBStroeInforCell.h"
#import "UIView+Extension.h"
#import "LBGoodsDetailModel.h"
#import "LBGoodsCommendListModel.h"
#import "MJExtension.h"
#import "LBGoodsBodyViewController.h"
#import "DOPNavbarMenu.h"
#import "LBShoppingCarViewController.h"
#import "NotificationMacro.h"
#import "AppMacro.h"
#import "LBGoodsInfoModel.h"
#import "LBSelecGoodsView.h"
#import "UMSocial.h"
#import "LBBuyStep1ViewController.h"
#import "HJCAjustNumButton.h"
#import "LBLognInViewController.h"
#import "AppMacro.h"
#import "LBStoreDetailViewController.h"
#import <MWPhotoBrowser.h>

static NSString *collectionView_cid = @"collectionViewcid";

@interface LBGoodsDetailViewController ()<UITableViewDelegate,
                                         UITableViewDataSource,
                                         UICollectionViewDelegateFlowLayout,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         DOPNavbarMenuDelegate,
                                         MWPhotoBrowserDelegate
                                         >
{
    int timeCount;
    int kImageCount;
    UIView *headerView;
    UIView *selecBGView;
    LBSelecGoodsView *seleView;
    //收藏
    UIButton *favoriteBtn;
    UILabel *favoriteLabel;
    //立即购买
    UIButton *BuyNowBtn;
    UILabel *BuyNowLabel;
    //加入购物车
    UIButton *addCarBtn;
    UILabel *addCarLabel;
    UIView *bottomView;
    //model
    LBGoodsDetailModel *model;
    LBGoodsCommendListModel *modelCommendList;
    LBGoodsInfoModel *modelInfo;
    //
    HJCAjustNumButton *numButton;
    //
    NSString *currentNum;
    NSString *fr;
    NSString *kucun;
    NSString *yushou;
    NSInteger num1;
    NSInteger num2;
    NSInteger num11;
    NSInteger num22;
    //
    NSInteger countList;
    NSInteger countSize;
    
    //
    UIView *_scrollBG;
    UIImageView *iamgeView;
    UIButton *imageButton;
    
    //
    UIButton *storeButton;
    UIButton *shoppingButton;
    //
    RadioBox *bb1;
    RadioBox *bb2;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *_goodsIamge;
@property (nonatomic, retain) UILabel *_goodsName;
@property (nonatomic, retain) UILabel *_goodsPrice;

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UIScrollView *_scrollView;
@property (nonatomic, strong) UIPageControl *_pageControl;

@property (assign, nonatomic) NSInteger numberOfItemsInRow;
@property (strong, nonatomic) DOPNavbarMenu *menu;
@end

@implementation LBGoodsDetailViewController
@synthesize radiobox1,radiobox2,radioGroup1,radioGroup2;
@synthesize _tableView;
@synthesize _goodsID;

#pragma mark --viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];

    //首页
    [self loadDOPMenu];
    //初始化bottom bar
    [self initBottomBar];
    //猜你喜欢
    [self loadCollectionView];
    //请求数据
    [self loadGoodsDetailDatas:_goodsID];
}

#pragma mark
- (DOPNavbarMenu *)menu {
    if (_menu == nil) {
        DOPNavbarMenuItem *item1 = [DOPNavbarMenuItem ItemWithTitle:nil icon:IMAGE(@"Shopping_Cart")];
        DOPNavbarMenuItem *item2 = [DOPNavbarMenuItem ItemWithTitle:nil icon:IMAGE(@"home_page")];
        DOPNavbarMenuItem *item3 = [DOPNavbarMenuItem ItemWithTitle:nil icon:IMAGE(@"share")];
        _menu = [[DOPNavbarMenu alloc] initWithItems:@[item1,item2,item3] width:self.view.dop_width maximumNumberInRow:_numberOfItemsInRow];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.delegate = self;
    }
    return _menu;
}

#pragma mark -----------------***loadDOPMenu***---------------------
#pragma mark loadDOPMenu

- (void)loadDOPMenu
{
    self.numberOfItemsInRow = 3;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
}


- (void)openMenu:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}

- (void)didShowMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.rightBarButtonItem setTitle:@"更多"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    LBShoppingCarViewController *shop = [[LBShoppingCarViewController alloc] init];
    switch (index) {
        case 0:{
            shop.isPushIn = YES;
            [self.navigationController pushViewController:shop animated:YES];
//            [NOTIFICATION_CENTER postNotificationName:SUGE_NOT_PUSHTOCAR_VIEW object:nil];
        }
            break;
        case 1:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2:
            NSLog(@"share");
            [self shareGoods];
            break;
    }
}

-(void)shareGoods
{
    NSLog(@"fr:%@",fr);
    NSData* originData = [fr dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSLog(@"encodeResult:%@",encodeResult);
    NSString *shareText = model.goods_info.goods_name;
    NSString *text = [NSString stringWithFormat:@"http://sugemall.com/mobile/?act=member_wechat&op=login&refer=http://sugemall.com/wap/tmpl/product_detail.html?goods_id=%@&fr=%@",_goodsID,encodeResult];             //分享内嵌文字
    [UMSocialData defaultData].extConfig.wechatSessionData.url = text;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = text;
//    UIImage *shareImage = [UIImage imageNamed:@"suge_icon"];          //分享内嵌图片
    NSDictionary *imgDict = [NSDictionary dictionary];
    imgDict = model.goods_img[0];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imgDict[@"goods_image_url"]];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5541f4cf67e58e03a9002933"
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone,UMShareToQQ,nil]
                                       delegate:nil];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.menu = nil;
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


#pragma mark 最下面工具栏

- (void)initBottomBar
{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-EACH_H, SCREEN_WIDTH, EACH_H)];
    bottomView.backgroundColor = [UIColor whiteColor];
        //店铺
    storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    storeButton.frame = CGRectMake(15,0,49,49);
    [storeButton setImage:IMAGE(@"store_icon") forState:UIControlStateNormal];
    [storeButton addTarget:self action:@selector(goToStore) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:storeButton];
    
    UIView *lin1 = [[UIView alloc] initWithFrame:CGRectMake(storeButton.frame.size.width+storeButton.frame.origin.x+15, 0, 0.5, 49)];
    lin1.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lin1];
    //购物车
    shoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingButton.frame = CGRectMake(lin1.frame.size.width+lin1.frame.origin.x+15,0,49,49);
    [shoppingButton setImage:IMAGE(@"myShoppingCar") forState:UIControlStateNormal];
    [shoppingButton addTarget:self action:@selector(goToShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shoppingButton];
    
    UIView *lin2 = [[UIView alloc] initWithFrame:CGRectMake(shoppingButton.frame.size.width+shoppingButton.frame.origin.x+15, 0, 0.5, 49)];
    lin2.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lin2];
    
    //2.
    addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCarBtn.frame = CGRectMake(lin2.frame.origin.x+1, 0, (SCREEN_WIDTH-lin2.frame.origin.x+1)/2, 49);
//    [addCarBtn setBackgroundColor:APP_BOTTOM_BAR_ADD_CAR];
    [addCarBtn setTitle:@"加入购物车" forState:0];
    [addCarBtn setTitleColor:[UIColor blackColor] forState:0];
    addCarBtn.titleLabel.font = FONT(15);
    [addCarBtn addTarget:self action:@selector(sameToBuy) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addCarBtn];
    //3.
    BuyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BuyNowBtn.frame = CGRectMake(addCarBtn.frame.origin.x+addCarBtn.frame.size.width,0,addCarBtn.frame.size.width,49);
    [BuyNowBtn setBackgroundColor:APP_BOTTOM_BAR_BUY_NOW];
    [BuyNowBtn setTitle:@"立即购买" forState:0];
    BuyNowBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [BuyNowBtn setTitleColor:[UIColor whiteColor] forState:0];
    [BuyNowBtn addTarget:self action:@selector(sameToBuy) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:BuyNowBtn];
    UIView *lin0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lin0.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lin0];

    [self.view addSubview:bottomView];
}



#pragma mark --加载tableview
- (void)loadGoodsDetailTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT-bottomView.frame.size.height-63) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}

#pragma mark -----------------***初始化滚动视图***---------------------

- (void)initScrollView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*3/5 )];
    
    __scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerView.frame.size.height)];
    __scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * kImageCount, headerView.frame.size.height/2);
    __scrollView.delegate = self;

    __scrollView.userInteractionEnabled = YES;
    __scrollView.pagingEnabled = YES;
    __scrollView.directionalLockEnabled = YES;
    __scrollView.showsVerticalScrollIndicator = NO;
    __scrollView.showsHorizontalScrollIndicator = NO;
    __scrollView.bounces = NO;
    [headerView addSubview:__scrollView];

    for (int i = 0; i < kImageCount; i++) {
        imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, __scrollView.frame.size.height)];
        iamgeView = [[UIImageView alloc] initWithFrame:imageButton.frame];
        NSDictionary *imgDict = [NSDictionary dictionary];
        imgDict = model.goods_img[i];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:imgDict[@"goods_image_url"]] placeholderImage:IMAGE(@"dd_03_@2x")];//应该是model.goods_image[i]

        [imageButton setBackgroundColor:[UIColor clearColor]];
        [imageButton setTag:100+i];
        [imageButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [__scrollView addSubview:iamgeView];
        [__scrollView addSubview:imageButton];
    }
    
    //初始化page
    [self initPageControl];
    
    _tableView.tableHeaderView = headerView;
    
}
- (void)starButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(pushView1:) object:sender];
    [self performSelector:@selector(pushView1:) withObject:sender afterDelay:0.2f];
}

#pragma mark 图浏览器
- (void)pushView1:(UIButton *)btn
{

    self.photos = [NSMutableArray array];
    for (int i = 0; i < kImageCount; i++) {
        NSDictionary *imgDict = [NSDictionary dictionary];
        imgDict = model.goods_img[i];
//        [NSURL URLWithString:imgDict[@"goods_image_url"];
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgDict[@"goods_image_url"]]]];
    }
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
//    BOOL autoPlayOnAppear = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
//    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:10];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

//初始化pageControll
- (void)initPageControl
{
    __pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, __scrollView.frame.size.height-20, SCREEN_WIDTH, 20)];
    __pageControl.numberOfPages = kImageCount;
    __pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [__pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    __pageControl.currentPage = 0;
    [headerView addSubview:__pageControl];
    
    timeCount = 0;
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}
//page动画
- (void)pageTurn:(UIPageControl *)aPage
{
    NSInteger whichPage = aPage.currentPage;
    [UIView animateWithDuration:0.3 animations:^{
        [__scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * whichPage, 0) animated:YES];
    }];
}
//自动滚动
- (void)scrollTimer
{
    timeCount ++;
    __pageControl.currentPage = timeCount;
    if (timeCount == kImageCount) {
        timeCount =0;
        __pageControl.currentPage = timeCount;
    }
    [__scrollView scrollRectToVisible:CGRectMake(timeCount * SCREEN_WIDTH, 65.0, SCREEN_WIDTH, SCREEN_HEIGHT/kImageCount) animated:YES];
}



#pragma mark -----------------***请求数据***---------------------

- (void)loadGoodsDetailDatas:(NSString *)goodsID 
{
    
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"goods_id":goodsID};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger GET:SUGE_GOODS_DETAIL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"商品详情:responObject:%@",responObject);
        if (responObject[@"datas"][@"error"] != nil) {
            NSString *error = responObject[@"datas"][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 113;
            [alert show];
        }else{
        model = [LBGoodsDetailModel objectWithKeyValues:responObject[@"datas"]];
        kImageCount = (int)model.goods_img.count;
//        NSLog(@"spec_name:%@",[model.goods_info.spec_name allValues]);    
        fr = model.store_info.member_id;
        
        //加载详情列表
        [self loadGoodsDetailTableView];
        //初始化滚动视图
        [self initScrollView];
        [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"网络不佳:%@",error);
    }];
    [SVProgressHUD dismiss];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 113) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark -----------------***tableview delegate***---------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    LBGoodsInfoCell *cell1 = nil;
    LBStroeInforCell *cell3 = nil;
    if (0 ==section) {
    if (!cell1) {
        cell1 = [[LBGoodsInfoCell alloc] init];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1 addTheValue:model];
        [cell1._favoriteButton addTarget:self action:@selector(addFavoriteGoods:) forControlEvents:UIControlEventTouchUpInside];
        kucun = model.goods_info.goods_storage;
        yushou = model.goods_info.is_presell;
        }
        return cell1;
    }else if (1 ==section){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"选择商品尺码 样式";
        return cell;
    }else if (2 ==section){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"图文介绍";
        return cell;
    }else if (3 ==section){
        if (!cell3) {
            cell3 = [[LBStroeInforCell alloc] init];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell3.lianxikefu addTarget:self action:@selector(lianxikefu) forControlEvents:UIControlEventTouchUpInside];
            [cell3.jinrudianpu addTarget:self action:@selector(jinrudianpu) forControlEvents:UIControlEventTouchUpInside];
            [cell3 addTheValue:model];
        }
        return cell3;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *t1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
        t1.text = @"猜你喜欢";
        t1.font = BFONT(15);
        t1.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:t1];
        [cell.contentView addSubview:_collectionView];
        return cell;
    }
}
- (void)lianxikefu
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"037763533999"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)jinrudianpu
{
    LBStoreDetailViewController *store = [[LBStoreDetailViewController alloc] init];
    store.store_id = model.goods_info.store_id;
    [self.navigationController pushViewController:store animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        return 130;
    }else if (section == 1){
        return 45;
    }else if (section == 2){
        return 45;
    }else if (section == 3){
        return 140;
    }else{
        return 170;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section==1){
        return 1;
    }else if (section ==2){
        return 1;
    }else if (section ==3){
        return 1;
    }else{
        return 1;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section == 1) {
        [self sameToBuy];
    }
    if (section == 2) {
        NSLog(@"图文详情");
        LBGoodsBodyViewController *goodsBody = [[LBGoodsBodyViewController alloc] init];
        goodsBody._goods_id = _goodsID;
        [self.navigationController pushViewController:goodsBody animated:YES];
    }else if (section == 3){
        LBStoreDetailViewController *store = [[LBStoreDetailViewController alloc] init];
        store.store_id = model.goods_info.store_id;
        [self.navigationController pushViewController:store animated:YES];
    }
}

#pragma mark -- cell线
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark -----------------***loadCollectionView***---------------------
- (void)loadCollectionView
{
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,30,SCREEN_WIDTH,140)collectionViewLayout:flowLayout];
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled  =YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark collectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return model.goods_commend_list.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelCommendList = model.goods_commend_list[row];
    
    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    __goodsIamge = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 100, 100)];
    __goodsIamge.contentMode = UIViewContentModeScaleAspectFit;
    [__goodsIamge sd_setImageWithURL:[NSURL URLWithString:modelCommendList.goods_image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
    [cell.contentView addSubview:__goodsIamge];
    
    __goodsPrice =  [[UILabel alloc] initWithFrame:CGRectMake(__goodsIamge.frame.origin.x,__goodsIamge.frame.size.height-20,40,20)];
    __goodsPrice.adjustsFontSizeToFitWidth = YES;
    __goodsPrice.text = [NSString stringWithFormat:@"￥%@",modelCommendList.goods_price];
    __goodsPrice.textColor = APP_COLOR;
    [cell.contentView addSubview:__goodsPrice];
    
    __goodsName =  [[UILabel alloc] initWithFrame:CGRectMake(__goodsIamge.frame.origin.x,__goodsIamge.frame.origin.y+__goodsIamge.frame.size.height,__goodsIamge.frame.size.width,40)];
//    __goodsName.adjustsFontSizeToFitWidth = YES;
    __goodsName.font = FONT(13);
    __goodsName.numberOfLines = 2;
    __goodsName.text = [NSString stringWithFormat:@"%@",modelCommendList.goods_name];
    __goodsName.highlightedTextColor  = APP_COLOR;
    [cell.contentView addSubview:__goodsName];
    //
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelCommendList = model.goods_commend_list[row];
    NSString *good_ID = modelCommendList.goods_id;
    LBGoodsDetailViewController *deVC =[[LBGoodsDetailViewController alloc] init];
    deVC._goodsID = good_ID;
    [self.navigationController pushViewController:deVC animated:YES];
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    
    return UIEdgeInsetsMake ( 0 , 0 , 0 , 0 );
    
}
//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return CGSizeMake (100,140);
    
}
//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}


#pragma mark -----------------***button method***---------------------
#pragma mark 添加收藏
- (void)addFavoriteGoods:(UIButton *)btn
{
    NSLog(@"添加收藏");
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (!isLogin) {
        [self notSignIn];
        
    }else{
        if (btn.selected) {
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"您已经收藏过了!亲" type:TSMessageNotificationTypeWarning];
        }else{
        [self addDatasURL:SUGE_FAVORITE_ADD Quantity:nil goodsid:nil];
        btn.selected = YES;
        }
    }
}

#pragma mark 前往店铺
- (void)goToStore
{
    LBStoreDetailViewController *store = [[LBStoreDetailViewController alloc] init];
    store.store_id = model.goods_info.store_id;
    [self.navigationController pushViewController:store animated:YES];
}

#pragma mark 前往购物车
- (void)goToShoppingCar
{
    LBShoppingCarViewController *shopping = [[LBShoppingCarViewController alloc] init];
    shopping.isPushIn = YES;
    [self.navigationController pushViewController:shopping animated:YES];
}

- (void)hideRightView
{
//    currentNum = nil;
//    _goodsID  = nil;
    [UIView animateWithDuration:0.4 animations:^{
        seleView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-SEPEC_RIGHTVIEW_DISTANCE, SCREEN_HEIGHT);
        [selecBGView removeFromSuperview];
    }];
}
- (void)notSignIn
{
    LBLognInViewController *loginIn = [[LBLognInViewController alloc] init];
    [self hideRightView];
    [self.navigationController pushViewController:loginIn animated:YES];
}

#pragma mark  *******************右侧商品选项*******************

- (void)sameToBuy
{
//    if ([kucun isEqualToString:@"0"]) {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起,此商品库存为0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//        [self hideRightView];
//    }else{
    //    [self addDatasURL:SUGE_CAR_ADD Quantity:@"2"];
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRightView)];
    
    selecBGView=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    selecBGView.backgroundColor = [UIColor blackColor];
    selecBGView.alpha = 0.5;
    [selecBGView addGestureRecognizer:recognizer];
    [self.view addSubview:selecBGView];
    //右侧商品
    seleView = [[LBSelecGoodsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 63, SCREEN_WIDTH-SEPEC_RIGHTVIEW_DISTANCE, SCREEN_HEIGHT-63)];
    [seleView addValue:model];
    [seleView.addCarBTN removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [seleView.addCarBTN addTarget:self action:@selector(addGoodsToCar:)forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    tapGestureRecognizer.numberOfTapsRequired=1;
    [tapGestureRecognizer addTarget:self action:@selector(keboardDismiss)];
    [seleView addGestureRecognizer:tapGestureRecognizer];
    [seleView.BuyNowBTN removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [seleView.BuyNowBTN addTarget:self action:@selector(buyGoodsNow:)forControlEvents:UIControlEventTouchUpInside];
//        UIScrollView *s1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0,seleView._specNameLabel.frame.origin.y+seleView._specNameLabel.frame.size.height-20, seleView.frame.size.width, 270)];
        UIScrollView *s1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0,seleView._specNameLabel.frame.origin.y+seleView._specNameLabel.frame.size.height-20, seleView.frame.size.width, (SCREEN_HEIGHT-seleView._specNameLabel.frame.origin.y+seleView._specNameLabel.frame.size.height-20)-(SCREEN_HEIGHT-seleView.numButton.frame.origin.y+seleView.numButton.frame.size.height))];
        s1.contentSize = CGSizeMake( seleView.frame.size.width,SCREEN_HEIGHT);
        [seleView addSubview:s1];
        
        seleView.numButton.callBack= ^(NSString *curNum){
                NSLog(@"curNum:%@",curNum);
                currentNum = curNum;
        };
        
    [seleView addSubview:numButton];
        //规格
        
        if ([model.goods_info.spec_value isEqual:[NSNull null]]){
            
        }else{
            
            for (int i = 0; i<[[model.goods_info.spec_name allKeys] count]; i++) {
                if (i == 0) {
                    NSString *key1 = [model.goods_info.spec_name allKeys][i];
                    countList  = [[model.goods_info.spec_value valueForKey:key1] allValues].count;
                    //    //颜色value
                    NSMutableArray *controls1 = [[NSMutableArray alloc] init];
                    
                    for (int i=0; i<countList; i++) {
                        radiobox1 = [[RadioBox alloc] initWithFrame:CGRectMake(0, 15+25*i, seleView.frame.size.width/2, 25)];
                        NSString *spec_value = [[model.goods_info.spec_value valueForKey:key1] allValues][i];
                        radiobox1.text = spec_value;
                        radiobox1.tag = RADBOX_TAG1+i;
                        radiobox1.value = [[[model.goods_info.spec_value valueForKey:key1] allKeys][i] integerValue];
                        [controls1 addObject:radiobox1];
                        [radioGroup1 addSubview:radiobox1];
                    }
                    radioGroup1 = [[RadioGroup alloc] initWithFrame:CGRectMake(seleView._specNameLabel.frame.origin.x, 0, seleView.frame.size.width/2, 300) WithControl:controls1];
                    [s1 addSubview:radioGroup1];
                    
                }else if (i == 1){
                    NSMutableArray *controls2 = [[NSMutableArray alloc] init];
                    NSString *key2 = [model.goods_info.spec_name allKeys][1];
                    
                    countSize  = [[model.goods_info.spec_value valueForKey:key2] allValues].count;
                    

                    for (int i = 0; i<countSize; i++) {
                        radiobox2 = [[RadioBox alloc] initWithFrame:CGRectMake(0, 15+25*i, seleView.frame.size.width/2, 25)];
                        NSString *spec_value =  [[model.goods_info.spec_value valueForKey:key2] allValues][i];
                        radiobox2.text = spec_value;
                        radiobox2.tag = RADBOX_TAG2+i;
                        radiobox2.value = [[[model.goods_info.spec_value valueForKey:key2] allKeys][i] integerValue];
                        [controls2 addObject:radiobox2];
                        [radioGroup2 addSubview:radiobox2];
                        
                    }
                    radioGroup2 = [[RadioGroup alloc] initWithFrame:CGRectMake(radioGroup1.frame.origin.x+ radioGroup1.frame.size.width,radioGroup1.frame.origin.y, seleView.frame.size.width/2, 300) WithControl:controls2];
                    [s1 addSubview:radioGroup2];
                }
            }
            
           
            
        }

    [self.view addSubview:seleView];
    [UIView animateWithDuration:0.6 animations:^{
        seleView.frame = CGRectMake(SEPEC_RIGHTVIEW_DISTANCE, 63, SCREEN_WIDTH-SEPEC_RIGHTVIEW_DISTANCE, SCREEN_HEIGHT-63);
    }];
//    }
}

-(void)keboardDismiss
{
    [seleView.numButton._textField resignFirstResponder];
    seleView.numButton.frame = CGRectMake(seleView.frame.size.width/2-60,seleView.frame.size.height-EACH_H-9-40,120,30);
    
}


#pragma mark  *******************添加购物车*******************
- (void)addGoodsToCar:(UIButton *)btn
{
    NSLog(@"添加购物车");
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (!isLogin) {
        [self notSignIn];
        
    }else{
        currentNum=seleView.numButton._textField.text;
//        if([currentNum intValue] >[kucun intValue]){
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起,此商品库存不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//            [self hideRightView];
//        }else {
        
            if (!currentNum) {
                currentNum = @"1";
            }

        NSString *good_sid;
        if ([model.goods_info.spec_name allValues].count == 0){
            good_sid= _goodsID;
            [self addDatasURL:SUGE_CAR_ADD Quantity:currentNum goodsid:good_sid];

        }else{//
            num1 = 0 ;
            num2 = 0 ;
            
            
            for (int i = 0; i<countList; i++) {
                RadioBox *b1 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG1+i];
                if (b1.on) {
                    num1 = b1.value;
                }
                
            }
            for (int i = 0; i<countSize; i++) {
                RadioBox *b2 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG2+i];
                if (b2.on) {
                    num2 = b2.value;
                }
                
            }

                NSString *finaID;
                if (countSize == 0) {
                    if (num1 == 0) {
                        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    }else{
                    finaID = [NSString stringWithFormat:@"%ld",(long)num1];
                    good_sid =[model.spec_list valueForKey:finaID];
                    if (good_sid == nil) {
                        finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num1,(long)num2];
                    }
                        good_sid = [model.spec_list valueForKey:finaID];
                        NSLog(@"finaID:%@,good_sid:%@",finaID,good_sid);
                        [self addDatasURL:SUGE_CAR_ADD Quantity:currentNum goodsid:good_sid];
                    
                    }
                }else{
                    if (num1 == 0|| num2 == 0) {
                                                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    }else{
                    finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num2,(long)num1];
                    good_sid =[model.spec_list valueForKey:finaID];
                    if (good_sid == nil) {
                        finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num1,(long)num2];
                    }
                        good_sid = [model.spec_list valueForKey:finaID];
                        NSLog(@"finaID:%@,good_sid:%@",finaID,good_sid);
                        [self addDatasURL:SUGE_CAR_ADD Quantity:currentNum goodsid:good_sid];
                    }
                
                }
            
               
            }
        }
//    }
}

#pragma mark *******************立即购买*******************
- (void)buyGoodsNow:(UIButton *)btn
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (!isLogin) {
        [self notSignIn];
    }else{
            currentNum=seleView.numButton._textField.text;
//        if([currentNum intValue] >[kucun intValue]){
//            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起,此商品库存不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
//            [self hideRightView];
//        }else {
        
            if (!currentNum) {
                currentNum = @"1";
            }

        if ([model.goods_info.spec_name allValues].count == 0){
            NSString *pri = model.goods_info.goods_price;
            NSInteger num = [currentNum integerValue];
            float price = [pri floatValue];
            float sum = num *price;
            NSString *finPrice = [NSString stringWithFormat:@"%0.2f",sum];
            LBBuyStep1ViewController *buyStep1VC = [[LBBuyStep1ViewController alloc]init];
            NSString *goods_id = [NSString stringWithFormat:@"%@|%@",_goodsID,currentNum];
            buyStep1VC._ifcart = @"";
            buyStep1VC._cart_id = goods_id;
            buyStep1VC._totalMoney = finPrice;
            [self.navigationController pushViewController:buyStep1VC animated:YES];
            [self hideRightView];
        }else{
            num11 = 0 ;
            num22 = 0 ;
            
            for (int i = 0; i<countList; i++) {
                RadioBox *b1 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG1+i];
                if (b1.on) {
                    num11 = b1.value;
                }
                
            }
            for (int i = 0; i<countSize; i++) {
                RadioBox *b2 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG2+i];
                if (b2.on) {
                    num22 = b2.value;
                }
                
            }
            
            NSString *finaID;
            if (countSize == 0){
                if (num11 == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                }else{
                finaID = [NSString stringWithFormat:@"%ld",(long)num11];
                    NSString *goodsid =[model.spec_list valueForKey:finaID];
                    if (goodsid == nil) {
                        finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num11,(long)num22];
                        goodsid = [model.spec_list valueForKey:finaID];
                    }
                    
//                    NSString *pri = model.goods_info.goods_price;
//                    NSInteger num = [currentNum integerValue];
//                    float price = [pri floatValue];
//                    float sum = num *price;
//                    NSString *finPrice = [NSString stringWithFormat:@"%0.2f",sum];
                    LBBuyStep1ViewController *buyStep1VC = [[LBBuyStep1ViewController alloc]init];
                    NSString *goods_id = [NSString stringWithFormat:@"%@|%@",goodsid,currentNum];
                    NSLog(@"finaID:%@,goods_id:%@",finaID,goods_id);
                    buyStep1VC._ifcart = @"";
                    buyStep1VC._cart_id = goods_id;
                    //                    buyStep1VC._totalMoney = finPrice;
                    [self.navigationController pushViewController:buyStep1VC animated:YES];
                    [self hideRightView];
                }
            }else{
                if (num11 == 0 ||num22 == 0) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                }else{
                    finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num22,(long)num11];
                    NSString *goodsid =[model.spec_list valueForKey:finaID];
                    if (goodsid == nil) {
                        finaID = [NSString stringWithFormat:@"%ld|%ld",(long)num11,(long)num22];
                        goodsid = [model.spec_list valueForKey:finaID];
                    }
                    
                    LBBuyStep1ViewController *buyStep1VC = [[LBBuyStep1ViewController alloc]init];
                    NSString *goods_id = [NSString stringWithFormat:@"%@|%@",goodsid,currentNum];
                    NSLog(@"finaID:%@,goods_id:%@",finaID,goods_id);
                    buyStep1VC._ifcart = @"";
                    buyStep1VC._cart_id = goods_id;
//                    buyStep1VC.isBuyNow = YES;
                    //                    buyStep1VC._totalMoney = finPrice;
                    [self.navigationController pushViewController:buyStep1VC animated:YES];
                    [self hideRightView];

                }
            }

        }
    }
}



#pragma mark 


- (void)addDatasURL:(NSString *)url Quantity:(NSString *)quantity goodsid:(NSString *)goods_id
{
    
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameters = nil;
    if (quantity!=nil) {
        parameters = @{@"key":key,@"goods_id":goods_id,@"quantity":quantity};
    }else{
        parameters = @{@"key":key,@"goods_id":_goodsID};
    }
    [maneger POST:url parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
//        [SVProgressHUD dismiss];
        NSLog(@"datas:%@",responObject);

        if (quantity!=nil) {
            if ([responObject[@"datas"] isEqual:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功" maskType:SVProgressHUDMaskTypeClear];
            }else{
                [TSMessage showNotificationWithTitle:@"提示" subtitle:responObject[@"datas"][@"error"] type:TSMessageNotificationTypeWarning];
            }
            [self hideRightView];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"收藏成功" maskType:SVProgressHUDMaskTypeClear];

        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"添加错误:%@",error);
    }];
    
}



#pragma mark --页面统计
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.menu) {
        [self.menu dismissWithAnimation:NO];
    }
    
    for (int i = 0; i<countList; i++) {
        bb1 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG1+i];
        [bb1 removeFromSuperview];
    }
    for (int i = 0; i<countSize; i++){
        bb2 = (RadioBox *)[self.view viewWithTag:RADBOX_TAG2+i];
        [bb2 removeFromSuperview];
    }
    
    [MobClick beginLogPageView:@"商品详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [MobClick endLogPageView:@"商品详情"];
    [self.menu dismissWithAnimation:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [seleView.numButton._textField resignFirstResponder];
}

@end
