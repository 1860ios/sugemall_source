//
//  LBgoodsShowCell.h
//  SuGeMarket
//
//  Created by Apple on 15/7/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrderDetailGoodsModel.h"
#import "LBOrderDetailModel.h"
@interface LBgoodsShowCell : UITableViewCell

//@property(nonatomic,strong)UIImageView *storeImageView;
//@property(nonatomic,strong)UILabel *storenameLabel;
@property(nonatomic,strong)UIImageView *goodsImageView;
@property(nonatomic,strong)UILabel *showLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *numLabel;
@property(nonatomic,strong)UILabel *totalMoneyLabel;
@property(nonatomic,strong)UIButton *searchDeliver;
@property(nonatomic,strong)UIButton *orderCancel;
@property(nonatomic,strong)UIButton *orderReciver;
@property(nonatomic,strong)UIButton *refundButton;
@property(nonatomic,strong)UILabel *orderLabel;
@property(nonatomic,strong)UILabel *tradeLabel;
@property(nonatomic,strong)UILabel *orderLabel1;

- (void)addValue:(LBOrderDetailGoodsModel *)model goodsModel:(LBOrderDetailModel *)goodsModel;

@end
