//
//  LBAdvList.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/10.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAdvListModel.h"
#import <MJExtension.h>

@implementation LBAdvListModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"item":[LBAdvItemModel class]};
}

@end
