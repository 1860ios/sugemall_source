//
//  LBGoodsDetailModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsDetailModel.h"
#import "LBGoodsCommendListModel.h"
#import "MJExtension.h"

@implementation LBGoodsDetailModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"goods_commend_list":[LBGoodsCommendListModel class]};
}

@end
