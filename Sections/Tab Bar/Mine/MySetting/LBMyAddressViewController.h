//
//  LBMyAddressViewController.h
//  SuGeMarket
//
//  收货地址
//  Created by Josin on 15-4-24.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMyAddressViewController : UIViewController
@property (nonatomic) BOOL changeAddress;
@property (nonatomic) BOOL isDelAddress;
@property (nonatomic, assign) NSString *freight_hash;
@property (nonatomic, assign) NSString *isDefault;
@end
