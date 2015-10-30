//
//  LBGroupBuyCell.m
//  SuGeMarket
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBGroupBuyGoodsCell.h"
#import "MZTimerLabel.h"
#import "UtilsMacro.h"
#import "AppMacro.h"

@interface LBGroupBuyGoodsCell ()
{
    UILabel *_goods_name_label;
    UILabel *_goods_price_label;
    UILabel *_groupbuy_price_label;
    UILabel *_xianshi_label;
    UILabel *_juli_label;
    MZTimerLabel *_qianggou_timer;
    UILabel *_qianggou_timer_label;
}
@end

@implementation LBGroupBuyGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addGroupBuyGoodsCell];
    }
    return self;
}

- (void)addGroupBuyGoodsCell
{
    _goods_name_label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    _goods_name_label.numberOfLines = 0;
    _goods_name_label.font = FONT(19);
    [self addSubview:_goods_name_label];
    
    _groupbuy_price_label = [[UILabel alloc] initWithFrame:CGRectMake(0, _goods_name_label.frame.origin.y+_goods_name_label.frame.size.height, SCREEN_WIDTH/2, 40)];
    _groupbuy_price_label.textAlignment = NSTextAlignmentRight;
    _groupbuy_price_label.font = FONT(28);
    [self addSubview:_groupbuy_price_label];
    
    _goods_price_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _groupbuy_price_label.frame.origin.y+10, 100, 20)];
    _goods_price_label.textColor = [UIColor lightGrayColor];
    _goods_price_label.textAlignment = NSTextAlignmentLeft;
    _goods_price_label.font = FONT(15);
    [self addSubview:_goods_price_label];
    
    _xianshi_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, _groupbuy_price_label.frame.origin.y+_groupbuy_price_label.frame.size.height+5, 80, 20)];
    _xianshi_label.text = @"限时抢购";
    _xianshi_label.layer.cornerRadius = 3;
    _xianshi_label.layer.masksToBounds = YES;
    _xianshi_label.textColor = [UIColor whiteColor];
    _xianshi_label.backgroundColor = APP_COLOR;
    _xianshi_label.textAlignment = NSTextAlignmentCenter;
    _xianshi_label.font = FONT(18);
    [self addSubview:_xianshi_label];
    
    _juli_label = [[UILabel alloc] initWithFrame:CGRectMake(0, _xianshi_label.frame.origin.y+_xianshi_label.frame.size.height+10, SCREEN_WIDTH/2, 20)];
    _juli_label.textAlignment = NSTextAlignmentRight;
    _juli_label.font = FONT(18);
    [self addSubview:_juli_label];
    
    _qianggou_timer_label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _juli_label.frame.origin.y, 100, 20)];
    _qianggou_timer = [[MZTimerLabel alloc] initWithLabel:_qianggou_timer_label andTimerType:MZTimerLabelTypeTimer];
    [_qianggou_timer start];
    [self addSubview:_qianggou_timer_label];
}


- (void)addValueForGroupBuyGoodsCell:(NSDictionary *)value
{
    _goods_name_label.text = value[@"groupbuy_intro"];
    _goods_price_label.text = [NSString stringWithFormat:@"￥%@",value[@"goods_price"]];
    _groupbuy_price_label.text = [NSString stringWithFormat:@"￥%@",value[@"groupbuy_price"]];
    _juli_label.text =[NSString stringWithFormat:@"%@ ,", value[@"count_down_text"]];
    NSString *count_don =  value[@"count_down"];
    float count_don_1 = [count_don floatValue];
    [_qianggou_timer setCountDownTime:count_don_1];
    [_qianggou_timer start];
    NSString *button_text = value[@"button_text"];
    if ([button_text isEqualToString:@"即将开始"]) {
        if (count_don_1!=0) {
            [NSTimer scheduledTimerWithTimeInterval:count_don_1 target:self selector:@selector(postNotReleaseButton:) userInfo:nil repeats:YES];
        }
    }
}
- (void)postNotReleaseButton:(NSNotification *)not
{
    [NOTIFICATION_CENTER postNotificationName:@"postNotReleaseButton" object:nil];
}

@end
