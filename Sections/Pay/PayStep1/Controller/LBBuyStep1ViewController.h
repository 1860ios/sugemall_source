//
//  LBBuyStep1ViewController.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBuyStep1ViewController : UIViewController

@property (nonatomic,retain) NSString *_cart_id;
@property (nonatomic,assign) NSString *_ifcart;
@property (nonatomic,assign) NSString *_address_id;
@property (nonatomic,assign) NSString *_vat_hash;
@property (nonatomic,assign) NSString *_pay_name;
@property (nonatomic,assign) NSString *_invoice_id;
@property (nonatomic,assign) NSString *_allow_offpay;
@property (nonatomic,assign) NSString *_totalMoney;

@end
