//
//  LBStoreCartListModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/27.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBStoreCartListModel.h"
#import "LBStep1GoodsListModel.h"
#import "MJExtension.h"

@implementation LBStoreCartListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"goods_list":[LBStep1GoodsListModel class]};
}

@end
