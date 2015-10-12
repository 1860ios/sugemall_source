//
//  LBvoucherTableViewCell.m
//  SuGeMarket
//
//  Created by Apple on 15/7/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBvoucherTableViewCell.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
@implementation LBvoucherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:Style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadvoucherViewCell];
    }
    return self;
}
-(void)loadvoucherViewCell
{
    _voucherImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0 ,100, 100)];
    [self addSubview:_voucherImageView];
    
    _houseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45,0,35, 35)];
    [self addSubview:_houseImageView];

    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(_voucherImageView.frame.origin.x+_voucherImageView.frame.size.width+5,0, 100, 35)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_nameLabel];
    
    _usageModelLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height-10, 200, 35)];
    _usageModelLabel.font = [UIFont systemFontOfSize:12];
    _usageModelLabel.textColor = [UIColor grayColor];
    _usageModelLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_usageModelLabel];
    
    _stateLabel=[[UILabel alloc]initWithFrame:CGRectMake(_usageModelLabel.frame.origin.x,_voucherImageView.frame.size.width-35, 100, 35)];
    _stateLabel.font = [UIFont systemFontOfSize:12];
    _stateLabel.textColor = [UIColor blackColor];
    _stateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_stateLabel];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake( SCREEN_WIDTH-210,_stateLabel.frame.origin.y, 200, 35)];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.textColor = [UIColor blackColor];
    _numLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numLabel];
    
}
@end
