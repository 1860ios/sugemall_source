//
//  LBMyBlotterCell.m
//  SuGeMarket
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBMyBlotterCell.h"
#import "UtilsMacro.h"

@interface LBMyBlotterCell()
{
    NSDictionary *typeDic;
    UILabel *snLabel;
    UILabel *timeLabel;
    UILabel *typeLabel;
    UILabel *wasteLabel;
}

@end

@implementation LBMyBlotterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadMyBlotterCell];
    }
    return self;
}

- (void)loadMyBlotterCell
{
    UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    v1.image = IMAGE(@"liushui3");//绿色liushui2
    [self addSubview:v1];
    //订单号
    snLabel = [[UILabel alloc] initWithFrame:CGRectMake(v1.frame.origin.x+v1.frame.size.width, 0, SCREEN_WIDTH/2, 40)];
    snLabel.numberOfLines = 2;
    snLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:snLabel];
    //时间
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(snLabel.frame.origin.x+snLabel.frame.size.width, 0, SCREEN_WIDTH-snLabel.frame.origin.x-snLabel.frame.size.width-10,20)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    //type

    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(snLabel.frame.origin.x, snLabel.frame.origin.y+snLabel.frame.size.height, snLabel.frame.size.width, 25)];
    typeLabel.numberOfLines = 2;
    [self addSubview:typeLabel];
    //消费
    wasteLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x,typeLabel.frame.origin.y , timeLabel.frame.size.width, 25)];
    wasteLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:wasteLabel];
    
    typeDic = @{@"order_pay":@"下单支付预存款",@"order_freeze":@"下单冻结预存款",@"order_cancel":@"取消订单解冻预存款",@"order_comb_pay":@"下单支付被冻结的预存款",@"recharge":@"充值",@"cash_apply":@"申请提现冻结预存款",@"cash_pay":@"提现成功",@"cash_del":@"取消提现申请，解冻预存款",@"refund":@"退款"};
}

- (void)addValueForBlotterCell1:(NSDictionary *)vlaue
{
    NSString *type1 =vlaue[@"lg_type"];
    snLabel.text = vlaue[@"lg_desc"];
    timeLabel.text = vlaue[@"lg_add_time"];
    typeLabel.text = [typeDic valueForKey:type1];
    wasteLabel.text = vlaue[@"lg_av_amount"];
}
- (void)addValueForBlotterCell2:(NSDictionary *)vlaue
{
//    NSString *type1 =vlaue[@"lg_type"];
    snLabel.text = vlaue[@"pdr_sn"];
    timeLabel.text = vlaue[@"pdr_add_time"];
    typeLabel.text = @"充值订单支付单号";
    wasteLabel.text = vlaue[@"pdr_amount"];
}

@end
