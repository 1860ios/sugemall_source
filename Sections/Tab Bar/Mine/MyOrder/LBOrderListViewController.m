//
//  LBOrderListViewController.m
//  SuGeMarket
//
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderListViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "LBUserInfo.h"
#import <TSMessage.h>
#import <MBProgressHUD.h>
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "LBOrderGroupListModel.h"
#import "LBOrderListModel.h"
#import "LBOrderModel.h"
#import "LBExtendOrderGoods.h"
#import "MJExtension.h"
#import "LBOrderListCell.h"
#import <UIImageView+WebCache.h>
#import <MobClick.h>
#import "NotificationMacro.h"
#import "AppMacro.h"
#import "MJRefresh.h"
#import "LBGoodsDetailViewController.h"
#import "LBBuyStep2ViewController.h"
#import "LBDeliverViewController.h"
#import "LBOrderDetailViewController.h"
#import "LBApplyRefundViewController.h"



@interface LBOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //1
    LBOrderModel *_model;
    //2
    LBOrderGroupListModel *_modelGroupList;
    //3
    LBOrderListModel *_modelList;
    //4
    LBExtendOrderGoods *_modelExtendOrder;
    //网络取数组
    NSDictionary *orderGroupArray;

    //未付款数量
    NSInteger  noPayOrderNum;
    //分页
    int _curpage;
    NSString *curnum;
    NSMutableArray *orderDatasArray;
    NSArray *newOrderDatasArray;
    //退款
    UIButton *refundButton;
}

@property (nonatomic, strong) UITableView *_tableView;

@end

@implementation LBOrderListViewController
@synthesize _orderStatus;
@synthesize isAllOrder;
@synthesize _recycle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _curpage = 1;
    newOrderDatasArray = [[NSArray alloc] init];
    orderDatasArray = [[NSMutableArray alloc] init];
    if ([_orderStatus isEqualToString:@"10"]){
        self.title = @"未付款";
    }else if ([_orderStatus isEqualToString:@"20"]){
        self.title = @"待发货";
    }else if ([_orderStatus isEqualToString:@"30"]){
        self.title = @"待收货";
    }
    if ([_recycle isEqualToString:@"1"]){
        self.title = @"回收站";
    }else{
//        UIBarButtonItem *junk = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"junk") style:UIBarButtonItemStylePlain target:self action:@selector(goToJunk)];
//        self.navigationItem.rightBarButtonItem = junk;
    }
    //1
    [self loadTableView];
    //
    [self setUpRefresh];
    [self setUpFooterRefresh1];
    [self loadDatas:nil withURL:SUGE_ORDER_LIST boo:@"1" curpage:@"1" recycle:_recycle];
}

- (void)goToJunk
{
    LBOrderListViewController *order = [[LBOrderListViewController alloc] init];
    order._recycle = @"1";
    [self.navigationController pushViewController:order animated:YES];
}


#pragma mark 设置下拉刷新
- (void)setUpRefresh
{

    [self._tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas2)];
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

- (void)loadNewDatas2
{
    [self loadOrderDatas_url:SUGE_ORDER_LIST orderId:nil type:@"1" recycle:_recycle];
}

#pragma mark 设置上拉加载更多
- (void)setUpFooterRefresh1
{
    [__tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData1)];
    // 隐藏时间
    self._tableView.header.updatedTimeHidden = YES;
    // 设置文字
    [self._tableView.footer setTitle:@"加载更多订单..." forState:MJRefreshFooterStateIdle];
    [self._tableView.footer setTitle:@"加载中..." forState:MJRefreshFooterStateRefreshing];
    [self._tableView.footer setTitle:@"到头了..." forState:MJRefreshFooterStateNoMoreData];
    
    // 设置字体
    self._tableView.header.font = APP_REFRESH_FONT_SIZE;
    
    // 设置颜色
    self._tableView.header.textColor = APP_COLOR;
}

- (void)loadNewData1
{
    _curpage++;
    curnum = [NSString stringWithFormat:@"%d",_curpage];
    [self loadDatas:nil withURL:SUGE_ORDER_LIST boo:@"1" curpage:curnum recycle:_recycle];
}

