//
//  LBOrderListViewController.h
//  SuGeMarket
//
//  订单列表
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBOrderListViewController : UIViewController
@property (nonatomic, assign) NSString *_recycle;
@property (nonatomic, assign) BOOL isAllOrder;
@property (nonatomic, assign) NSString *_orderStatus;
@property (retain, nonatomic)  UIButton *_orderCancel;
@property (retain, nonatomic)  UIButton *_orderPay;
@property (retain, nonatomic)  UIButton *_searchDeliver;
@property (retain, nonatomic)  UIButton *_orderReciver;

@end
