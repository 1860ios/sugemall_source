//
//  LBSelecGoodsView.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBGoodsDetailModel.h"
#import "RadioBox.h"
#import "RadioGroup.h"
#import "HJCAjustNumButton.h"

@interface LBSelecGoodsView : UIView

@property (nonatomic,strong)  HJCAjustNumButton *numButton;

@property (nonatomic, retain) UILabel*_sepecName;
@property (nonatomic, retain) UILabel *_goodsStorge;
@property (nonatomic, retain) UILabel *_goodsPrice;
@property (nonatomic, strong) UIImageView *_goodsImage;

@property (nonatomic, retain) UILabel *_specNameLabel;
@property (nonatomic, retain) UIButton *_sepecValue;

@property (nonatomic, retain) UILabel *_sizeLabel;
@property (nonatomic, retain) UIButton *_sepecList;

@property (nonatomic, retain) UIButton *_countDelLabel;
@property (nonatomic, retain) UILabel *_countLabel;
@property (nonatomic, retain) UIButton *_countAddLabel;

@property (nonatomic, strong) UIButton *addCarBTN;
@property (nonatomic, strong) UIButton *BuyNowBTN;

@property (nonatomic, retain) RadioBox *radiobox1;
@property (nonatomic, retain) RadioBox *radiobox2;
@property (nonatomic, retain) RadioGroup *radioGroup1;
@property (nonatomic, retain) RadioGroup *radioGroup2;

- (void)addValue:(LBGoodsDetailModel *)model;

@end
