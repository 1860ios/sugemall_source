//
//  LBRecordViewCell.m
//  SuGeMarket
//  提现记录cell
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBRecordViewCell.h"
#import "UtilsMacro.h"

@implementation LBRecordViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:Style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadwithdrawalViewCell];
    }
    return self;
}
- (void)loadwithdrawalViewCell
{
    _dataView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _dataView.backgroundColor=[UIColor whiteColor];
    
    _dataImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,5 , 25, 25)];
    _dataImageView.image = IMAGE(@"time_01");
    [self.dataView addSubview:_dataImageView];
    
    _jiantouImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30,0, 25, 25)];
    _jiantouImageView.image=[UIImage imageNamed:@"jiantou.png"];
    [self.dataView addSubview:_jiantouImageView];
    
    _dataTextField=[[UILabel alloc]initWithFrame:CGRectMake(_dataImageView.frame.origin.x+_dataImageView.frame.size.width,0, 100, 35)];
    _dataTextField.font = [UIFont systemFontOfSize:15];
    _dataTextField.textColor = [UIColor blackColor];
    _dataTextField.textAlignment = NSTextAlignmentLeft;

    [self.dataView addSubview:_dataTextField];
    [self addSubview:_dataView];
    
    _cardView=[[UIView alloc]initWithFrame:CGRectMake(0,_dataView.frame.origin.y+_dataView.frame.size.height, SCREEN_WIDTH, 50)];
    _cardView.backgroundColor=[UIColor whiteColor];

    _carnumTextField=[[UILabel alloc]initWithFrame:CGRectMake(_dataImageView.frame.origin.x, 0, 150, 35)];
    _carnumTextField.font = [UIFont systemFontOfSize:20];
    _carnumTextField.textColor = [UIColor blackColor];
    _carnumTextField.textAlignment = NSTextAlignmentLeft;

    [self.cardView addSubview:_carnumTextField];
    
    _drawalTextField=[[UILabel alloc]initWithFrame:CGRectMake(_jiantouImageView.frame.origin.x-150,0, 150, 35)];
    _drawalTextField.font = [UIFont systemFontOfSize:20];
    _drawalTextField.textColor = [UIColor blackColor];
    _drawalTextField.textAlignment = NSTextAlignmentLeft;
    [self.cardView addSubview:_drawalTextField];
    [self addSubview:self.cardView];

    _applyTextField=[[UILabel alloc]initWithFrame:CGRectMake(_carnumTextField.frame.origin.x,_cardView.frame.origin.y+30, 250, 25)];
    _applyTextField.font = [UIFont systemFontOfSize:12];
    _applyTextField.textColor = [UIColor blackColor];
    _applyTextField.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_applyTextField];
    
    _moneyView=[[UIView alloc]initWithFrame:CGRectMake(0,_cardView.frame.origin.y+_cardView.frame.size.height, SCREEN_WIDTH, 50)];
    _moneyView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_moneyView];

    _moneyTextField=[[UILabel alloc]initWithFrame:CGRectMake(_carnumTextField.frame.origin.x,15, 100, 35)];
    _moneyTextField.font = [UIFont systemFontOfSize:15];
    _moneyTextField.textColor = APP_COLOR;
    _moneyTextField.textAlignment = NSTextAlignmentLeft;
    [self.moneyView addSubview:_moneyTextField];
    
    _waitTextField=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100,_moneyTextField.frame.origin.y,100, 35)];
    _waitTextField.font = [UIFont systemFontOfSize:15];
    _waitTextField.textColor = APP_COLOR;
    _waitTextField.textAlignment = NSTextAlignmentLeft;
    [self.moneyView addSubview:_waitTextField];


}

@end
