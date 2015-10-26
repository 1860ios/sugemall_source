//
//  LBOrderDetailViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/7/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderDetailViewController.h"
#import "LBOrderDetailAddressCell.h"
#import "LBgoodsShowCell.h"
#import "LBwayCell.h"
#import "UtilsMacro.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import "TSMessage.h"
#import "SUGE_API.h"
#import "LBOrderDetailModel.h"
#import "LBOrderDetailGoodsModel.h"
#import "LBGoodsDetailViewController.h"
#import <MJExtension.h>
#import "LBApplyRefundViewController.h"
#import "LBDeliverViewController.h"

static NSString *OrderDetail = @"OrderDetailCell";
static NSString *goodsShow = @"goodsShowCell";
static NSString *way = @"wayCell";

@interface LBOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *detailOrderDatas;
    LBOrderDetailModel *modelOrderDetail;
    LBOrderDetailGoodsModel *modelOrderDetailGoods;
    UILabel *orderMoney;
}
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UILabel *ordernumLabel;
@property (nonatomic, strong) UILabel *tradenumLabel;
@property (nonatomic, strong) UILabel *ordertimeLabel;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *tradeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *orderLabel1;

@end

@implementation LBOrderDetailViewController
@synthesize _tableView;
@synthesize order_id;
@synthesize ordernumLabel;
@synthesize tradenumLabel;
@synthesize ordertimeLabel;
@synthesize allLabel;
@synthesize orderLabel;
@synthesize orderLabel1;
@synthesize tradeLabel;
@synthesize timeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.translucent = YES;
    [self loadDetailTableView];
    [self loadGoodsDetailDatas:order_id];

}
/**
 *  method
 */
#pragma mark  退款
- (void)refundOrder:(UIButton *)btn
{
    modelOrderDetailGoods = modelOrderDetail.extend_order_goods[0];
    LBApplyRefundViewController *applyrefund=[[LBApplyRefundViewController alloc]init];
    NSDictionary *dic1 = @{@"show":modelOrderDetailGoods.goods_name,@"orderid":modelOrderDetail.order_id,@"goodimage":modelOrderDetailGoods.goods_image_url,@"num":[NSString stringWithFormat:@"%@",modelOrderDetailGoods.goods_num],@"amount":modelOrderDetail.order_amount,@"goodsid":modelOrderDetailGoods.goods_id,@"paysn":[NSString stringWithFormat:@"订单编号:%@",modelOrderDetail.pay_sn]};
    applyrefund.refundDic = dic1;
    
    [self.navigationController pushViewController:applyrefund animated:YES];

    
}
#pragma mark  取消订单
- (void)cancelOrder:(UIButton *)btn
{
    NSString *orderID1 = modelOrderDetail.order_id;
    [self requestWithURL:SUGE_ORDER_CANCEL andOrderID:orderID1 type:@"quxiao"];
}
#pragma mark 查看物流
- (void)deleverOrder:(UIButton *)btn
{
    LBDeliverViewController *deliver = [[LBDeliverViewController alloc] init];
    deliver._orderID = modelOrderDetail.order_id;
    [self.navigationController pushViewController:deliver animated:YES];
}
#pragma mark  确认收货
- (void)querenOrder:(UIButton *)btn
{
    NSString *orderID2 = modelOrderDetail.order_id;
    [self requestWithURL:SUGE_ORDER_RECEIVE andOrderID:orderID2 type:@"queren"];
}

- (void)requestWithURL:(NSString *)URL andOrderID:(NSString *)orderid type:(NSString *)type
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter = @{@"key":key,@"order_id":orderid};
    [manager POST:URL parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){

        NSLog(@"order_some:%@",responObject);
        if ([type isEqualToString:@"quxiao"]){
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"取消订单成功~" type:TSMessageNotificationTypeSuccess];
          
        }else if ([type isEqualToString:@"queren"]){
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"确认订单成功~" type:TSMessageNotificationTypeSuccess];
        }
        [self loadGoodsDetailDatas:order_id];
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        
        NSLog(@"error:%@",error);
    }];
    //miss提示
    [SVProgressHUD dismiss];
}


