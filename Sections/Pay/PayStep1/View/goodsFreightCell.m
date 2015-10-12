//
//  goodsFreightCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "goodsFreightCell.h"
#import "UtilsMacro.h"

@implementation goodsFreightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initgoodsFreightCell];
    }
    return self;
}

-(void)initgoodsFreightCell
{
    UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 80, 21)];
    goodsLabel.text = @"商品金额";
    goodsLabel.textColor = [UIColor lightGrayColor];
    goodsLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:goodsLabel];
    
    UILabel *freightLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 80, 21)];
    freightLabel.text = @"运费";
    freightLabel.textColor = [UIColor lightGrayColor];
    freightLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:freightLabel];
    
    //返回的商品金额
    _goodsMoney = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 8, 100, 21)];
    _goodsMoney.textColor = [UIColor redColor];
    _goodsMoney.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodsMoney];
    //返回的运费
    _freightMoney = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 30, 100, 21)];
    _freightMoney.textColor = [UIColor redColor];
    _freightMoney.textAlignment = NSTextAlignmentRight;
    [self addSubview:_freightMoney];
}

-(void)addValue:(LBStoreCartListModel *)model
{
    
}

@end
