//
//  LBClassModel.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/11.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBClassModel.h"
#import "MJExtension.h"
#import "LBClassListModel.h"

@implementation LBClassModel

+(NSDictionary *)objectClassInArray
{
    return @{@"class_list":[LBClassListModel class]};
}
@end
