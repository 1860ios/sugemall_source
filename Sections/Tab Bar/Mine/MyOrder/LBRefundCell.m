//
//  LBtableViewCellTableViewCell.m
//  SuGeMarket
//
//  Created by Apple on 15/7/17.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//退款/售后

#import "LBRefundCell.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
@implementation LBRefundCell
- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:Style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadorderViewCell];
    }
    return self;
}
-(void)loadorderViewCell
{
    _lineView1=[[UIView alloc]init];
    _lineView1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];
    _lineView2=[[UIView alloc]init];
    _lineView2.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];

    _refundLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0, 300, 20)];
    _refundLabel.font = [UIFont systemFontOfSize:12];
    _refundLabel.textColor = [UIColor blackColor];
    _refundLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_refundLabel];
    
    _orderidLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,20, 300, 20)];
    _orderidLabel.font = [UIFont systemFontOfSize:12];
    _orderidLabel.textColor = [UIColor blackColor];
    _orderidLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_orderidLabel];

    _lineView1.frame=CGRectMake(0, _orderidLabel.frame.origin.y+_orderidLabel.frame.size.height, SCREEN_WIDTH, 1);
    [self addSubview:_lineView1];
    //是否处理
    _acceptLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110,_refundLabel.frame.origin.y, 100, 40 )];
    _acceptLabel.font = [UIFont systemFontOfSize:16];
    _acceptLabel.textColor = APP_COLOR;
    _acceptLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_acceptLabel];
    //商品图片
    _goodImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_orderidLabel.frame.origin.x,_lineView1.frame.origin.y+_lineView1.frame.size.height+10, 115, 115)];
    [self addSubview:_goodImageView];
    //商品名称
    _showLabel=[[UILabel alloc]initWithFrame:CGRectMake(_goodImageView.frame.origin.x+_goodImageView.frame.size.width+10,_goodImageView.frame.origin.y-10, SCREEN_WIDTH-_goodImageView.frame.origin.x-_goodImageView.frame.size.width-20, 60)];
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.textAlignment = NSTextAlignmentLeft;
    [_showLabel setNumberOfLines:2];
    [self addSubview:_showLabel];
   //商品数量
    _goodsnumLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60,_showLabel.frame.origin.y+_showLabel.frame.size.height+10, 50, 35)];
    _goodsnumLabel.font = [UIFont systemFontOfSize:15];
    _goodsnumLabel.textColor = [UIColor blackColor];
    _goodsnumLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_goodsnumLabel];
    //退货金额
    _tradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-310,_goodsnumLabel.frame.origin.y+_goodsnumLabel.frame.size.height+10, 300, 40)];
    _tradeLabel.font = [UIFont systemFontOfSize:16];
    _tradeLabel.textColor = [UIColor blackColor];
    _tradeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_tradeLabel];

    _lineView2.frame=CGRectMake(0, _tradeLabel.frame.origin.y+_tradeLabel.frame.size.height, SCREEN_WIDTH, 1);
    [self addSubview:_lineView2];
//#warning //查看进度
//    //查看进度
//    _viewprogressButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _viewprogressButton.frame = CGRectMake(SCREEN_WIDTH-90,_lineView2.frame.origin.y+_lineView2.frame.size.height+10, 80, 35);
//    _viewprogressButton.titleLabel.font = [UIFont systemFontOfSize:12];
//    [_viewprogressButton setTitle:@"查看进度" forState:0];
//    [_viewprogressButton setTitleColor:[UIColor whiteColor] forState:0];
//    _viewprogressButton.backgroundColor=[UIColor redColor];
//    [self addSubview:_viewprogressButton];
}

@end
