//
//  LBStroeInforCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/15.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBStroeInforCell.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

@implementation LBStroeInforCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initStroeInforCell];
    }
    return self;
}

- (void)initStroeInforCell
{
    __storeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    __storeImage.frame = CGRectMake(10, 10, 30, 30);
    __storeImage.contentMode = UIViewContentModeScaleAspectFit;
    __storeImage.image = IMAGE(@"store_icon");
    [self addSubview:__storeImage];
    
    __storeName = [[UILabel alloc] initWithFrame:CGRectZero];//
    __storeName.frame = CGRectMake(__storeImage.frame.origin.x+__storeImage.frame.size.width, __storeImage.frame.origin.y, 200, 30);
    __storeName.numberOfLines = 2;
    [self addSubview:__storeName];
    
    UILabel *gradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(__storeImage.frame.origin.x,__storeImage.frame.origin.y+__storeImage.frame.size.height, 80, 35)];
    gradeLabel.font = [UIFont systemFontOfSize:15];
    gradeLabel.textColor = [UIColor blackColor];
    gradeLabel.textAlignment = NSTextAlignmentLeft;
    gradeLabel.text=@"综合评分:";
    [self addSubview:gradeLabel];
    for (int i = 0; i<5; i++) {
        UIImageView *heartImageView=[[UIImageView alloc]initWithFrame:CGRectMake(gradeLabel.frame.origin.x+gradeLabel.frame.size.width+(35*i),gradeLabel.frame.origin.y,35,35)];
        heartImageView.image = IMAGE(@"heart1");
        [self addSubview:heartImageView];
    }

    self.lianxikefu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lianxikefu.frame = CGRectMake(30, gradeLabel.frame.origin.y+gradeLabel.frame.size.height+15, 120, 30);
    [self.lianxikefu setImage:IMAGE(@"lianxikehu") forState:UIControlStateNormal];
    [self addSubview:self.lianxikefu];

    self.jinrudianpu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jinrudianpu.frame = CGRectMake(SCREEN_WIDTH-30-120, self.lianxikefu.frame.origin.y, 120, 30);
    [self.jinrudianpu setImage:IMAGE(@"jinrudianpu") forState:UIControlStateNormal];
    [self addSubview:self.jinrudianpu];
}



-(void)addTheValue:(LBGoodsDetailModel *)model
{
    self._storeName.text = model.store_info.store_name;
}

@end
