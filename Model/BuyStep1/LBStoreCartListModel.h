//
//  LBStoreCartListModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/27.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBStoreCartListModel : NSObject

@property (nonatomic, strong) NSMutableArray *goods_list;
@property (nonatomic, copy) NSString *store_goods_total;
@property (nonatomic, copy) NSString *store_mansong_rule_list;
@property (nonatomic, copy) NSString *store_voucher_list;
@property (nonatomic, copy) NSString *freight;
@property (nonatomic, copy) NSString *store_name;


@end
