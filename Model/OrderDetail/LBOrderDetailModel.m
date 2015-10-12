//
//  LBOrderDetailModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/7/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderDetailModel.h"
#import "LBOrderDetailGoodsModel.h"
#import <MJExtension.h>

@implementation LBOrderDetailModel

+ (NSDictionary *)objectClassInArray{
    return @{@"extend_order_goods":[LBOrderDetailGoodsModel class]};
}

@end
