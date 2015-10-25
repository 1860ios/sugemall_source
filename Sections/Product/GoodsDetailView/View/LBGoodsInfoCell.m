//
//  LBGoodsTopCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/15.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsInfoCell.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"

@implementation LBGoodsInfoCell
@synthesize favoriteTitle;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initGoodsInfoCell];
    }
    return self;
}


- (void)initGoodsInfoCell
{

    __goodsName = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsName.numberOfLines = 2;
    __goodsName.adjustsFontSizeToFitWidth = YES;

    __goodsPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsPrice.textColor = [UIColor grayColor];
    __goodsPrice.font = FONT(13);
//    __goodsPrice.isWithStrikeThrough = YES;
    
    __goodsPromotionPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsPromotionPrice.textColor = APP_COLOR;
    __goodsPromotionPrice.font = BFONT(26);
    __goodsPromotionPrice.adjustsFontSizeToFitWidth = YES;
    
    __goodsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsTitle.textColor = [UIColor whiteColor];
    __goodsTitle.backgroundColor = APP_COLOR;
    __goodsTitle.textAlignment = NSTextAlignmentCenter;
    __goodsTitle.adjustsFontSizeToFitWidth = YES;
    
    __favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    __favoriteButton.frame = CGRectZero;
    [__favoriteButton setImage:IMAGE(@"favorite_select") forState:UIControlStateSelected];
    [__favoriteButton setImage:IMAGE(@"favorite_normal") forState:UIControlStateNormal];
    
    
    favoriteTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    favoriteTitle.text = @"收藏";
    favoriteTitle.font = FONT(13);
    favoriteTitle.textColor = [UIColor grayColor];
    favoriteTitle.textAlignment = NSTextAlignmentCenter;
    favoriteTitle.adjustsFontSizeToFitWidth = YES;
    [self addSubview:favoriteTitle];
    
    __evaluationGoodStar = [[UILabel alloc] initWithFrame:CGRectZero];
    __evaluationGoodStar.textColor = [UIColor grayColor];
    __evaluationGoodStar.textAlignment = NSTextAlignmentRight;

    __goodsStorage = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsStorage.textColor = [UIColor grayColor];
    __goodsStorage.adjustsFontSizeToFitWidth = YES;
    
    __goodsSalenum = [[UILabel alloc] initWithFrame:CGRectZero];
    __goodsSalenum.textColor = [UIColor grayColor];
    __goodsSalenum.textAlignment = NSTextAlignmentCenter;
    __goodsSalenum.adjustsFontSizeToFitWidth = YES;


    [self addSubview:__goodsName];
    [self addSubview:__goodsPrice];
    [self addSubview:__goodsPromotionPrice];
    [self addSubview:__goodsTitle];
    [self addSubview:__favoriteButton];
    [self addSubview:__evaluationGoodStar];
    [self addSubview:__goodsStorage];
    [self addSubview:__goodsSalenum];


}

- (void)layoutSubviews
{
    [super layoutSubviews];

    __goodsName.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 35);
    
    __goodsPromotionPrice.frame = CGRectMake(__goodsName.frame.origin.x, __goodsName.frame.origin.y+__goodsName.frame.size.height+5, 100, 35);
    
    __goodsTitle.frame = CGRectMake(__goodsPromotionPrice.frame.origin.x+__goodsPromotionPrice.frame.size.width, __goodsPromotionPrice.frame.origin.y, 40, 20);
    
    __goodsPrice.frame = CGRectMake(__goodsPromotionPrice.frame.origin.x, __goodsPromotionPrice.frame.origin.y+__goodsPromotionPrice.frame.size.height, 70, 20);
    
    __favoriteButton.frame = CGRectMake(SCREEN_WIDTH-10-60, __goodsPromotionPrice.frame.origin.y-20, 60, 60);
    
    favoriteTitle.frame = CGRectMake(__favoriteButton.frame.origin.x, __favoriteButton.frame.origin.y+__favoriteButton.frame.size.height-10, __favoriteButton.frame.size.width, 10);
    
    __goodsStorage.frame = CGRectMake(__goodsPrice.frame.origin.x, __goodsPrice.frame.origin.y+__goodsPrice.frame.size.height+5, 100, 20);
    
    __goodsSalenum.frame = CGRectMake(SCREEN_WIDTH/2-50, __goodsStorage.frame.origin.y, 100, 20);
    
    __evaluationGoodStar.frame = CGRectMake(SCREEN_WIDTH-110, __goodsSalenum.frame.origin.y, 100, 20);

}
-(void)addTheValue:(LBGoodsDetailModel *)model
{
    self._goodsName.text = model.goods_info.goods_name;
    self._goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_info.goods_marketprice];
    self._goodsPromotionPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_info.goods_price];
    NSString *yushou = model.goods_info.is_presell;
    if ([yushou isEqualToString:@"1"]) {
        yushou = @"预售商品";
    }else{
        yushou = @"新品";
    }
    self._goodsTitle.text = yushou;
    self._goodsStorage.text = [NSString stringWithFormat:@"库存:%@",model.goods_info.goods_storage];
    self._goodsSalenum.text = [NSString stringWithFormat:@"销量:%@件",model.goods_info.goods_salenum];
    self._evaluationGoodStar.text = [NSString stringWithFormat:@"运费:%@",model.goods_info.goods_freight];
    
}

@end
