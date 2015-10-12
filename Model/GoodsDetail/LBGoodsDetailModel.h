//
//  LBGoodsDetailModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBGoodsInfoModel.h"
#import "LBStoreInfoModel.h"

@interface LBGoodsDetailModel : NSObject

//@property (nonatomic, strong) NSMutableArray *gift_array;
@property (nonatomic, strong) NSMutableArray *goods_commend_list;
@property (nonatomic, copy  ) NSArray       *goods_img;
@property (nonatomic, copy  ) NSString       *mansong_info;

@property (nonatomic, strong) LBGoodsInfoModel *goods_info;
@property (nonatomic, strong) LBStoreInfoModel *store_info;

@property (nonatomic, copy) NSDictionary *spec_image;
@property (nonatomic, copy) NSDictionary *spec_list;

@end
