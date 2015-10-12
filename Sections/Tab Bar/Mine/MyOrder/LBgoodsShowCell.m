//
//  LBgoodsShowCell.m
//  SuGeMarket
//
//  Created by Apple on 15/7/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBgoodsShowCell.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>

@implementation LBgoodsShowCell
@synthesize goodsImageView;
@synthesize showLabel;
@synthesize moneyLabel;
@synthesize numLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initgoodsCell];
    }
    return self;
}

- (void)initgoodsCell
{
    
    goodsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10, 80, 80)];
    goodsImageView.backgroundColor=[UIColor yellowColor];
    [self addSubview:goodsImageView];
  
    showLabel=[[UILabel alloc]initWithFrame:CGRectMake(goodsImageView.frame.origin.x+goodsImageView.frame.size.width+10,goodsImageView.frame.origin.y, 200, 45)];
    showLabel.font = [UIFont systemFontOfSize:15];
    showLabel.textColor = [UIColor blackColor];
    showLabel.textAlignment = NSTextAlignmentLeft;
    showLabel.numberOfLines=2;
    [self addSubview:showLabel];
    
    moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(showLabel.frame.origin.x,showLabel.frame.origin.y+showLabel.frame.size.height,150,30)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.textAlignment = NSTextAlignmentLeft;

    [self addSubview:moneyLabel];
    

    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.origin.x+moneyLabel.frame.size.width,moneyLabel.frame.origin.y,65,30)];
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.textColor = [UIColor blackColor];
    numLabel.textAlignment = NSTextAlignmentLeft;

    [self addSubview:numLabel];
    
}

- (void)addValue:(LBOrderDetailGoodsModel *)model
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:IMAGE(@"")];
        showLabel.text = model.goods_name;
        moneyLabel.text=[NSString stringWithFormat:@"单价:%@",model.goods_pay_price];
//        preferentialLabel.text=;
        numLabel.text=[NSString stringWithFormat:@"X %@",model.goods_num];
}


@end
