//
//  LBExtendStoreModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/7/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBExtendStoreModel : NSObject

@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *cart_id;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_image_url;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *goods_sum;

@end
