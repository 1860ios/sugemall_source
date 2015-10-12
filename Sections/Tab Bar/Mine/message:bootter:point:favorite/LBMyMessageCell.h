//
//  LBMyMessageCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/8/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMyMessageCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,copy) UILabel *titleLabel;
@property (nonatomic,copy) UILabel *title;
@property (nonatomic,copy) UILabel *timeLabel;
@property (nonatomic,copy) UILabel *time;
@property (nonatomic,copy) UILabel *content;
-(void)setIntroductionText:(NSString*)text;
@end
