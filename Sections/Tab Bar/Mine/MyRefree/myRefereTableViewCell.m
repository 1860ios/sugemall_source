//
//  myRefereTableViewCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/9.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "myRefereTableViewCell.h"
#import "UtilsMacro.h"

@implementation myRefereTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initRefereCell];
    }
    return self;
}

- (void)initRefereCell
{
    _refereeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _refereeIcon.frame = CGRectMake(20, 20, 60, 60);
    _refereeIcon.layer.masksToBounds = YES;
    _refereeIcon.layer.cornerRadius  = 30;
    [self.contentView addSubview:_refereeIcon];
    _refereePointsIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _refereePointsIcon.frame = CGRectMake(SCREEN_WIDTH-60, _refereeName.frame.origin.y, 30, 30);
    [self.contentView addSubview:_refereePointsIcon];
//幸运号
    _luckNum = [[UILabel alloc] initWithFrame:CGRectMake(_refereeIcon.frame.origin.x+_refereeIcon.frame.size.width+10, 5, SCREEN_WIDTH-_refereeIcon.frame.origin.x+_refereeIcon.frame.size.width+10-_refereePointsIcon.frame.origin.x+_refereePointsIcon.frame.size.width, 20)];
    [self.contentView addSubview:_luckNum];
    
//昵称
    _refereeName = [[UILabel alloc]initWithFrame:CGRectZero];
    _refereeName.frame = CGRectMake(_refereeIcon.frame.origin.x+_refereeIcon.frame.size.width+10, 30, SCREEN_WIDTH-_refereeIcon.frame.origin.x-_refereeIcon.frame.size.width-10, 30);
    [self.contentView addSubview:_refereeName];
//积分
    _refereePoints = [[UILabel alloc]initWithFrame:CGRectZero];

    _refereePoints.frame = CGRectMake(_refereePointsIcon.frame.origin.x+_refereePointsIcon.frame.size.width, _refereePointsIcon.frame.origin.y, 50, 30);
    [self.contentView addSubview:_refereePoints];
//加入时间
    _joinTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _joinTime.frame = CGRectMake(_refereeName.frame.origin.x, _refereeName.frame.origin.y+_refereeName.frame.size.height+10, 250, 30);
    [self.contentView addSubview:_joinTime];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(_refereeName.frame.origin.x, _refereeName.frame.origin.y+_refereeName.frame.size.height+5, SCREEN_WIDTH-_refereeName.frame.origin.x-10, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line1];

}



@end
