//
//  LBRecordViewCell.h
//  SuGeMarket
//
//  Created by Apple on 15/7/7.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBRecordViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *dataTextField;
@property(nonatomic,strong)UILabel *carnumTextField;
@property(nonatomic,strong)UILabel *drawalTextField;
@property(nonatomic,strong)UILabel *applyTextField;
@property(nonatomic,strong)UILabel *moneyTextField;
@property(nonatomic,strong)UILabel *waitTextField;
@property(nonatomic,strong)UIImageView *dataImageView;
@property(nonatomic,strong)UIImageView *jiantouImageView;
@property(nonatomic,strong)UIView *dataView;
@property(nonatomic,strong)UIView *cardView;
@property(nonatomic,strong)UIView *moneyView;

@end
