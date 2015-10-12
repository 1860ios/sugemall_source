//
//  LBClassifyViewContrtoller.m
//  SuGeMarket
//
//  分类
//  Created by 1860 on 15/4/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBClassifyViewContrtoller.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "LBUserInfo.h"
#import "SUGE_API.h"
#import "TSMessage.h"
#import "UtilsMacro.h"
#import "LBClassModel.h"
#import "LBClassListModel.h"
#import "MJExtension.h"
#import "LBTwoClassModel.h"
#import "LBTwoClassListModel.h"
#import "LBSearchViewController.h"
#import "LBGoodsListViewController.h"
#import "LBAdvViewController.h"

static NSString *cid = @"cid";
static NSString *collectionView_cid = @"collectionViewcid";


@interface LBClassifyViewContrtoller()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    LBClassModel *model;
    LBClassListModel *modelList;
    LBTwoClassModel *model_two;
    LBTwoClassListModel *modelList_two;
    UIImageView *class_advImageView;
    NSString *advURL;
}

@property (nonatomic, strong) UITableView *_liftTableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LBClassifyViewContrtoller

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self loadclassAdvImageView];
    [self loadClassifyView];
    [self loadCollectionView];
    
     [self loadClassifyDatas:nil];
     [self loadClassifyDatas:@"1250"];
}

- (void)tapMethod
{
    LBAdvViewController *adv = [[LBAdvViewController alloc] init];
    adv.advURL = advURL;
    [self.navigationController pushViewController:adv animated:YES];

}


#pragma mark --加载数据
- (void)loadClassifyDatas:(NSString *)gcID
{
    [SVProgressHUD showWithStatus:@"正在加载数..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameters = nil;
    if (gcID!=nil) {
        parameters = @{@"gc_id":gcID};
    }
    [maneger GET:SUGE_ONELEVEL_CLASS parameters:parameters success:^(AFHTTPRequestOperation *op,id responObject){
        [SVProgressHUD dismiss];
        if (gcID!=nil){
             NSLog(@"二级responObject:%@",responObject);
            model_two = [LBTwoClassModel objectWithKeyValues:responObject[@"datas"]];
            [_collectionView reloadData];
        }else{
             NSLog(@"一级responObject:%@",responObject);
            model = [LBClassModel objectWithKeyValues:responObject[@"datas"]];
            NSString *class_adv = responObject[@"datas"][@"class_adv"][0][@"adv_pic"];
            advURL = responObject[@"datas"][@"class_adv"][0][@"adv_pic_url"];
            [class_advImageView sd_setImageWithURL:[NSURL URLWithString:class_adv]];
            [__liftTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        NSLog(@"分类错误:%@",error);
    }];
    
}


#pragma mark 加载分类视图
- (void)loadClassifyView
{
    
//    __liftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH/3, SCREEN_HEIGHT-110) style:UITableViewStylePlain];
    __liftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT) style:UITableViewStylePlain];
    __liftTableView.delegate =self;
    __liftTableView.dataSource =self;
    __liftTableView.tableFooterView = [UIView new];
    __liftTableView.showsVerticalScrollIndicator = NO;
    __liftTableView.showsHorizontalScrollIndicator = NO;
//    __liftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [__liftTableView setSeparatorColor:APP_COLOR];
    [self.view addSubview:__liftTableView];
}

#pragma mark 加载二级视图
- (void)loadCollectionView
{
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(__liftTableView.frame.size.width, 50,SCREEN_WIDTH-__liftTableView.frame.size.width,SCREEN_HEIGHT)collectionViewLayout:flowLayout];
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled  =YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return model.class_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger row = indexPath.row;
    modelList = model.class_list[row];
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(__liftTableView.center.x-30, 15, 60, 30)];
    l1.adjustsFontSizeToFitWidth = YES;
    l1.textAlignment = NSTextAlignmentCenter;
    l1.text = modelList.gc_name;
//    l1.highlightedTextColor = [UIColor whiteColor];
//    l1.highlightedTextColor  = APP_COLOR;
    [cell.contentView addSubview:l1];
//    cell.detailTextLabel.text = modelList.text;
    
    cell.backgroundColor = RGBCOLOR(245,245,245);
    UIView *selectBG = [[UIView alloc] initWithFrame:CGRectZero];
    selectBG.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selectBG;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelList = model.class_list[row];
    [self loadClassifyDatas:modelList.gc_id];
    if (row>4) {
        //跳到指的row
          [self._liftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    if (row<=5) {
        //跳到指的row
        [self._liftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    
}

-(void)viewDidLayoutSubviews
{
    if ([__liftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [__liftTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([__liftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [__liftTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

#pragma mark collectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return model_two.class_list.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier : collectionView_cid forIndexPath :indexPath];
    //
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
        NSInteger row = indexPath.row;
        modelList_two = model_two.class_list[row];
        NSLog(@"modelList_two.gc_name:%@",modelList_two.gc_name);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, (SCREEN_WIDTH*2/3-20)/2-10 , (SCREEN_WIDTH*2/3-20)/2-30)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *image_url = [NSString stringWithFormat:@"http://sugemall.com/data/upload/shop/common/category-pic-%@.jpg",modelList_two.gc_id];
        [imageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
        [cell.contentView addSubview:imageView];
        
        UILabel *name =  [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,imageView.frame.origin.y+imageView.frame.size.height,imageView.frame.size.width,20)];
//        name.adjustsFontSizeToFitWidth = YES;
        name.font = FONT(16);
        name.textAlignment = NSTextAlignmentCenter;
        name.text = modelList_two.gc_name;
        name.highlightedTextColor  = APP_COLOR;
        [cell.contentView addSubview:name];
    //
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    modelList_two = model_two.class_list[row];
    NSString *goodID = modelList_two.gc_id;
    LBGoodsListViewController *goodsList = [[LBGoodsListViewController alloc] init];
    goodsList.isSearch = YES;
    goodsList._goodsID = goodID;
    goodsList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsList animated:YES];
    
}

//定义每个UICollectionView 的边距

-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    
    return UIEdgeInsetsMake ( 10 , 10 , 10 , 10 );
    
}
//定义每个UICollectionView 的大小

- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    
    return CGSizeMake ((SCREEN_WIDTH*2/3-20)/2-10,(SCREEN_WIDTH*2/3-20)/2);
    
}
//返回这个UICollectionViewCell是否可以被选择

-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    return YES ;
}

#pragma MARK --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"分类"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类"];

}

@end
