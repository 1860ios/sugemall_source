//
//  LBDistributionmodeCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBDistributionmodeCell.h"
#import "UtilsMacro.h"
@implementation LBDistributionmodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initDistributionmodeCell];
    }
    return self;
}

-(void)initDistributionmodeCell
{
    //支付配送方式
    UILabel *DistributionLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 19, 100, 21)];
    DistributionLabel.text = @"支付配送";
    DistributionLabel.font = [UIFont systemFontOfSize:15];
    DistributionLabel.textColor=[UIColor grayColor];
    [self addSubview:DistributionLabel];
    
    //mode of payment 支付方式
    _payMentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 8, 80, 21)];
    _payMentLabel.text = @"在线支付";
    _payMentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_payMentLabel];
    
    //邮递方式 Mail delivery
    _deliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 30, 80, 21)];
    _deliveryLabel.text = @"普通快递";
    _deliveryLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_deliveryLabel];
}


@end
