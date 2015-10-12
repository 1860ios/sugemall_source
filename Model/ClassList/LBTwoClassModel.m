//
//  LBTwoClassModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/12.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBTwoClassModel.h"
#import "MJExtension.h"
#import "LBTwoClassListModel.h"

@implementation LBTwoClassModel
+(NSDictionary *)objectClassInArray
{
    return @{@"class_list":[LBTwoClassListModel class]};
}
@end
