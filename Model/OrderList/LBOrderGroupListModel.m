//
//  LBOrderGroupListModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderGroupListModel.h"
#import "LBOrderListModel.h"
#import <MJExtension.h>

@implementation LBOrderGroupListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"order_list":[LBOrderListModel class]};
}

@end