-(void)loadDetailTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView  = ({
        UITableView *tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tableView.delegate  =self;
        tableView.dataSource = self;
        tableView;
    });
    [_tableView registerClass:[LBOrderDetailAddressCell class] forCellReuseIdentifier:OrderDetail];
    [_tableView registerClass:[LBgoodsShowCell class] forCellReuseIdentifier:goodsShow];
    [_tableView registerClass:[LBwayCell class] forCellReuseIdentifier:way];
    
    [self.view addSubview:_tableView];
}
#pragma mark DataSource
- (void)loadGoodsDetailDatas:(NSString *)orderId
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameter = @{@"key":key,@"order_id":orderId};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    [maneger GET:SUGE_DETAIL_ORDER parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"订单详情%@",responseObject);
        modelOrderDetail = [LBOrderDetailModel objectWithKeyValues:responseObject[@"datas"]];
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"Error:%@", error);
    }];
    [SVProgressHUD dismiss];
}
#pragma mark tableView deleage/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:{
            NSInteger count = modelOrderDetail.extend_order_goods.count;
            return count;
        }
            break;
        case 2:
            return 1;
            break;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//商品
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    modelOrderDetailGoods = modelOrderDetail.extend_order_goods[row];
    
    switch (section) {
        case 0:{
            LBOrderDetailAddressCell *messageCell = [tableView dequeueReusableCellWithIdentifier:OrderDetail];
//                messageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [messageCell addValue:modelOrderDetail];
            return messageCell;
        }
            break;
        case 1:{
            LBgoodsShowCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:goodsShow];
           goodsCell.totalMoneyLabel.text=[NSString stringWithFormat:@"￥%@",modelOrderDetail.order_amount];

            [goodsCell.refundButton addTarget:self action:@selector(refundOrder:) forControlEvents:UIControlEventTouchUpInside];
            [goodsCell.searchDeliver addTarget:self action:@selector(deleverOrder:) forControlEvents:UIControlEventTouchUpInside];
            [goodsCell.orderCancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [goodsCell.orderReciver addTarget:self action:@selector(querenOrder:) forControlEvents:UIControlEventTouchUpInside];
            goodsCell.orderLabel.text=[NSString stringWithFormat:@"订单号:%@",modelOrderDetail.order_sn];
            goodsCell.tradeLabel.text=[NSString stringWithFormat:@"交易号:%@",modelOrderDetail.pay_sn];
            goodsCell.orderLabel1.text=[NSString stringWithFormat:@"订单日期:%@",modelOrderDetail.order_add_date];
            [goodsCell addValue:modelOrderDetailGoods goodsModel:modelOrderDetail];
            [self initOrderBottom];
            return goodsCell;
        }
            break;
        case 2:{
         LBwayCell *wayCell = [tableView dequeueReusableCellWithIdentifier:way];
            [wayCell addValue:modelOrderDetail];
            return wayCell;
        }
            break;

    }
    return nil;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 10;
            break;
            
        case 1:
            return 50;
            break;
        case 2:
            return 10;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 130;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView*view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view2.backgroundColor = [UIColor whiteColor];
        ////商店图标
        UIImageView *storeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 30, 30)];
        [storeImageView setImage:IMAGE(@"store_image.png")];
        [view2 addSubview:storeImageView];
        //商店名
        UILabel *storenameLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeImageView.frame.origin.x+storeImageView.frame.size.width,10,200,30)];
        storenameLabel.textColor = [UIColor blackColor];
        storenameLabel.textAlignment = NSTextAlignmentLeft;
        storenameLabel.font=FONT(15);
        storenameLabel.text=modelOrderDetail.store_name;
        [view2 addSubview:storenameLabel];
        //状态
//        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 3, 80, 20)];
//        stateLabel.textColor = APP_COLOR;
//        stateLabel.textAlignment = NSTextAlignmentRight;
//        stateLabel.text=modelOrderDetail.state_desc;
//        [view2 addSubview:stateLabel];
        
        UILabel *zixunLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-35, 10, 30,30)];
        zixunLabel.text=@"咨询";
        zixunLabel.font=FONT(13);
        zixunLabel.textColor=[UIColor grayColor];
        [view2 addSubview:zixunLabel];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(zixunLabel.frame.origin.x-20, zixunLabel.frame.origin.y+5, 20, 20);
        [button setImage:IMAGE(@"确认订单无地址_07") forState:0];
        [view2 addSubview:button];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, storenameLabel.frame.origin.y+storenameLabel.frame.size.height+10, SCREEN_WIDTH-20, 1)];
        lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
        [view2 addSubview:lineView];
        
    return view2;
    }
    return 0;
}

