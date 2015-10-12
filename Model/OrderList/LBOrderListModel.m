//
//  LBOrderListModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderListModel.h"
#import "LBExtendOrderGoods.h"
#import <MJExtension.h>

@implementation LBOrderListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"extend_order_goods":[LBExtendOrderGoods class]};
}

@end
