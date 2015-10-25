//
//  LBGoodsTopCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/15.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UILabelStrikeThrough.h"
#import "LBGoodsDetailModel.h"

@interface LBGoodsInfoCell : UITableViewCell

@property (nonatomic, retain) UILabel *_goodsName;
@property (nonatomic, retain) UILabel *_goodsPrice;
@property (nonatomic, retain) UILabel *_goodsPromotionPrice;
//@property (nonatomic, retain) UILabel *_evaluationCount;
@property (nonatomic, retain) UILabel *_evaluationGoodStar;
@property (nonatomic, retain) UILabel *_goodsTitle;//月末折扣
@property (nonatomic, retain) UILabel *_goodsStorage;//库存
@property (nonatomic, retain) UILabel *_goodsSalenum;//销量
@property (nonatomic, strong) UIButton *_favoriteButton;//
@property (nonatomic, retain) UILabel *favoriteTitle;
-(void)addTheValue:(LBGoodsDetailModel *)model;
@end
