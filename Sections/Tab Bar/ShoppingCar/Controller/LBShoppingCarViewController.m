//
//  LBShoppingCarViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBShoppingCarViewController.h"
#import "MobClick.h"
#import "AFNetworking.h"
#import "LBUserInfo.h"
#import "TSMessage.h"
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "UtilsMacro.h"
#import "LBCarModel.h"
#import "LBCarListModel.h"
#import "MJExtension.h"
#import "LBCarListCell.h"
#import "NotificationMacro.h"
#import "AppMacro.h"
#import <MJRefresh.h>
#import "LBGoodsDetailViewController.h"
#import "LBBuyStep1ViewController.h"
#import "HJCAjustNumButton.h"
#import <FXBlurView.h>

static NSString *cid = @"cid";
//

@interface LBShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LBCarListModel *modelList;
    
    LBCarModel *model;
    NSArray *ListArray;
    UIView *bottomView;
    
    UIButton *_allSelectBtn;
    UIButton *_oneSelectBtn;
    
    NSMutableArray *allPriceArray;

    float allPrice;
    
}
@property (nonatomic, strong) UITableView *_tableView;
//@property(strong,nonatomic)UIButton *allSelectBtn;
@property(strong,nonatomic)UILabel *allPriceLab;
@end

@implementation LBShoppingCarViewController
@synthesize isPushIn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    allPriceArray = [[NSMutableArray alloc] init];
    [self drawTableView];
    [self loadBottom];
    [self setupRefresh];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(removeCarDatas) name:SUGE_NOT_LOGNOUT object:nil];
    
}

#pragma mark 通知方法

- (void)removeCarDatas
{
    for (UITableViewCell *cell in __tableView.visibleCells) {
        [cell removeFromSuperview];
    }
}


#pragma mark 设置下拉刷新
- (void)setupRefresh
{

    [self._tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadDatasShop)];
    
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.header setTitle:APP_REFRESH_TEXT_STATID forState:MJRefreshHeaderStateIdle];
    [self._tableView.header setTitle:APP_REFRESH_TEXT_PULLING forState:MJRefreshHeaderStatePulling];
    [self._tableView.header setTitle:APP_REFRESH_TEXT_REFRESHING forState:MJRefreshHeaderStateRefreshing];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;

}

#pragma mark --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDatasShop];
    [MobClick beginLogPageView:@"购物车"];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"购物车"];
    allPrice = 0;
    _allSelectBtn.selected  = NO;
    _allPriceLab.text = @"";
    [allPriceArray removeAllObjects];
    
    
}
#pragma mark 加载数据
- (void)loadDatasShop
{
    if ([LBUserInfo sharedUserSingleton].isLogin) {
        //key
        NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
        //HUD 提示
        [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameter = @{@"key":key};
        
        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_CAR_LIST parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            //dismiss
            [SVProgressHUD dismiss];
            NSLog(@"购物车responObject:%@",responObject);
            
            ListArray = [[NSArray alloc] init];
            ListArray = responObject[@"datas"][@"cart_list"];
            
            if (ListArray.count == 0) {
                self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"none_carlist")];
//                _allPriceLab.text = @"0.00";
                bottomView.hidden = YES;
               __tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
               
                bottomView.hidden = NO;
                    __tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height);
                self._tableView.backgroundView = [UIView new];
                model = [LBCarModel objectWithKeyValues:responObject[@"datas"]];
            }

            //刷新tableview
            [__tableView reloadData];
            
            NSInteger carCount = ListArray.count;
            
            //发布通知
            [NOTIFICATION_CENTER postNotificationName:SUGE_NOT_CARLIST_COUNT_NAME object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:carCount] forKey:SUGE_NOT_CARLIST_KEY]];
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self._tableView.header endRefreshing];
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            NSLog(@"Error: 注册失败:%@", error);
        }];

    }else{
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self._tableView.header endRefreshing];
        bottomView.hidden = YES;
        __tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

        self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"none_carlist")];

    }
    

}
#pragma mark drawBottomView
- (void)loadBottom
{
    bottomView = [[UIView alloc]init];
    if (isPushIn) {
        bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height, SCREEN_WIDTH, EACH_H);
    }else{
        bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-self.tabBarController.tabBar.frame.size.height*2, SCREEN_WIDTH, EACH_H);
    }
        bottomView.backgroundColor = [UIColor whiteColor];
        //添加全选图片按钮
        _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allSelectBtn.frame = CGRectMake(10, 10, 25, 25);
        [_allSelectBtn setImage:IMAGE(@"syncart_round_check1@2x") forState:UIControlStateNormal];
        [_allSelectBtn setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
        [_allSelectBtn addTarget:self action:@selector(allSelectBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_allSelectBtn];
        //添加一个全选文本框标签
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(_allSelectBtn.frame.origin.x+_allSelectBtn.frame.size.width, _allSelectBtn.frame.origin.y, 50, 25)];
        lab.text = @"全选";
        [bottomView addSubview:lab];
    
    //添加小结文本框
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-140,5, 40, 30)];
    lab2.textColor = [UIColor blackColor];
    lab2.font = [UIFont boldSystemFontOfSize:15];
    lab2.text = @"总计:";
    [bottomView addSubview:lab2];
    
    //添加一个总价格文本框，用于显示总价
    _allPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(lab2.frame.origin.x+lab2.frame.size.width, lab2.frame.origin.y,100, 30)];
    _allPriceLab.textColor = APP_COLOR;
    _allPriceLab.adjustsFontSizeToFitWidth = YES;
    _allPriceLab.font = [UIFont boldSystemFontOfSize:20];
