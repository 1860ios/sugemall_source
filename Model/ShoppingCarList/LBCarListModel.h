//
//  LBCarListModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCarListModel : NSObject

@property (nonatomic, copy) NSString *bl_id;
@property (nonatomic, copy) NSString *buyer_id;
@property (nonatomic, copy) NSString *cart_id;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_image_url;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *goods_sum;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;

@end
