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
    
}
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UILabel *ordernumLabel;
@property (nonatomic, strong) UILabel *tradenumLabel;
@property (nonatomic, strong) UILabel *ordertimeLabel;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *tradeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation LBOrderDetailViewController
@synthesize _tableView;
@synthesize order_id;
@synthesize ordernumLabel;
@synthesize tradenumLabel;
@synthesize ordertimeLabel;
@synthesize allLabel;
@synthesize orderLabel;
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

- (void)loadBottomView
{

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    /*
     _orderPay = [UIButton buttonWithType:UIButtonTypeCustom];
     [__orderPay setTitle:@"去支付" forState:0];
     [__orderPay setTitleColor:[UIColor redColor] forState:0];
     __orderPay.layer.borderColor = [APP_COLOR CGColor];
     __orderPay.layer.borderWidth = 1;
     __orderPay.layer.masksToBounds = YES;
     __orderPay.layer.cornerRadius = 4;
     __orderPay.tag = ORDER_BTN_TAG;
     __orderPay.hidden = YES;
     [self addSubview:__orderPay];
     __orderCancel = [UIButton buttonWithType:UIButtonTypeCustom];
     [__orderCancel setTitle:@"取消订单" forState:0];
     [__orderCancel setTitleColor:[UIColor darkGrayColor] forState:0];
     __orderCancel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
     __orderCancel.layer.borderWidth = 1;
     __orderCancel.layer.masksToBounds = YES;
     __orderCancel.layer.cornerRadius = 4;
     __orderCancel.hidden = YES;
     __orderCancel.tag = ORDER_BTN_TAG+1;
     [self addSubview:__orderCancel];
     
*/
    //退货
    UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(20, 0, 64, 49);
    [refundButton setTitle:@"退款退货" forState:0];
    [refundButton setImage:IMAGE(@"order_refund") forState:0];
    [bottomView addSubview:refundButton];
    [refundButton addTarget:self action:@selector(refundOrder:) forControlEvents:UIControlEventTouchUpInside];
    refundButton.hidden = YES;
    //查看物流
    UIButton *_searchDeliver = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchDeliver.frame = CGRectMake(refundButton.frame.origin.x+refundButton.frame.size.width+40,0 , 64, 49);
    _searchDeliver.layer.masksToBounds = YES;
    [_searchDeliver addTarget:self action:@selector(deleverOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_searchDeliver setImage:IMAGE(@"order_deliver") forState:0];
    [bottomView addSubview:_searchDeliver];
    _searchDeliver.hidden = YES;
    //取消订单
    UIButton *_orderCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderCancel setTitle:@"取消订单" forState:0];
    _orderCancel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    [_orderCancel setTitleColor:[UIColor darkGrayColor] forState:0];
    _orderCancel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _orderCancel.layer.borderWidth = 1;
    _orderCancel.layer.masksToBounds = YES;
    _orderCancel.layer.cornerRadius = 4;
    [_orderCancel addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_orderCancel];
    _orderCancel.hidden = YES;
    //确认收货
    UIButton *_orderReciver = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderReciver.frame = CGRectMake(_searchDeliver.frame.origin.x+_searchDeliver.frame.size.width, 0, SCREEN_WIDTH-(_searchDeliver.frame.origin.x+_searchDeliver.frame.size.width), 49);
    [_orderReciver setTitle:@"确认收货" forState:0];
    [_orderReciver setTitleColor:APP_COLOR forState:0];
    [_orderReciver addTarget:self action:@selector(querenOrder:) forControlEvents:UIControlEventTouchUpInside];
//    __orderReciver.layer.masksToBounds = YES;
    // __orderReciver.tag = ORDER_BTN_TAG+3;
    [bottomView addSubview:_orderReciver];
    _orderReciver.hidden = YES;

    if ([modelOrderDetail.state_desc isEqualToString:@"待付款"]) {
        _orderCancel.hidden = NO;
    }else if ([modelOrderDetail.state_desc isEqualToString:@"已支付"]){
        refundButton.hidden = NO;
        refundButton.frame = CGRectMake(bottomView.center.x-32, 0, 64, 49);
    }else if ([modelOrderDetail.state_desc isEqualToString:@"待收货"]){
        refundButton.hidden = NO;
        _searchDeliver.hidden = NO;
        _orderReciver.hidden = NO;
    }else if ([modelOrderDetail.state_desc isEqualToString:@"交易完成"]){
        refundButton.hidden = NO;
    }
    
    
    [self.view addSubview:bottomView];

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
        [self loadBottomView];
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
                goodsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [goodsCell addValue:modelOrderDetailGoods];
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
            return 30;
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
        
        UIView*view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        view2.backgroundColor = [UIColor whiteColor];
        ////商店图标
        UIImageView *storeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,5, 15, 15)];
        [storeImageView setImage:IMAGE(@"store_image.png")];
        [view2 addSubview:storeImageView];
        //商店名
        UILabel *storenameLabel=[[UILabel alloc]initWithFrame:CGRectMake(storeImageView.frame.origin.x+storeImageView.frame.size.width,3,200,20)];
        storenameLabel.textColor = [UIColor blackColor];
        storenameLabel.textAlignment = NSTextAlignmentLeft;
        storenameLabel.text=modelOrderDetail.store_name;
        [view2 addSubview:storenameLabel];
        //状态
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 3, 80, 20)];
        stateLabel.textColor = APP_COLOR;
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.text=modelOrderDetail.state_desc;
        [view2 addSubview:stateLabel];
        
    return view2;
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view1;
    if (section==2) {
    view1 =[[UIView alloc]initWithFrame:CGRectMake(0,10, SCREEN_WIDTH, 100)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    ordernumLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 80, 30)];
    ordernumLabel.font = [UIFont systemFontOfSize:15];
    ordernumLabel.textColor = [UIColor blackColor];
    ordernumLabel.textAlignment = NSTextAlignmentLeft;
    ordernumLabel.text=@"订单号";
    [view1 addSubview:ordernumLabel];
    
    orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(ordernumLabel.frame.origin.x+ordernumLabel.frame.size.width,ordernumLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
    orderLabel.font = [UIFont systemFontOfSize:15];
    orderLabel.textColor = [UIColor blackColor];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.text=modelOrderDetail.order_sn;
    [view1 addSubview:orderLabel];
        
    tradenumLabel=[[UILabel alloc]initWithFrame:CGRectMake(ordernumLabel.frame.origin.x,ordernumLabel.frame.origin.y+ordernumLabel.frame.size.height, 80, 30)];
    tradenumLabel.font = [UIFont systemFontOfSize:15];
    tradenumLabel.textColor = [UIColor blackColor];
    tradenumLabel.textAlignment = NSTextAlignmentLeft;
    tradenumLabel.text=@"交易号";
    [view1 addSubview:tradenumLabel];
        
    tradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(tradenumLabel.frame.origin.x+tradenumLabel.frame.size.width,tradenumLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
    tradeLabel.font = [UIFont systemFontOfSize:15];
    tradeLabel.textColor = [UIColor blackColor];
    tradeLabel.textAlignment = NSTextAlignmentLeft;
    tradeLabel.text=modelOrderDetail.pay_sn;
    [view1 addSubview:tradeLabel];

    ordertimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(tradenumLabel.frame.origin.x,tradenumLabel.frame.origin.y+tradenumLabel.frame.size.height, 80, 30)];
    ordertimeLabel.font = [UIFont systemFontOfSize:15];
    ordertimeLabel.textColor = [UIColor blackColor];
    ordertimeLabel.textAlignment = NSTextAlignmentLeft;
    ordertimeLabel.text=@"订单日期";
    [view1 addSubview:ordertimeLabel];
        
    orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(ordertimeLabel.frame.origin.x+ordertimeLabel.frame.size.width,ordertimeLabel.frame.origin.y, SCREEN_WIDTH-100, 30)];
    orderLabel.font = [UIFont systemFontOfSize:15];
    orderLabel.textColor = [UIColor blackColor];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.text=modelOrderDetail.order_add_date;
    [view1 addSubview:orderLabel];
    

    allLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-200,orderLabel.frame.origin.y+orderLabel.frame.size.height,200, 35)];
    allLabel.font = BFONT(20);
    allLabel.textColor = APP_COLOR;
    allLabel.textAlignment = NSTextAlignmentRight;
    allLabel.text=[NSString stringWithFormat:@"总计:%@",modelOrderDetail.order_amount];
    [view1 addSubview:allLabel];

    }
    return view1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 100;
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

@end
