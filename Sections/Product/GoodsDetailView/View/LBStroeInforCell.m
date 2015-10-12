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
    __storeImage.frame = CGRectMake(10, 10, 60, 60);
    __storeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:__storeImage];
    
    __storeName = [[UILabel alloc] initWithFrame:CGRectZero];//
    __storeName.frame = CGRectMake(__storeImage.frame.origin.x+__storeImage.frame.size.width+10, __storeImage.frame.origin.y, 200, 45);
    __storeName.numberOfLines = 2;
    [self addSubview:__storeName];
    
    UIImageView *_storeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _storeIcon.frame = CGRectMake(SCREEN_WIDTH-30-10, 25, 30, 30);
    _storeIcon.contentMode = UIViewContentModeScaleAspectFit;
    _storeIcon.image = IMAGE(@"jiantou");
    [self addSubview:_storeIcon];
    

}



-(void)addTheValue:(LBGoodsDetailModel *)model
{
    self._storeName.text = model.store_info.store_name;
    [self._storeImage sd_setImageWithURL:[NSURL URLWithString:model.store_info.avatar] placeholderImage:IMAGE(@"dd_03_@2x")];
}

@end