#pragma mark  load tableView
- (void)loadTableView
{
//    CGFloat height;
//    if (isAllOrder) {
//        height =SCREEN_HEIGHT-49-49;
//    }else{
//        height =SCREEN_HEIGHT-49;
//    }
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    __tableView.delegate =self;
    __tableView.dataSource =self;
    __tableView.tableFooterView = [UIView new];
//    [__tableView registerClass:[LBOrderListCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:__tableView];
}


#pragma mark loadDatas
- (void)loadDatas:(NSString *)orderID withURL:(NSString *)url boo:(NSString *)boo curpage:(NSString *)curpage recycle:(NSString *)recycle
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =nil;

    if ([recycle isEqualToString:@"1"]) {
        parameter = @{@"key":key,@"page":@"15",@"curpage":curpage,@"recycle":@"1"};
    }else{
    if (orderID != nil) {
        parameter = @{@"key":key,@"order_id":orderID,@"page":@"15",@"curpage":curpage,@"recycle":@"0"};
    }else{
        parameter = @{@"key":key,@"order_status":_orderStatus,@"page":@"15",@"curpage":curpage,@"recycle":@"0"};
    }
    }
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //刷新结束
        [self._tableView.header endRefreshing];
        [self._tableView.footer endRefreshing];
        NSLog(@"orderlist_responObject:%@",responObject);
        
        if ([boo isEqualToString:@"1"]) {
            
            newOrderDatasArray = [LBOrderGroupListModel objectArrayWithKeyValuesArray:responObject[@"datas"][@"order_group_list"]];
            if (newOrderDatasArray.count == 0) {
                [self._tableView.footer noticeNoMoreData];
            }
            [orderDatasArray addObjectsFromArray:newOrderDatasArray];
            
            
        }
        if (orderDatasArray.count == 0) {
            if ([_orderStatus isEqualToString:@"50"]) {
                self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"no_order_50")];
            }else{
                self._tableView.backgroundView = [[UIImageView alloc]initWithImage:IMAGE(@"no_order")];
            }
            // 变为没有更多数据的状态
            [self._tableView.footer noticeNoMoreData];

        }else{
            self._tableView.backgroundView = [UIView new];
        }
        //刷新tableview
        [self._tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        
        NSLog(@"error:%@",error);
    }];
    //miss提示
    [SVProgressHUD dismiss];
}

- (void)loadOrderDatas_url:(NSString *)url orderId:(NSString *)orderid type:(NSString *)type recycle:(NSString *)recycle
{
    //提示
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter = nil;
    if ([recycle isEqualToString:@"1"]) {
        parameter = @{@"key":key,@"page":@"20",@"curpage":@"1",@"recycle":@"1"};
    }else{
        if (orderid !=nil) {
        parameter = @{@"key":key,@"order_id":orderid,@"page":@"20",@"curpage":@"1",@"recycle":@"0"};
    }else{
        parameter = @{@"key":key,@"order_status":_orderStatus,@"page":@"20",@"curpage":@"1",@"recycle":@"0"};

    }
    }
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        [self._tableView.header endRefreshing];
        NSLog(@"order_some:%@",responObject);
        if ([type isEqualToString:@"1"]) {

            NSArray *kk = [LBOrderGroupListModel objectArrayWithKeyValuesArray:responObject[@"datas"][@"order_group_list"]];
            orderDatasArray = [NSMutableArray arrayWithArray:kk];
            [__tableView reloadData];
        }else if ([type isEqualToString:@"quxiao"]){
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"取消订单成功~" type:TSMessageNotificationTypeSuccess];
            [self loadOrderDatas_url:SUGE_ORDER_LIST orderId:nil type:@"1" recycle:@"0"];
        }else if ([type isEqualToString:@"queren"]){
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"确认订单成功~" type:TSMessageNotificationTypeSuccess];
            [self loadOrderDatas_url:SUGE_ORDER_LIST orderId:nil type:@"1" recycle:@"0"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [TSMessage showNotificationWithTitle:@"网络不佳" subtitle:@"请检查网络" type:TSMessageNotificationTypeWarning];
        
        NSLog(@"error:%@",error);
    }];
    //miss提示
    [SVProgressHUD dismiss];
}

