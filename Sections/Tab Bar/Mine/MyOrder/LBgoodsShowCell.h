//
//  LBgoodsShowCell.h
//  SuGeMarket
//
//  Created by Apple on 15/7/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrderDetailGoodsModel.h"

@interface LBgoodsShowCell : UITableViewCell

//@property(nonatomic,strong)UIImageView *storeImageView;
//@property(nonatomic,strong)UILabel *storenameLabel;
@property(nonatomic,strong)UIImageView *goodsImageView;
@property(nonatomic,strong)UILabel *showLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *numLabel;

- (void)addValue:(LBOrderDetailGoodsModel *)model;

@end
