//
//  LBOrderDetailCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/7/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrderDetailModel.h"

@interface LBOrderDetailAddressCell : UITableViewCell

@property(nonatomic,strong)UILabel *consigneeLabel;
@property(nonatomic,strong)UILabel *dressLabel;

- (void)addValue:(LBOrderDetailModel *)model;

@end
