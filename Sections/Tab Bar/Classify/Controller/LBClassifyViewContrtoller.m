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
#import "LBBaseMethod.h"
#import "LBHomeViewCell.h"

#import "AppMacro.h"
static NSString *collectionReusableView_cid = @"collectionReusableView_cid";
static NSString *collectionView_cid = @"collectionViewcid";
static NSString *collectionView_cid1 = @"collectionViewcid1";

@interface LBClassifyViewContrtoller()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *classifyDatasArray;
    NSMutableArray *classifyDatasArray1;
}

@property (nonatomic, strong) UICollectionView *_collectionView;


@end

@implementation LBClassifyViewContrtoller
@synthesize _collectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
     [self loadClassifyDatas:self.gc_id];
    });
    dispatch_async(queue, ^{
        [self loadClassifyDatas1:self.gc_id];
    });
    
    [self loadCollectionView];
}

- (void)loadCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT-110)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
    [_collectionView registerClass:[LBHomeViewCell class]forCellWithReuseIdentifier:collectionView_cid1];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionReusableView_cid];
    [self.view addSubview:_collectionView];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        CGSize size={SCREEN_WIDTH, 0};
        return size;
    }else{
        CGSize size={SCREEN_WIDTH, 40};
        return size;

    }
}
#pragma mark collection headerview
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }else{
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionReusableView_cid forIndexPath:indexPath ];
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        UILabel *text1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        text1.text = @"热门商品";
        text1.font = FONT(18);
        [reusableview addSubview:text1];
    }
    return reusableview;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
            return classifyDatasArray.count;
    }else{
            return classifyDatasArray1.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    if (section == 0) {
         UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
            while ([cell.contentView.subviews lastObject]) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        goodsImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH/4-30, SCREEN_WIDTH/4-20);
        goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        [goodsImageView sd_setImageWithURL:[NSURL URLWithString:classifyDatasArray[row][@"goods_image_url"] ] placeholderImage:IMAGE(@"dd_03_@2x")];
        [cell.contentView addSubview:goodsImageView];
        
        UILabel *nameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.frame.origin.x,goodsImageView.frame.origin.y+goodsImageView.frame.size.height,goodsImageView.frame.size.width,20)];
        nameLabel.adjustsFontSizeToFitWidth =YES;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.text=classifyDatasArray[row][@"gc_name"];
        nameLabel.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:nameLabel];
        return cell;
    }else {
        LBHomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid1 forIndexPath:indexPath ];
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 0.5f;
        [cell addValueForCell1:classifyDatasArray1[row]];
        return cell;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH/4-10,SCREEN_WIDTH/4+20);
    }else{
        return CGSizeMake(SCREEN_WIDTH/2-10,SCREEN_WIDTH/2+40);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *gc_id;
    NSString *isList;
    if (indexPath.section == 0) {
        gc_id = classifyDatasArray[row][@"gc_id"];
        isList = @"YES";
    }else{
        gc_id = classifyDatasArray1[row][@"goods_id"];
        isList = @"NO";
    }
    NSDictionary *dic = @{@"gc_id":gc_id,@"isList":isList};
    [NOTIFICATION_CENTER postNotificationName:@"POSTCLASSIFY" object:nil userInfo:dic];
    }
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 2, 0, 2 );
//}
#pragma mark --加载分类数据
- (void)loadClassifyDatas:(NSString *)gcID
{

    NSDictionary *parameters = @{@"gc_id":gcID};
    [LBBaseMethod get:SUGE_1_FENLEI parms:parameters success:^(id json){
        NSLog(@"二级分类:%@",json);
        classifyDatasArray = [NSMutableArray array];
        classifyDatasArray = json[@"datas"][@"class_list"];
        [_collectionView reloadData];
    }failture:^(id error){
        
     }];
}

//加载喜爱商品
- (void)loadClassifyDatas1:(NSString *)gcID
{
    NSDictionary *parameters = @{@"gc_id":gcID};
    [LBBaseMethod get:SUGE_STORE_LIST parms:parameters success:^(id json){
        NSLog(@"二级分类下喜爱商品:%@",json);
        classifyDatasArray1 = [NSMutableArray array];
        classifyDatasArray1 = json[@"datas"][@"goods_list"];
        [_collectionView reloadData];
    }failture:^(id error){
        
    }];
}

#pragma MARK --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"二级分类"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"二级分类"];

}

@end
