//
//  LBOrderGroupListModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBOrderGroupListModel : NSObject

@property (nonatomic, strong) NSMutableArray *order_list;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *pay_amount;
@property (nonatomic, copy) NSString *pay_sn;

@end
