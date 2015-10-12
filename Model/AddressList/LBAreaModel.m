
//
//  LBAreaModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/3.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAreaModel.h"
#import "LBAreaListModel.h"
#import <MJExtension.h>

@implementation LBAreaModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"area_list":[LBAreaListModel class]};
}

@end
