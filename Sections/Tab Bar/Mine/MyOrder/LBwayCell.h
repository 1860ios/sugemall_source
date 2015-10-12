//
//  LBwayCell.h
//  SuGeMarket
//
//  Created by Apple on 15/7/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBOrderDetailModel.h"

@interface LBwayCell : UITableViewCell
@property(nonatomic,strong)UILabel *wayLabel;
@property(nonatomic,strong)UILabel *invoiceLabel;
@property(nonatomic,strong)UILabel *detailwayLabel;
@property(nonatomic,strong)UILabel *messageLabel;

- (void)addValue:(LBOrderDetailModel *)model;

@end
