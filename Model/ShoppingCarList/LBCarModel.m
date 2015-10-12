//
//  LBCarModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBCarModel.h"
#import "LBCarListModel.h"
#import <MJExtension.h>

@implementation LBCarModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"cart_list":[LBCarListModel class]};
}

@end