//    _allPriceLab.text = @"￥0.00";
    [bottomView addSubview:_allPriceLab];
    
    
    //添加一个结算按钮
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settlementBtn setTitle:@"去结账" forState:UIControlStateNormal];
    [settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settlementBtn.frame = CGRectMake(SCREEN_WIDTH*3/4,0, SCREEN_WIDTH/4,EACH_H);
    settlementBtn.backgroundColor = APP_COLOR;
    [settlementBtn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:settlementBtn];
    
    [self.view addSubview:bottomView];
}

- (void)drawTableView
{
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    __tableView.delegate = self;
    __tableView.dataSource =self;
    __tableView.tableFooterView = [UIView new];
    [__tableView registerClass:[LBCarListCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:__tableView];
    
}

#pragma mark --table view deleage / datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBCarListCell *cell = nil;
    if (!cell) {
        cell = [[LBCarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    NSInteger row = indexPath.row;
    modelList = model.cart_list[row];
    _oneSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneSelectBtn.frame = CGRectMake(5, 5, 30, 30);
    _oneSelectBtn.tag = 999+row;
    [_oneSelectBtn setImage:IMAGE(@"syncart_round_check1@2x") forState:UIControlStateNormal];
    [_oneSelectBtn setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
    [_oneSelectBtn addTarget:self action:@selector(oneSelectBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
//    _oneSelectBtn.selected = NO;
    [cell addSubview:_oneSelectBtn];
    
    [cell._deleteBtn addTarget:self action:@selector(edictNum1:) forControlEvents:UIControlEventTouchUpInside];
    cell._addBtn.tag = row;
    [cell._addBtn addTarget:self action:@selector(edictNum2:) forControlEvents:UIControlEventTouchUpInside];
    cell._deleteBtn.tag = row;
    [cell addTheValue:modelList];
    
    return cell;
}

#pragma mark 单选多选----Method
/**
 *

 *
 */
//#warning 购物车单选多选
//单选
- (void)oneSelectBtnMethod:(UIButton *)btn
{
    UITableViewCell* buttonCell = (UITableViewCell*)[btn superview];
    NSUInteger row = [[self._tableView indexPathForCell:buttonCell] row];
    NSString *row1 = [NSString stringWithFormat:@"%ld",(unsigned long)row];
    modelList = model.cart_list[row];
    
    NSString *pric = modelList.goods_sum;

    float price = [pric floatValue];
//    NSLog(@"price:%0.2f",price);
    if (btn.selected) {
        [allPriceArray removeObject:row1];
        allPrice = allPrice-price;
        NSLog(@"price:%0.2f",allPrice);
        NSLog(@"按钮未被选中///");
//        UIButton *kButoon = (UIButton *)[self.view viewWithTag:btn.tag];
//        [kButoon setImage:IMAGE(@"syncart_round_check1@2x") forState:UIControlStateNormal];
        btn.selected = NO;
    }else{
        [allPriceArray addObject:row1];
        allPrice = allPrice+price;
        NSLog(@"price:%0.2f",allPrice);
        NSLog(@"按钮选中///");
//        UIButton *kButoon = (UIButton *)[self.view viewWithTag:btn.tag];
//         [kButoon setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateNormal];
        btn.selected = YES;
    }
    _allPriceLab.text =[NSString stringWithFormat:@"%0.2f",allPrice];
}

//全选
- (void)allSelectBtnMethod:(UIButton *)btn
{

    if (btn.selected) {
        UIButton *kButoon;
        for (int i = 0; i<ListArray.count; i++) {
            kButoon = (UIButton *)[self.view viewWithTag:999+i];
            kButoon.selected = NO;
//            [kButoon setImage:IMAGE(@"syncart_round_check1@2x") forState:UIControlStateNormal];
            [allPriceArray removeObject:[NSString stringWithFormat:@"%d",i]];
             }
        allPrice = 0;
        NSLog(@"全选按钮wei选中///");
        btn.selected = NO;
    }else{
        UIButton *kButoon;
        for (int i = 0; i<ListArray.count; i++) {
            kButoon = (UIButton *)[self.view viewWithTag:999+i];
            kButoon.selected = YES;
//            [kButoon setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
            [allPriceArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        NSString *allP = model.sum;
        allPrice = [allP floatValue];
        NSLog(@"全选按钮选中///");
        
        btn.selected = YES;
    }
       _allPriceLab.text =[NSString stringWithFormat:@"%0.2f",allPrice];
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [__tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    modelList = model.cart_list[row];
    //商品编号
    NSString *goodID = modelList.goods_id;
    LBGoodsDetailViewController *goodsVC = [LBGoodsDetailViewController new];
    goodsVC._goodsID = goodID;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    modelList = model.cart_list[row];

    NSString *carId = modelList.cart_id;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        [self editCar:carId quantity:nil URL:SUGE_CAR_DEL];
    }
    
}


- (void)edictNum1:(UIButton *)btn
{
    _allSelectBtn.selected = NO;
    _allPriceLab.text = @"";
    NSInteger row = btn.tag;
    modelList = model.cart_list[row];
    NSInteger num = modelList.goods_num;
    //做减法
    if (num > 1)
    {
        num --;
        
        NSString *carId = modelList.cart_id;
        NSString *quantity = [NSString stringWithFormat:@"%ld",(long)num];
        //计算总价
        [self editCar:carId quantity:quantity URL:SUGE_CAR_EDIT_QUANTITY];

    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"商品不能在减了~" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}

- (void)edictNum2:(UIButton *)btn
{
    _allSelectBtn.selected = NO;
    _allPriceLab.text = @"";
    NSInteger row = btn.tag;
    modelList = model.cart_list[row];
    NSInteger num = modelList.goods_num;
    num++;
    //
    NSString *carId = modelList.cart_id;
    NSString *quantity = [NSString stringWithFormat:@"%ld",(long)num];
    //计算总价
    [self editCar:carId quantity:quantity URL:SUGE_CAR_EDIT_QUANTITY];

}

- (void)editCar:(NSString *)cartID quantity:(NSString*)quantity URL:(NSString *)url
{
    
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter = [[NSDictionary alloc] init];
    if (quantity == nil) {
        parameter =  @{@"key":key,@"cart_id":cartID};
    }else{
        parameter =  @{@"key":key,@"cart_id":cartID,@"quantity":quantity};
    }
    
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //dismiss
        [SVProgressHUD dismiss];
        NSLog(@"responObject:%@",responObject);
        [self loadDatasShop];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
    }];
    
    
}

#pragma mark 去计算

- (void)toPay
{
    if ([LBUserInfo sharedUserSingleton].isLogin) {
        if (model.cart_list.count != 0) {
            
           
            if (allPrice==0) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前还未选择商品!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }else{
                LBBuyStep1ViewController *buyStep1VC = [[LBBuyStep1ViewController alloc]init];
                NSString *carID = [[NSString alloc]init];
                NSString *carID1 = [[NSString alloc]init];
                for (int i = 0; i<allPriceArray.count; i++) {
                    NSInteger row2 = [allPriceArray[i] integerValue];
                    modelList = model.cart_list[row2];
                    carID = [[NSString stringWithFormat:@"%@|%ld",modelList.cart_id,(long)modelList.goods_num] stringByAppendingString:@","];
                    carID = [carID1 stringByAppendingString:carID];
                    carID1 = carID;
                }
            carID1 = [carID1 substringToIndex:carID1.length - 1];
            NSString *cartID2 = [NSString stringWithFormat:@"%@",carID1];
            buyStep1VC._cart_id = cartID2;
            buyStep1VC._ifcart = @"1";
//            buyStep1VC._totalMoney = [NSString stringWithFormat:@"%0.2f",allPrice];
            NSLog(@"cartID2:%@",cartID2);
                buyStep1VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:buyStep1VC animated:YES];
            }
        }
        
    }else{
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"您未登录,请先登录" type:TSMessageNotificationTypeWarning];
    }

}



@end