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
    UIImageView *houseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    houseImageView.image=IMAGE(@"store_icon");
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:houseImageView];
    
    UILabel *zixunLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-35, houseImageView.frame.origin.y, 30,30)];
    zixunLabel.text=@"咨询";
    zixunLabel.font=FONT(13);
    zixunLabel.textColor=[UIColor grayColor];
    [self addSubview:zixunLabel];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(zixunLabel.frame.origin.x-20, zixunLabel.frame.origin.y+5, 20, 20);
    [button setImage:IMAGE(@"确认订单无地址_07") forState:0];
    [self addSubview:button];
    
    _storeName = [[UILabel alloc] initWithFrame:CGRectMake(houseImageView.frame.origin.x+houseImageView.frame.size.width+10, houseImageView.frame.origin.y,SCREEN_WIDTH-20-houseImageView.frame.size.width-button.frame.size.width, 30)];
    _storeName.font = FONT(13);
    [self addSubview:_storeName];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, houseImageView.frame.origin.y+houseImageView.frame.size.height, SCREEN_WIDTH-20, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:lineView];
    
    _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(houseImageView.frame.origin.x,houseImageView.frame.origin.y+houseImageView.frame.size.height+10, 60, 60)];
    _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImage.backgroundColor=[UIColor redColor];
    [self addSubview:_goodsImage];
    
    _goodsName = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.frame.origin.x+_goodsImage.frame.size.width+5, _goodsImage.frame.origin.y, SCREEN_WIDTH-_goodsImage.frame.origin.x-_goodsImage.frame.size.width-10-100, 40)];
    _goodsName.font = FONT(13);
    _goodsName.numberOfLines = 2;
    [self addSubview:_goodsName];
    
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-150, _goodsName.frame.origin.y,150, 30)];
    _goodsPrice.textAlignment=NSTextAlignmentRight;
    [self addSubview:_goodsPrice];
    
    _goodsNum = [[UILabel alloc] initWithFrame:CGRectMake(_goodsPrice.frame.origin.x, _goodsPrice.frame.origin.y+_goodsPrice.frame.size.height, 150, 30)];
    _goodsNum.textAlignment=NSTextAlignmentRight;
    [self addSubview:_goodsNum];
    
    //

    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(_goodsImage.frame.origin.x, _goodsImage.frame.origin.y+_goodsImage.frame.size.height+7, SCREEN_WIDTH-20, 1)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:lineView1];
    
    UILabel *freightLabel=[[UILabel alloc]initWithFrame:CGRectMake(lineView1.frame.origin.x, lineView1.frame.origin.y+5, 100,30)];
    freightLabel.text=@"快递运费:";
    freightLabel.font=FONT(15);
    freightLabel.textColor=[UIColor grayColor];
    [self addSubview:freightLabel];
    
    _freightPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, freightLabel.frame.origin.y, 200, freightLabel.frame.size.height)];
    _freightPrice.textAlignment=NSTextAlignmentRight;
    [self addSubview:_freightPrice];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(freightLabel.frame.origin.x, freightLabel.frame.origin.y+freightLabel.frame.size.height, SCREEN_WIDTH-20, 1)];
    lineView2.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:lineView2];
    
    UILabel *allLabel=[[UILabel alloc]initWithFrame:CGRectMake(freightLabel.frame.origin.x, freightLabel.frame.origin.y+freightLabel.frame.size.height, 100,30)];
    allLabel.text=@"价格合计:";
    allLabel.textColor=[UIColor grayColor];
    allLabel.font=FONT(15);
    [self addSubview:allLabel];
    
    _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, allLabel.frame.origin.y, 200, allLabel.frame.size.height)];
    _totalPrice.textAlignment=NSTextAlignmentRight;
    [self addSubview:_totalPrice];
}

- (void)addValue: (LBStep1GoodsListModel *)model
{
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:nil];
    _goodsName.text = model.goods_name;
    _goodsNum.text = [NSString stringWithFormat:@"x%@",model.goods_num];
    _goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    _storeName.text=[NSString stringWithFormat:@"%@",model.store_name];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