#pragma mark 统计页面
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [MobClick beginLogPageView:@"订单中心"];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单中心"];
}

#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderDatasArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _modelGroupList = orderDatasArray[section];
    return _modelGroupList.order_list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

//订单支付/价格 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

//订单支付
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    _modelGroupList = orderDatasArray[section];
//     _modelList =  _modelGroupList.order_list[section];
    
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    orderView.backgroundColor = [UIColor whiteColor];
    //订单总价
    UILabel *pay_amount = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 120, 30)];
    pay_amount.text = [NSString stringWithFormat:@"总价:%@",_modelGroupList.pay_amount];
    pay_amount.font = BFONT(20);
    pay_amount.textColor = APP_COLOR;
    [orderView addSubview:pay_amount];
    
    //订单按钮
    __orderPay = [UIButton buttonWithType:UIButtonTypeCustom];
    __orderPay.frame = CGRectMake(SCREEN_WIDTH/2, 5, SCREEN_WIDTH/2-10, 30);
    [__orderPay setTitle:@"马上支付" forState:0];
    [__orderPay setTitleColor:[UIColor redColor] forState:0];
    __orderPay.layer.borderColor = [APP_COLOR CGColor];
    __orderPay.layer.borderWidth = 1;
    __orderPay.layer.masksToBounds = YES;
    __orderPay.layer.cornerRadius = 4;
    __orderPay.tag = section;
    [__orderPay addTarget:self action:@selector(orderMethod1:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:__orderPay];
    if ([_recycle isEqualToString:@"1"]) {
                __orderPay.hidden =YES;
    }else{
    if (_modelGroupList.pay_amount.length!=0) {
        __orderPay.hidden =NO;
    }else{
        __orderPay.hidden =YES;
        pay_amount.text = @"";
    }
    }
    return orderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LBOrderListCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (!cell) {
        cell = [[LBOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    _modelExtendOrder = _modelList.extend_order_goods[0];
    
    //赋值
    cell._store_name_label.text = [NSString stringWithFormat:@"%@ >",_modelList.store_name];
    cell._state_desc_label.text = _modelList.state_desc;
    [cell._goods_image_view sd_setImageWithURL:[NSURL URLWithString:_modelExtendOrder.goods_image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
    cell._goods_name_label.text = _modelExtendOrder.goods_name;
    cell._goods_price_label.text =[NSString stringWithFormat:@"单价:%@",_modelExtendOrder.goods_price];
    cell._shipping_fee_label.text = [NSString stringWithFormat:@"运费:%@",_modelList.shipping_fee];
    NSString *ki =_modelList.order_amount;
    cell._order_amount_label.text = [NSString stringWithFormat:@"订单价:%@",ki];
    cell._goods_num_label.text = [NSString stringWithFormat:@"×%@",_modelExtendOrder.goods_num];

    //退款
    refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(SCREEN_WIDTH*3/4, cell._order_amount_label.frame.origin.y, SCREEN_WIDTH/4-10, 30);
    [refundButton setTitleColor:[UIColor redColor] forState:0];
    refundButton.layer.borderColor = [APP_COLOR CGColor];
    refundButton.layer.borderWidth = 1;
    refundButton.layer.masksToBounds = YES;
    refundButton.layer.cornerRadius = 4;
    refundButton.tag = row+5000;
    [refundButton setTitle:@"退 款" forState:0];
    [refundButton addTarget:self action:@selector(refundMethod1:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:refundButton];
    refundButton.hidden = YES;
    if ([_orderStatus isEqualToString:@"20"]) {

            refundButton.hidden = NO;

    }
        //    }else if ([_orderStatus isEqualToString:@"30"]){
//        [refundButton setTitle:@"退 货" forState:0];
//        [refundButton addTarget:self action:@selector(refundMethod2:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:refundButton];
//    }
    // true/false
    if ([_recycle isEqualToString:@"1"]) {
        cell._orderReciver.hidden = YES;
        cell._orderCancel.hidden =YES;
        cell._searchDeliver.hidden = YES;
        __orderPay.hidden =YES;
    }else{
    if ([_modelList.if_cancel isEqualToString:@"1"]) {
        cell._orderCancel.hidden =NO;
    }else{
        cell._orderCancel.hidden =YES;
    }
    if ([_modelList.if_deliver isEqualToString:@"1"]) {
        cell._searchDeliver.hidden = NO;
    }else{
        cell._searchDeliver.hidden = YES;
    }

    if ([_modelList.if_receive isEqualToString:@"1"]) {
        cell._orderReciver.hidden = NO;
    }else{
        cell._orderReciver.hidden = YES;
    }
    
    }
    //20取消订单
    [cell._orderCancel addTarget:self action:@selector(orderMethod2:) forControlEvents:UIControlEventTouchUpInside];
    cell._orderCancel.tag = row+2000;
    //30订单确认
    [cell._orderReciver addTarget:self action:@selector(orderMethod4:) forControlEvents:UIControlEventTouchUpInside];
    cell._orderReciver.tag = row+3000;
    //40订单查询
    [cell._searchDeliver addTarget:self action:@selector(orderMethod3:) forControlEvents:UIControlEventTouchUpInside];
    cell._searchDeliver.tag = row+4000;
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    _modelGroupList = orderDatasArray[section];
    NSString *pay_sn = [NSString stringWithFormat:@"订单编号:%@",_modelGroupList.pay_sn];
    return pay_sn;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [__tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    if (isAllOrder) {
        NSDictionary *dic2 = @{@"order_id":_modelList.order_id};
        [NOTIFICATION_CENTER postNotificationName:@"xiangqing" object:nil userInfo:dic2];
        
    }else{
        
    LBOrderDetailViewController *orderDetail = [[LBOrderDetailViewController alloc] init];
    orderDetail.order_id = _modelList.order_id;
    [self.navigationController pushViewController:orderDetail animated:YES];

    }
}

#pragma mark  订单删除/还原

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title;
    if ([_recycle isEqualToString:@"1"]) {
        title = @"还原";
    }else{
        title = @"删除";
    }
    return title;
}

#pragma mark
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //登陆key
        NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
        //订单编号
        NSString *order_id = _modelList.order_id;
        NSLog(@"fav_id:%@",order_id);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        NSDictionary *parameter =@{@"order_id":order_id,@"key":key};
        NSString *url;
        if ([_recycle isEqualToString:@"1"]) {
            url = SUGE_RE_ORDER;
        }else{
            url = SUGE_DEL_ORDER;
        }
        [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
            
            NSLog(@"responObject:%@",responObject);
            
            if ([responObject[@"datas"] isEqualToString:@"1"]) {
                NSString *state;
                if ([_recycle isEqualToString:@"1"]) {
                    state = @"还原订单成功~";
                }else{
                    state = @"删除订单成功~";
                }
                [SVProgressHUD showSuccessWithStatus:state maskType:SVProgressHUDMaskTypeClear];
                
                    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                         dispatch_async(queue, ^{
                             //再次请求数据
                             [self loadOrderDatas_url:SUGE_ORDER_LIST orderId:nil type:@"1" recycle:_recycle];
                             });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                });
            }else{
                NSString *error = responObject[@"datas"][@"error"];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
        } failure:^(AFHTTPRequestOperation *op,NSError *error){
        }];

    }
    
}




#pragma mark  订单处理method
#pragma mark 支付订单

- (void)orderMethod1:(UIButton *)btn
{
    NSIndexPath* indexPath = [self._tableView indexPathForSelectedRow];
    NSInteger row = indexPath.row;
    NSInteger section = btn.tag;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    _modelExtendOrder = _modelList.extend_order_goods[0];

    if (isAllOrder) {
        NSDictionary *dic1 = @{@"pay_sn":_modelGroupList.pay_sn,@"goods_name":_modelExtendOrder.goods_name,@"pay_amount":_modelGroupList.pay_amount};
        [NOTIFICATION_CENTER postNotificationName:@"payorder" object:nil userInfo:dic1];
    }else{
    LBBuyStep2ViewController *step2 = [[LBBuyStep2ViewController alloc] init];
    step2.orderId = _modelGroupList.pay_sn;
    step2.body = _modelExtendOrder.goods_name;
    step2.subject = _modelExtendOrder.goods_name;
    step2.price = _modelGroupList.pay_amount;
    //      step2.price = modelList.order_amount;
    [self.navigationController pushViewController:step2 animated:YES];
    }
}

#pragma mark 取消订单
- (void)orderMethod2:(UIButton *)btn
{
    UITableViewCell* buttonCell = (UITableViewCell*)[btn superview];
    NSUInteger section = [[self._tableView indexPathForCell:buttonCell]section];
//    NSIndexPath* indexPath = [self._tableView indexPathForSelectedRow];
//    NSInteger section = indexPath.section;
    NSInteger row = btn.tag-2000;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    NSLog(@"取消订单index_row:%ld,section:%ld",(long)row,(long)section);

    NSString *orderID = _modelList.order_id;
//    [self loadDatas:orderID withURL:SUGE_ORDER_CANCEL boo:@"10" curpage:@"1"];
    [self loadOrderDatas_url:SUGE_ORDER_CANCEL orderId:orderID type:@"quxiao" recycle:@"0"];
}

#pragma mark 查看订单
- (void)orderMethod3:(UIButton *)btn
{
        NSLog(@"查看物流");
    UITableViewCell* buttonCell = (UITableViewCell*)[btn superview];
    NSUInteger section = [[self._tableView indexPathForCell:buttonCell]section];
    NSInteger row = btn.tag-4000;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    if (isAllOrder) {
        NSDictionary *dic1 = @{@"order_id":_modelList.order_id};
        [NOTIFICATION_CENTER postNotificationName:@"wuliu" object:nil userInfo:dic1];
    }else{
    LBDeliverViewController *deliver = [[LBDeliverViewController alloc] init];
    deliver._orderID = _modelList.order_id;
    [self.navigationController pushViewController:deliver animated:YES];
    }
}

#pragma mark 确认订单
- (void)orderMethod4:(UIButton *)btn
{
    UITableViewCell* buttonCell = (UITableViewCell*)[btn superview];
    NSUInteger section = [[self._tableView indexPathForCell:buttonCell]section];
    NSInteger row = btn.tag-3000;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];

    NSLog(@"确认收货");
    NSString *orderID = _modelList.order_id;
//    [self loadDatas:orderID withURL:SUGE_ORDER_RECEIVE boo:@"20" curpage:@"1"];
    [self loadOrderDatas_url:SUGE_ORDER_RECEIVE orderId:orderID type:@"queren" recycle:@"0"];
}

#pragma mark 订单退款
- (void)refundMethod1:(UIButton *)btn
{
    UITableViewCell* buttonCell = (UITableViewCell*)[btn superview];
    NSUInteger section = [[self._tableView indexPathForCell:buttonCell]section];
    NSInteger row = btn.tag-5000;
    _modelGroupList = orderDatasArray[section];
    _modelList =  _modelGroupList.order_list[row];
    _modelExtendOrder = _modelList.extend_order_goods[0];
     NSDictionary *dic1 = @{@"show":_modelExtendOrder.goods_name,@"orderid":_modelExtendOrder.order_id,@"goodimage":_modelExtendOrder.goods_image_url,@"num":_modelExtendOrder.goods_num,@"amount":_modelList.order_amount,@"goodsid":_modelExtendOrder.goods_id,@"paysn":_modelGroupList.pay_sn};
    if (isAllOrder) {
       
        [NOTIFICATION_CENTER postNotificationName:@"tuikuan" object:nil userInfo:dic1];
    }else{
    
    LBApplyRefundViewController *applyrefund=[[LBApplyRefundViewController alloc]init];

    applyrefund.refundDic=dic1;
    
    [self.navigationController pushViewController:applyrefund animated:YES];
    }
    NSLog(@"订单退款");

}

#pragma mark 订单退货
- (void)refundMethod2:(UIButton *)btn
{
    NSLog(@"订单退货");
}


@end
