//
//  LBHomeViewCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/4/28.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBHomeViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *goodsName;
@property (nonatomic) UILabel *goodsPrice;
//@property (nonatomic,strong) UIButton *buyButton;

- (void)addValueForCell:(NSDictionary *)value;
- (void)addValueForCell1:(NSDictionary *)value;

@end
