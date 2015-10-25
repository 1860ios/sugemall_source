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
@synthesize goodsImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGoodsListCell];
    }
    return self;
}

- (void)initGoodsListCell
{
    goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    goodsImageView.frame = CGRectMake(10, 10, SCREEN_WIDTH/2-30-10, SCREEN_WIDTH/2-30-10);
    goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:goodsImageView];
    
    UIView *linView =[[UIView alloc]initWithFrame:CGRectMake(0,goodsImageView.frame.origin.y+goodsImageView.frame.size.height+2,SCREEN_WIDTH/2-10 , 0.5)];
    [linView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:linView];
    
    
    goodsName =  [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.frame.origin.x,goodsImageView.frame.origin.y+goodsImageView.frame.size.height,goodsImageView.frame.size.width,45)];
    //    goodsnameLabel.font = FONT(13);
    goodsName.numberOfLines = 2;
    goodsName.textAlignment=NSTextAlignmentCenter;
    [self addSubview:goodsName];
    
    goodsPrice =  [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x,goodsName.frame.origin.y+goodsName.frame.size.height,goodsName.frame.size.width/2,20)];
    goodsPrice.adjustsFontSizeToFitWidth = YES;
    goodsPrice.textColor = APP_COLOR;
    [self addSubview:goodsPrice];

    
}


-(void)addTheValue:(LBGoodsListModel *)goodsListModel
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.goods_image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
    goodsName.text = goodsListModel.goods_name;
    goodsPrice.text = [NSString stringWithFormat:@"￥%@",goodsListModel.goods_price];
//    goodsPrice.text = [NSString stringWithFormat:@"原价:%@",goodsListModel.goods_marketprice];
//    goodsSalenum.text = [NSString stringWithFormat:@"销量:%@",goodsListModel.goods_salenum];
}

@end
