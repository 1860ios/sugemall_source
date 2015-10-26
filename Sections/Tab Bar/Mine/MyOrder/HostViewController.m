//
//  HostViewController.m
//  ICViewPager
//
//  全部订单
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"
#import "LBOrderListViewController.h"
#import "MobClick.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"
#import "AppMacro.h"
#import "LBApplyRefundViewController.h"
#import "LBOrderDetailViewController.h"
#import "LBDeliverViewController.h"
#import "LBBuyStep2ViewController.h"

@interface HostViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation HostViewController
@synthesize _orderStatus;

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;

    self.title = @"全部订单";
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toRefund:) name:@"tuikuan" object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toGoOrderDetail:) name:@"xiangqing" object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toGoWuliu:) name:@"wuliu" object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toGoPayOrder:) name:@"payorder" object:nil];
    
//    UIBarButtonItem *junk = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"junk") style:UIBarButtonItemStylePlain target:self action:@selector(goToJunk)];
//    self.navigationItem.rightBarButtonItem = junk;
    [super viewDidLoad];
}

- (void)toRefund:(NSNotification*)notification
{
   
    LBApplyRefundViewController *applyrefund=[[LBApplyRefundViewController alloc]init];
    applyrefund.refundDic = [notification userInfo];
    
    
    [self.navigationController pushViewController:applyrefund animated:YES];
}

- (void)toGoOrderDetail:(NSNotification *)not
{
    
    NSString *str1 = [[not userInfo] objectForKey:@"order_id"];
    LBOrderDetailViewController *orderDetail = [[LBOrderDetailViewController alloc] init];
    orderDetail.order_id = str1;
    [self.navigationController pushViewController:orderDetail animated:YES];

}

- (void)toGoWuliu:(NSNotification *)not
{
    NSString *s1 = [[not userInfo] objectForKey:@"order_id"];
    LBDeliverViewController *deliver = [[LBDeliverViewController alloc] init];
    deliver._orderID = s1;
    [self.navigationController pushViewController:deliver animated:YES];
}
- (void)toGoPayOrder:(NSNotification *)not
{
    NSString *s1 = [[not userInfo] objectForKey:@"pay_sn"];
    NSString *s2 = [[not userInfo] objectForKey:@"goods_name"];
    NSString *s3 = [[not userInfo] objectForKey:@"pay_amount"];
    
    LBBuyStep2ViewController *step2 = [[LBBuyStep2ViewController alloc] init];
    step2.orderId = s1;
    step2.body = s2;
    step2.subject = s2;
    step2.price = s3;
    [self.navigationController pushViewController:step2 animated:YES];
}

- (void)goToJunk
{
    LBOrderListViewController *order = [[LBOrderListViewController alloc] init];
    order._recycle = @"1";
    [self.navigationController pushViewController:order animated:YES];
}


#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 6;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    switch (index) {
        case 0:
            label.text = @"全部订单";
            break;
        case 1:
            label.text = @"未付款";
            break;
        case 2:
            label.text = @"已付款";
            break;
        case 3:
            label.text = @"已发货";
            break;
        case 4:
            label.text = @"已收货";
            break;
        case 5:
            label.text = @"交易结束";
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    LBOrderListViewController *order = [[LBOrderListViewController alloc] init];
    switch (index) {
        case 0:
            order._orderStatus = @"";
            break;
        case 1:
            order._orderStatus = @"10";
            break;
        case 2:
            order._orderStatus = @"20";
            break;
        case 3:
            order._orderStatus = @"30";
            break;
        case 4:
            order._orderStatus = @"40";
            break;
        case 5:
            order._orderStatus = @"60";
            break;
    }
    order.isAllOrder = YES;
    order._recycle = @"0";
    return order;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [APP_COLOR colorWithAlphaComponent:0.64];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    return color;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//        self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [MobClick beginLogPageView:@"全部订单"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"全部订单"];
}


@end
