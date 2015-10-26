//
//  addressCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBuyStep1Model.h"

@interface addressCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *bgImageView;
@property (retain, nonatomic)  UILabel *receiverName;//收货人名字
@property (retain, nonatomic)  UILabel *receiverPhone;//收货人手机号
@property (retain, nonatomic)  UILabel *receiverAddress;//收货人收货地址
@property (retain, nonatomic)  UILabel *defaultAddress;//判断默认地址，是则显示
@property (retain, nonatomic)  UILabel *storeName;//判断默认地址，是则显示

- (void)addValue: (LBBuyStep1Model *)model;
@end
