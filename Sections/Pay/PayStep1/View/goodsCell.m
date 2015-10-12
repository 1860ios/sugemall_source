//
//  goodsCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "goodsCell.h"
#import <UIImageView+WebCache.h>
#import "UtilsMacro.h"

@implementation goodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initGoodsCell];
    }
    return self;
}

- (void)initGoodsCell
{
    _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_goodsImage];
    
    _goodsName = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.frame.origin.x+_goodsImage.frame.size.width+5, _goodsImage.frame.origin.y, SCREEN_WIDTH-_goodsImage.frame.origin.x-_goodsImage.frame.size.width-10, 40)];
    _goodsName.font = FONT(15);
    _goodsName.numberOfLines = 2;
    [self addSubview:_goodsName];
    _goodsNum = [[UILabel alloc] initWithFrame:CGRectMake(_goodsName.frame.origin.x, _goodsName.frame.origin.y+_goodsName.frame.size.height, 100, 30)];
    [self addSubview:_goodsNum];
    
    //
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, _goodsNum.frame.origin.y, 80, _goodsNum.frame.size.height)];
    [self addSubview:_goodsPrice];
}

- (void)addValue: (LBStep1GoodsListModel *)model
{
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:nil];
    _goodsName.text = model.goods_name;
    _goodsNum.text = [NSString stringWithFormat:@"x%@",model.goods_num];
    _goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
