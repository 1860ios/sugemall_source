//
//  myRefereTableViewCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/6/9.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myRefereTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *refereeIcon;//被推荐人头像
@property (strong, nonatomic)  UIImageView *refereePointsIcon;//被推荐人积分头像
@property (retain, nonatomic)  UILabel *refereeName;//被推荐人名字
@property (retain, nonatomic)  UILabel *luckNum;//幸运号
@property (retain, nonatomic)  UILabel *refereePoints;//被推荐人积分
@property (retain, nonatomic)  UILabel *joinTime;//被推荐人加入时间

@end
