//
//  LBHomeViewCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/28.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBHomeViewCell.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>

@implementation LBHomeViewCell
@synthesize goodsImageView;
@synthesize goodsName;
@synthesize goodsPrice;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
           [self loadHomeViewCell];
    }
    return self;
}

- (void)loadHomeViewCell
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
    
    goodsPrice =  [[UILabel alloc] initWithFrame:CGRectMake(goodsName.frame.origin.x,goodsName.frame.origin.y+goodsName.frame.size.height,goodsName.frame.size.width,20)];
    goodsPrice.adjustsFontSizeToFitWidth = YES;
    goodsPrice.textAlignment=NSTextAlignmentCenter;
    goodsPrice.textColor = APP_COLOR;
    [self addSubview:goodsPrice];
    
}
- (void)addValueForCell:(NSDictionary *)value
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:value[@"goods_image"]] placeholderImage:IMAGE(@"dd_03_@2x")];
    goodsName.text = value[@"goods_name"];
    goodsPrice.text = [NSString stringWithFormat:@"促销价:￥%@",value[@"goods_promotion_price"]];
}
- (void)addValueForCell1:(NSDictionary *)value1
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:value1[@"goods_image_url"]] placeholderImage:nil];
    goodsName.text = value1[@"goods_name"];
    goodsPrice.text = [NSString stringWithFormat:@"促销价:￥%@",value1[@"goods_price"]];
}

@end