//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view1;
//    if (section==2) {
//    view1 =[[UIView alloc]initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, 100)];
//    view1.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:view1];
//    
//    ordernumLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 80, 30)];
//    ordernumLabel.font = [UIFont systemFontOfSize:15];
//    ordernumLabel.textColor = [UIColor blackColor];
//    ordernumLabel.textAlignment = NSTextAlignmentLeft;
//    ordernumLabel.text=@"订单号";
//    [view1 addSubview:ordernumLabel];
//    
//    orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(ordernumLabel.frame.origin.x+ordernumLabel.frame.size.width,ordernumLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
//    orderLabel.font = [UIFont systemFontOfSize:15];
//    orderLabel.textColor = [UIColor blackColor];
//    orderLabel.textAlignment = NSTextAlignmentLeft;
//    orderLabel.text=modelOrderDetail.order_sn;
//    [view1 addSubview:orderLabel];
//        
//    tradenumLabel=[[UILabel alloc]initWithFrame:CGRectMake(ordernumLabel.frame.origin.x,ordernumLabel.frame.origin.y+ordernumLabel.frame.size.height, 80, 30)];
//    tradenumLabel.font = [UIFont systemFontOfSize:15];
//    tradenumLabel.textColor = [UIColor blackColor];
//    tradenumLabel.textAlignment = NSTextAlignmentLeft;
//    tradenumLabel.text=@"交易号";
//    [view1 addSubview:tradenumLabel];
//        
//    tradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(tradenumLabel.frame.origin.x+tradenumLabel.frame.size.width,tradenumLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
//    tradeLabel.font = [UIFont systemFontOfSize:15];
//    tradeLabel.textColor = [UIColor blackColor];
//    tradeLabel.textAlignment = NSTextAlignmentLeft;
//    tradeLabel.text=modelOrderDetail.pay_sn;
//    [view1 addSubview:tradeLabel];
//
//    ordertimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(tradenumLabel.frame.origin.x,tradenumLabel.frame.origin.y+tradenumLabel.frame.size.height, 80, 30)];
//    ordertimeLabel.font = [UIFont systemFontOfSize:15];
//    ordertimeLabel.textColor = [UIColor blackColor];
//    ordertimeLabel.textAlignment = NSTextAlignmentLeft;
//    ordertimeLabel.text=@"订单日期";
//    [view1 addSubview:ordertimeLabel];
//        
//    orderLabel1=[[UILabel alloc]initWithFrame:CGRectMake(ordertimeLabel.frame.origin.x+ordertimeLabel.frame.size.width,ordertimeLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
//    orderLabel1.font = [UIFont systemFontOfSize:15];
//    orderLabel1.textColor = [UIColor blackColor];
//    orderLabel1.textAlignment = NSTextAlignmentLeft;
//    orderLabel1.text=modelOrderDetail.order_add_date;
//    [view1 addSubview:orderLabel1];
//    
//
//    allLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-200,orderLabel.frame.origin.y+orderLabel.frame.size.height,200, 35)];
//    allLabel.font = BFONT(20);
//    allLabel.textColor = APP_COLOR;
//    allLabel.textAlignment = NSTextAlignmentRight;
//    allLabel.text=[NSString stringWithFormat:@"总计:%@",modelOrderDetail.order_amount];
//    [view1 addSubview:allLabel];
//
//    }
//    return view1;
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 240;
    }else if (indexPath.section==0)
    {
        return 80;
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NSYearCalendarUnit];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    modelOrderDetailGoods = modelOrderDetail.extend_order_goods[row];
    if (section == 1) {
        LBGoodsDetailViewController *detailVC = [[LBGoodsDetailViewController alloc] init];
        detailVC._goodsID = modelOrderDetailGoods.goods_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(void)initOrderBottom
{
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, 49)];
    orderView.backgroundColor = [UIColor blackColor];
    orderView.alpha = 0.7;
    orderView.hidden=YES;
    [self.view addSubview:orderView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
    totalLabel.text  = @"合计:";
    totalLabel.font = FONT(15);
    totalLabel.textColor = [UIColor whiteColor];
    [orderView addSubview:totalLabel];
 
    orderMoney = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 100, 30)];
    orderMoney.textColor = APP_COLOR;
    orderMoney.font = BFONT(21);
    orderMoney.text=[NSString stringWithFormat:@"￥%@",modelOrderDetail.order_amount];
    [orderView addSubview:orderMoney];

    //提交订单
    UIButton *commitButton=[UIButton buttonWithType:0];
    commitButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30,0, SCREEN_WIDTH/3 + 30, 49)];
    [commitButton setTitle:@"确认收货" forState:0];
    [commitButton setTitleColor:[UIColor whiteColor] forState:0];
    [commitButton setBackgroundColor:APP_COLOR];
    [commitButton addTarget:self action:@selector(querenOrder:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:commitButton];

    
    
    if ([modelOrderDetail.state_desc isEqualToString:@"待收货"]){
        orderView.hidden=NO;
        commitButton.hidden=NO;
    }
}
@end
