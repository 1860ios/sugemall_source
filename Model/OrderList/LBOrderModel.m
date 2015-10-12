//
//  LBOrderListModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderModel.h"
#import "LBOrderGroupListModel.h"
#import <MJExtension.h>

@implementation LBOrderModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"order_group_list":[LBOrderGroupListModel class]};
}

@end
