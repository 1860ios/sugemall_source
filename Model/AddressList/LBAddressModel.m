//
//  LBAddressModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/27.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAddressModel.h"
#import "MJExtension.h"
#import "LBAddressListModel.h"

@implementation LBAddressModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"address_list":[LBAddressListModel class]};
}

@end
