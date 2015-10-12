//
//  invoiceCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBuyStep1Model.h"
@interface invoiceCell : UITableViewCell
@property (nonatomic,strong) UILabel *invoiceTypeLabel;//发票类型
@property (nonatomic,strong) UILabel *invoiceTitleLabel;//发票抬头
@property (nonatomic,strong) UILabel *invoiceContent;//发票内容

-(void)addValue:(LBBuyStep1Model *)model;
@end
