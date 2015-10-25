//
//  LBGoodsListCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsListCell.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@implementation LBGoodsListCell
@synthesize goodsName;
@synthesize goodsPrice;
@synthesize goodsEVPrice;
@synthesize goodsImageView;
@synthesize goodsSalenum;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initGoodsListCell];
    }
    return self;
}

- (void)initGoodsListCell
{
    //商品图
    goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:goodsImageView];
   
    //商品名
    goodsName = [[UILabel alloc] initWithFrame:CGRectZero];
    goodsName.numberOfLines = 2;
        goodsName.font = FONT(16);
//    goodsName.adjustsFontSizeToFitWidth = YES;
    [self addSubview:goodsName];
    
    //商品促销价
    goodsEVPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    goodsEVPrice.textColor = APP_COLOR;
    goodsEVPrice.font = BFONT(18);
    //    goodsEVPrice.adjustsFontSizeToFitWidth = YES;
    [self addSubview:goodsEVPrice];
    
    //商品价格
    goodsPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    goodsPrice.textColor = [UIColor lightGrayColor];
//    goodsPrice.isWithStrikeThrough = YES;
    goodsPrice.font = FONT(12);
//    goodsPrice.adjustsFontSizeToFitWidth = YES;
    [self addSubview:goodsPrice];
    
    //销量
    goodsSalenum = [[UILabel alloc] initWithFrame:CGRectZero];
    goodsSalenum.textColor = [UIColor lightGrayColor];
    goodsSalenum.font = BFONT(12);
    [self addSubview:goodsSalenum];
    
    goodsImageView.frame = CGRectMake(5, 5, 120, 120);
    goodsName.frame = CGRectMake(goodsImageView.frame.size.width+15, 5, SCREEN_WIDTH-140, 40);
    goodsEVPrice.frame = CGRectMake(goodsName.frame.origin.x, 40, 120, 45);
    goodsPrice.frame = CGRectMake(goodsName.frame.origin.x, 90, 60, 25);
    goodsSalenum.frame = CGRectMake(goodsPrice.frame.origin.x+goodsPrice.frame.size.width+10, goodsPrice.frame.origin.y, 120, 25);
    
}

//- (void)layoutSubviews
//{
//    goodsImageView.frame = CGRectMake(5, 5, 120, 120);
//    goodsName.frame = CGRectMake(goodsImageView.frame.size.width+15, 5, SCREEN_WIDTH-140, 40);
//    goodsEVPrice.frame = CGRectMake(goodsName.frame.origin.x, 40, 120, 45);
//    goodsPrice.frame = CGRectMake(goodsName.frame.origin.x, 90, 60, 25);
//    goodsSalenum.frame = CGRectMake(goodsPrice.frame.origin.x+goodsPrice.frame.size.width+10, goodsPrice.frame.origin.y, 120, 25);
//}

-(void)addTheValue:(LBGoodsListModel *)goodsListModel
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.goods_image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
    goodsName.text = goodsListModel.goods_name;
    goodsEVPrice.text = [NSString stringWithFormat:@"￥%@",goodsListModel.goods_price];
    goodsPrice.text = [NSString stringWithFormat:@"原价:%@",goodsListModel.goods_marketprice];
    goodsSalenum.text = [NSString stringWithFormat:@"销量:%@",goodsListModel.goods_salenum];
}

@end
