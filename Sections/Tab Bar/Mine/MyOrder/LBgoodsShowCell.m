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
    
    _refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refundButton.frame = CGRectMake(showLabel.frame.origin.x,showLabel.frame.origin.y+showLabel.frame.size.height+10, 80, 20);
    [_refundButton setTitle:@"退款/退货" forState:0];
    _refundButton.titleLabel.font=FONT(15);
    [_refundButton setTitleColor:[UIColor darkGrayColor] forState:0];
    _refundButton.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:_refundButton];
    _refundButton.hidden = YES;
    //查看物流
    _searchDeliver = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchDeliver.frame = CGRectMake(_refundButton.frame.origin.x+_refundButton.frame.size.width+5,_refundButton.frame.origin.y, _refundButton.frame.size.width, _refundButton.frame.size.height);
    _searchDeliver.layer.masksToBounds = YES;
    _searchDeliver.titleLabel.font=FONT(15);
    _searchDeliver.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [_searchDeliver setTitle:@"查看物流" forState:0];
    [_searchDeliver setTitleColor:[UIColor darkGrayColor] forState:0];
    [self addSubview:_searchDeliver];
    _searchDeliver.hidden = YES;
    //取消订单
    _orderCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_orderCancel setTitle:@"取消订单" forState:0];
    _orderCancel.frame = CGRectMake(showLabel.frame.origin.x,_refundButton.frame.origin.y, _refundButton.frame.size.width, _refundButton.frame.size.height);
    [_orderCancel setTitleColor:[UIColor darkGrayColor] forState:0];
    _orderCancel.titleLabel.font=FONT(15);
    _orderCancel.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    _orderCancel.layer.masksToBounds = YES;
    [self addSubview:_orderCancel];
    _orderCancel.hidden = YES;

    
    //确认收货
    _orderReciver = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderReciver.frame = CGRectMake(_searchDeliver.frame.origin.x+_searchDeliver.frame.size.width, _orderCancel.frame.origin.y, _refundButton.frame.size.width,  _refundButton.frame.size.height);
    [_orderReciver setTitle:@"确认收货" forState:0];
    [_orderReciver setTitleColor:APP_COLOR forState:0];
    _orderCancel.titleLabel.textColor=[UIColor blackColor];
    _orderCancel.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    _orderReciver.titleLabel.font=FONT(15);
    //    __orderReciver.layer.masksToBounds = YES;
    // __orderReciver.tag = ORDER_BTN_TAG+3;
    [self addSubview:_orderReciver];
    _orderReciver.hidden = YES;

    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, goodsImageView.frame.origin.y+goodsImageView.frame.size.height+5, SCREEN_WIDTH-20, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:lineView];
    
    moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160,showLabel.frame.origin.y,150,30)];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
    
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-75,moneyLabel.frame.origin.y+moneyLabel.frame.size.height,65,30)];
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.textColor = [UIColor grayColor];
    numLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:numLabel];
    
    UILabel *totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,lineView.frame.origin.y+5,100,30)];
    totalLabel.font = [UIFont systemFontOfSize:15];
    totalLabel.textColor = [UIColor blackColor];
    totalLabel.text=@"价格合计:";
    totalLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:totalLabel];
    
    _totalMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-210,totalLabel.frame.origin.y+totalLabel.frame.size.height+5,200,30)];
    _totalMoneyLabel.font = [UIFont systemFontOfSize:15];
    _totalMoneyLabel.textColor = [UIColor blackColor];
    _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_totalMoneyLabel];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10, totalLabel.frame.origin.y+totalLabel.frame.size.height+5, SCREEN_WIDTH-20, 1)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self addSubview:lineView1];
    
    _orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(totalLabel.frame.origin.x,lineView1.frame.origin.y+5, SCREEN_WIDTH-20, 30)];
    _orderLabel.font = [UIFont systemFontOfSize:15];
    _orderLabel.textColor = [UIColor grayColor];
    _orderLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_orderLabel];
    
    _tradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_orderLabel.frame.origin.x,_orderLabel.frame.origin.y+_orderLabel.frame.size.height, SCREEN_WIDTH-20, 30)];
    _tradeLabel.font = [UIFont systemFontOfSize:15];
    _tradeLabel.textColor = [UIColor grayColor];
    _tradeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_tradeLabel];
    
    _orderLabel1=[[UILabel alloc]initWithFrame:CGRectMake(_tradeLabel.frame.origin.x,_tradeLabel.frame.origin.y+_tradeLabel.frame.size.height, SCREEN_WIDTH-20, 30)];
    _orderLabel1.font = [UIFont systemFontOfSize:15];
    _orderLabel1.textColor = [UIColor grayColor];
    _orderLabel1.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_orderLabel1];

    
}

- (void)addValue:(LBOrderDetailGoodsModel *)model goodsModel:(LBOrderDetailModel *)goodsModel
{
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:IMAGE(@"")];
        showLabel.text = model.goods_name;
        moneyLabel.text=[NSString stringWithFormat:@"单价:%@",model.goods_pay_price];
//        preferentialLabel.text=;
        numLabel.text=[NSString stringWithFormat:@"X %@",model.goods_num];
    
    if ([goodsModel.state_desc isEqualToString:@"待付款"]) {
        _orderCancel.hidden = NO;
    }else if ([goodsModel.state_desc isEqualToString:@"已支付"]){
        _refundButton.hidden = NO;
//        _refundButton.frame = CGRectMake(bottomView.center.x-32, 0, 64, 49);
    }else if ([goodsModel.state_desc isEqualToString:@"待收货"]){
        _refundButton.hidden = NO;
        _searchDeliver.hidden = NO;
//        _orderReciver.hidden = NO;
    }else if ([goodsModel.state_desc isEqualToString:@"交易完成"]){
        _refundButton.hidden = NO;
    }
}


@end
