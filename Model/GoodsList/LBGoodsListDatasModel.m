//
//  LBGoodsListDatasModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsListDatasModel.h"
#import "LBGoodsListModel.h"
#import "MJExtension.h"

@implementation LBGoodsListDatasModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"goods_list":[LBGoodsListModel class]};
}
@end
