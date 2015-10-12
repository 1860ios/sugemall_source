//
//  LBBuyStep1Model.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBAddressListModel.h"


@interface LBBuyStep1Model : NSObject

@property (nonatomic, copy) NSString *freight_hash;
@property (nonatomic, copy) NSString *ifshow_offpay;
@property (nonatomic, copy) NSString *vat_hash;
@property (nonatomic, copy) NSString *available_predeposit;
@property (nonatomic, copy) NSString *available_rc_balance;

@property (nonatomic, strong) NSDictionary *inv_info;
@property (nonatomic, strong) LBAddressListModel *address_info;

@end
