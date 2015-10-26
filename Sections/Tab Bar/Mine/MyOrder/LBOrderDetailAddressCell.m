//
//  LBOrderDetailCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/7/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBOrderDetailAddressCell.h"
#import "UtilsMacro.h"

@implementation LBOrderDetailAddressCell
@synthesize consigneeLabel;
@synthesize dressLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initOrderDetailCell];
    }
    return self;
}

- (void)initOrderDetailCell
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    imageView1.image = [UIImage imageNamed:@"address_1"];
    [self addSubview:imageView1];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 21, 30)];
    imageView.image = [UIImage imageNamed:@"address_inf"];
    [self addSubview:imageView];
    
    //收货人
    consigneeLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, 10, 150, 30)];
    consigneeLabel.font = [UIFont systemFontOfSize:15];
    consigneeLabel.textColor = [UIColor blackColor];
    consigneeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:consigneeLabel];
    //地址
    dressLabel=[[UILabel alloc]initWithFrame:CGRectMake(consigneeLabel.frame.origin.x,consigneeLabel.frame.origin.y+consigneeLabel.frame.size.height-5, SCREEN_WIDTH-10-consigneeLabel.frame.origin.x, 45)];
    dressLabel.font = [UIFont systemFontOfSize:15];
    dressLabel.numberOfLines = 2;
    dressLabel.textColor = [UIColor blackColor];
    dressLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dressLabel];
    
}

- (void)addValue:(LBOrderDetailModel *)model
{
    consigneeLabel.text=[NSString stringWithFormat:@"收货人:%@",model.reciver_name];
    
    dressLabel.text=[NSString stringWithFormat:@"收货地址:%@",model.reciver_info];
    
}

@end
