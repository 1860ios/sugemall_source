//
//  invoiceCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "invoiceCell.h"
#import "UtilsMacro.h"
@implementation invoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initInvoiceCell];
    }
    return self;
}

-(void)initInvoiceCell
{
    //发票信息
    UILabel *invoiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 21)];
    invoiceLabel.text = @"发票信息";
    invoiceLabel.textColor=[UIColor grayColor];
    invoiceLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:invoiceLabel];
    
//    //发票类型
//    _invoiceTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 8, 100, 21)];
//    _invoiceTypeLabel.textAlignment = NSTextAlignmentRight;
//    _invoiceTypeLabel.font = [UIFont systemFontOfSize:15];
//    [self addSubview:_invoiceTypeLabel];
//    
//    //发票抬头
//    _invoiceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 30, 100, 21)];
//    _invoiceTitleLabel.textAlignment = NSTextAlignmentRight;
//    _invoiceTitleLabel.font = [UIFont systemFontOfSize:15];
//    [self addSubview:_invoiceTitleLabel];

    //发票内容
    _invoiceContent = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 230, 10, 200, 21)];
    _invoiceContent.textAlignment = NSTextAlignmentRight;
    _invoiceContent.font = [UIFont systemFontOfSize:15];
    [self addSubview:_invoiceContent];
}

-(void)addValue:(LBBuyStep1Model *)model
{
//    _invoiceTypeLabel.text = model.inv_info[@"inv_content"];
//     _invoiceTitleLabel.text = model.inv_info[@"inv_title"];
    _invoiceContent.text = @"不需要发票";
}
@end
