//
//  addressCell.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/26.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "addressCell.h"
#import "UtilsMacro.h"


@implementation addressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAddressCell];
    }
    return self;
}
- (void)initAddressCell{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    imageView1.image = [UIImage imageNamed:@"address_1"];
    [self addSubview:imageView1];

    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 21, 30)];
    imageView.image = [UIImage imageNamed:@"address_inf"];
    [self addSubview:imageView];
    //收货人名
    _receiverName = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, 15, 150, 30)];
    [self addSubview:_receiverName];

    //收货人手机号
    _receiverPhone = [[UILabel alloc] initWithFrame:CGRectMake(_receiverName.frame.origin.x+_receiverName.frame.size.width+5, _receiverName.frame.origin.y, SCREEN_WIDTH-_receiverName.frame.origin.x-_receiverName.frame.size.width-20, 30)];
    [self addSubview:_receiverPhone];

    //收货人收货地址
    _receiverAddress = [[UILabel alloc] initWithFrame:CGRectMake(_receiverName.frame.origin.x, _receiverName.frame.origin.y+_receiverName.frame.size.height, SCREEN_WIDTH-20-10, 30)];
    [self addSubview:_receiverAddress];

}
- (void)addValue: (LBBuyStep1Model *)model
{
    /*
     @property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
     @property (weak, nonatomic) IBOutlet UILabel *receiverName;字
     @property (weak, nonatomic) IBOutlet UILabel *receiverPhone;
     @property (weak, nonatomic) IBOutlet UILabel *receiverAddress;
     @property (weak, nonatomic) IBOutlet UILabel *defaultAddress;//判断默认地址，是则显示
     */
    NSString *add = [model.address_info.area_info stringByAppendingString:model.address_info.address];
    _receiverName.text = [NSString stringWithFormat:@"收货人:%@",model.address_info.true_name];
    _receiverPhone.text = [NSString stringWithFormat:@"手机号:%@",model.address_info.mob_phone];
    _receiverAddress.text = [NSString stringWithFormat:@"收货地址:%@",add];

}


@end
