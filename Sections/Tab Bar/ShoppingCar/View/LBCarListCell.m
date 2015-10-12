//
//  LBCarListCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBCarListCell.h"
#import "UtilsMacro.h"
#import "UIImageView+WebCache.h"

@implementation LBCarListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    _storeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 20, 20)];
    _storeImage.image = IMAGE(@"store_image");
    [self.contentView addSubview:_storeImage];
    
    _storeImageJ = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 10, 20, 20)];
    _storeImageJ.image = IMAGE(@"jiantou");
    [self.contentView addSubview:_storeImageJ];
    //商品名
    __goods_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
    __goods_name_label.numberOfLines = 3;
//    __goods_name_label.adjustsFontSizeToFitWidth = YES;
    __goods_name_label.font = FONT(15);
    __goods_num_label.textColor = [UIColor blackColor];
    [self.contentView addSubview:__goods_name_label];

    //小计
    __goods_sum = [[UILabel alloc] initWithFrame:CGRectZero];
    __goods_sum.textAlignment = NSTextAlignmentCenter;
    __goods_sum.adjustsFontSizeToFitWidth = YES;
    __goods_sum.textColor = APP_COLOR;
    [self addSubview:__goods_sum];

    //店铺名
    __store_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
//    __store_name_label.adjustsFontSizeToFitWidth = YES;
    __store_name_label.font = FONT(13);
    [self.contentView addSubview:__store_name_label];
    //商品单价
    __goods_price_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __goods_price_label.adjustsFontSizeToFitWidth = YES;
//    __goods_price_label.font = [UIFont boldSystemFontOfSize:13];;
    [self.contentView addSubview:__goods_price_label];
    //图
    __goods_image_view = [[UIImageView alloc] initWithFrame:CGRectZero];
    __goods_image_view.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:__goods_image_view];
    //减按钮
    __deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    __deleteBtn.frame = CGRectZero;
    __deleteBtn.userInteractionEnabled = YES;
    [__deleteBtn setImage:IMAGE(@"suge_car_num_normal-") forState:UIControlStateNormal];
    [__deleteBtn setImage:IMAGE(@"suge_car_num_select-") forState:UIControlStateHighlighted];
//    __deleteBtn.tag = BTN_NUM_DEL;
    [self addSubview:__deleteBtn];
    
    //购买商品的数量
    __goods_num_label = [[UITextField alloc]initWithFrame:CGRectZero];
    __goods_num_label.textAlignment = NSTextAlignmentCenter;
    __goods_num_label.inputView = nil;
    __goods_num_label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    __goods_num_label.autoresizingMask = UIViewAutoresizingNone;
    __goods_num_label.borderStyle = UITextBorderStyleBezel;
    __goods_num_label.userInteractionEnabled = NO;
    [self addSubview:__goods_num_label];
    
    //加按钮
    __addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    __addBtn.frame = CGRectZero;
    __addBtn.userInteractionEnabled = YES;
    [__addBtn setImage:IMAGE(@"suge_car_num_normal+") forState:UIControlStateNormal];
    [__addBtn setImage:IMAGE(@"suge_car_num_select+") forState:UIControlStateHighlighted];
//    __addBtn.tag = BTN_NUM_ADD;
    [self addSubview:__addBtn];
    
    //是否选中图片
//    _isSelectImg = [[UIImageView alloc]initWithFrame:CGRectZero];
//    [self.contentView addSubview:_isSelectImg];
    //店名
    __store_name_label.frame = CGRectMake(60, 10, 200, 20);
    //图
    __goods_image_view.frame = CGRectMake( 10, __store_name_label.frame.origin.y+__store_name_label.frame.size.height+10, 90, 90);
    //名字
    __goods_name_label.frame = CGRectMake(__goods_image_view.frame.origin.x+__goods_image_view.frame.size.width+5, __goods_image_view.frame.origin.y-10, 130, 65);
    //单价
    __goods_price_label.frame = CGRectMake(__goods_name_label.frame.origin.x, __goods_name_label.frame.origin.y+__goods_name_label.frame.size.height+10, 100, 30);
    //总价
    __goods_sum.frame = CGRectMake(__goods_name_label.frame.origin.x+__goods_name_label.frame.size.width+5, __goods_name_label.frame.origin.y, SCREEN_WIDTH-__goods_name_label.frame.origin.x-__goods_name_label.frame.size.width-5, 35);//
    //减
    __deleteBtn.frame = CGRectMake(SCREEN_WIDTH-105, __goods_sum.frame.origin.y+__goods_sum.frame.size.height+30, 30, 30);
    //数量
    __goods_num_label.frame = CGRectMake(__deleteBtn.frame.origin.x+__deleteBtn.frame.size.width,__deleteBtn.frame.origin.y, 40, 30);
    //加
    __addBtn.frame = CGRectMake(__goods_num_label.frame.origin.x+__goods_num_label.frame.size.width,__goods_num_label.frame.origin.y, 30, 30);

}



/**
 *  给单元格赋值
 *
 *  @param goodsModel 里面存放各个控件需要的数值
 */
-(void)addTheValue:(LBCarListModel *)goodsModel
{
    [__goods_image_view sd_setImageWithURL:[NSURL URLWithString:goodsModel.goods_image_url] placeholderImage:IMAGE(@"dd_03_@2x")];
    __goods_name_label.text = goodsModel.goods_name;
    __goods_price_label.text =[NSString stringWithFormat:@"单价:%@",goodsModel.goods_price];
    __store_name_label.text = goodsModel.store_name;
    __goods_num_label.text = [NSString stringWithFormat:@"%ld",(long)goodsModel.goods_num];
    __goods_sum.text = [NSString stringWithFormat:@"￥%@",goodsModel.goods_sum];
    
//    if (isSelect)
//    {
//        _selectState = YES;
//        _isSelectImg.image = IMAGE(@"syncart_round_check2@2x");
//    }else{
//        _selectState = NO;
//        _isSelectImg.image = IMAGE(@"syncart_round_check1@2x");
//    }
    
}


@end
