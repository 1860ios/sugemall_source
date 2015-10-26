//
//  LBStroeInforCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/15.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBGoodsDetailModel.h"

@interface LBStroeInforCell : UITableViewCell
@property (nonatomic, strong) UIImageView *_storeImage;
@property (nonatomic, retain) UILabel *_storeName;
@property (nonatomic, strong) UIButton *lianxikefu;
@property (nonatomic, strong) UIButton *jinrudianpu;
-(void)addTheValue:(LBGoodsDetailModel *)model;
@end
