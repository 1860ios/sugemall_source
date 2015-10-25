//
//  LBGoodsListCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBGoodsListModel.h"

@interface LBGoodsListCell : UICollectionViewCell

@property (nonatomic, retain) UILabel *goodsName;
@property (nonatomic, retain) UILabel *goodsPrice;
//@property (nonatomic, retain) UILabel *goodsEVPrice;
//@property (nonatomic, retain) UILabel *goodsSalenum;
@property (nonatomic, strong) UIImageView *goodsImageView;

-(void)addTheValue:(LBGoodsListModel *)goodsListModel;

@end
