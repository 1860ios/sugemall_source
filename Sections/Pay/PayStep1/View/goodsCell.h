//
//  goodsCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBStep1GoodsListModel.h"
@interface goodsCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *goodsImage;
@property (retain, nonatomic)  UILabel *goodsName;
@property (retain, nonatomic)  UILabel *goodsNum;
@property (retain, nonatomic)  UILabel *goodsPrice;
@property (retain, nonatomic)  UILabel *storeName;
@property (retain, nonatomic)  UILabel *totalPrice;
@property (retain, nonatomic)  UILabel *freightPrice;

- (void)addValue:(LBStep1GoodsListModel *)model;

@end
