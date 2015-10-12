//
//  LBwayCell.m
//  SuGeMarket
//
//  Created by Apple on 15/7/21.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBwayCell.h"
#import "UtilsMacro.h"
@implementation LBwayCell
@synthesize wayLabel;
@synthesize invoiceLabel;
@synthesize detailwayLabel;
@synthesize messageLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initwayCell];
    }
    return self;
}

- (void)initwayCell
{
    //支付方式
    wayLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,5, 200, 35)];
    wayLabel.font = [UIFont systemFontOfSize:15];
    wayLabel.textColor = [UIColor blackColor];
    wayLabel.textAlignment = NSTextAlignmentLeft;
    wayLabel.text=@"支付方式";
    [self addSubview:wayLabel];
    //发票信息
    invoiceLabel=[[UILabel alloc]initWithFrame:CGRectMake(wayLabel.frame.origin.x,wayLabel.frame.origin.y+wayLabel.frame.size.height, SCREEN_WIDTH, 35)];
    invoiceLabel.font = [UIFont systemFontOfSize:15];
    invoiceLabel.textColor = [UIColor blackColor];
    invoiceLabel.textAlignment = NSTextAlignmentLeft;
    invoiceLabel.text=@"发票信息";
    [self addSubview:invoiceLabel];
    //在线支付
    detailwayLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-110,wayLabel.frame.origin.y, 100, 35)];
    detailwayLabel.font = [UIFont systemFontOfSize:15];
    detailwayLabel.textColor = [UIColor blackColor];
    detailwayLabel.textAlignment = NSTextAlignmentRight;
    detailwayLabel.text=@"在线支付";
    [self addSubview:detailwayLabel];
    //不开发票
    messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(detailwayLabel.frame.origin.x,invoiceLabel.frame.origin.y, 100, 35)];
    messageLabel.font = [UIFont systemFontOfSize:15];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentRight;
    messageLabel.text=@"不开发票";
    [self addSubview:messageLabel];

}
- (void)addValue:(LBOrderDetailModel *)model
{
    NSString *inv =model.invoice_info;
    if (inv.length == 0) {
    inv = @"暂无发票";
    }
    messageLabel.text = inv;
}

@end
