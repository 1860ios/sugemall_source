//
//  LBOrderListCell.m
//  MyOrderDemo
//
//  Created by Apple on 15-5-5.
//  Copyright (c) 2015年 Josin_乔. All rights reserved.
//

#import "UtilsMacro.h"
#import "LBOrderListCell.h"

@implementation LBOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    //商品名
    __goods_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
    __goods_name_label.numberOfLines = 2;
    __goods_name_label.font = FONT(14);
//    __goods_name_label.adjustsFontSizeToFitWidth = YES;
    __goods_num_label.textColor = [UIColor blackColor];
    [self.contentView addSubview:__goods_name_label];
    //商品数量
    __goods_num_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __goods_num_label.textAlignment = NSTextAlignmentRight;
    __goods_num_label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:__goods_num_label];
    //订单总价
    __order_amount_label = [[UILabel alloc] initWithFrame:CGRectZero];
    __order_amount_label.textAlignment = NSTextAlignmentCenter;
    __order_amount_label.adjustsFontSizeToFitWidth = YES;
    __order_amount_label.textColor = APP_COLOR;
    [self.contentView addSubview:__order_amount_label];
    //状态
    __state_desc_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __state_desc_label.textAlignment = NSTextAlignmentRight;
    __state_desc_label.adjustsFontSizeToFitWidth = YES;
    __state_desc_label.textColor = APP_COLOR;
    [self.contentView addSubview:__state_desc_label];
    
    //运费
    __shipping_fee_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __shipping_fee_label.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:__shipping_fee_label];
    UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    storeIcon.image = IMAGE(@"store_image");
    [self.contentView addSubview:storeIcon];
    //店铺名
    __store_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
//    __store_name_label.adjustsFontSizeToFitWidth = YES;
    __store_name_label.font = FONT(15);
    [self.contentView addSubview:__store_name_label];
    //商品单价
    __goods_price_label =[[UILabel alloc] initWithFrame:CGRectZero];
//    __goods_price_label.adjustsFontSizeToFitWidth = YES;
//    __goods_price_label.font = [UIFont boldSystemFontOfSize:15];
    [__goods_price_label sizeToFit];
    
    [self.contentView addSubview:__goods_price_label];
    //图
    __goods_image_view = [[UIImageView alloc] initWithFrame:CGRectZero];
    __goods_image_view.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:__goods_image_view];
    /*
    //
    __orderPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [__orderPay setTitle:@"去支付" forState:0];
    [__orderPay setTitleColor:[UIColor redColor] forState:0];
    __orderPay.layer.borderColor = [APP_COLOR CGColor];
    __orderPay.layer.borderWidth = 1;
    __orderPay.layer.masksToBounds = YES;
    __orderPay.layer.cornerRadius = 4;
    __orderPay.tag = ORDER_BTN_TAG;
    __orderPay.hidden = YES;
    [self addSubview:__orderPay];
     */

    __orderCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [__orderCancel setTitle:@"取消订单" forState:0];
    [__orderCancel setTitleColor:[UIColor darkGrayColor] forState:0];
    __orderCancel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    __orderCancel.layer.borderWidth = 1;
    __orderCancel.layer.masksToBounds = YES;
    __orderCancel.layer.cornerRadius = 4;
    __orderCancel.hidden = YES;
    __orderCancel.tag = ORDER_BTN_TAG+1;
    [self addSubview:__orderCancel];

    __searchDeliver = [UIButton buttonWithType:UIButtonTypeCustom];
    [__searchDeliver setTitle:@"查询物流" forState:0];
    [__searchDeliver setTitleColor:[UIColor redColor] forState:0];
    __searchDeliver.layer.borderColor = [[UIColor redColor] CGColor];
    __searchDeliver.layer.borderWidth = 1;
    __searchDeliver.layer.masksToBounds = YES;
    __searchDeliver.layer.cornerRadius = 4;
    __searchDeliver.hidden = YES;
    __searchDeliver.tag = ORDER_BTN_TAG+2;
    [self addSubview:__searchDeliver];
    
    __orderReciver = [UIButton buttonWithType:UIButtonTypeCustom];
    [__orderReciver setTitle:@"确认收货" forState:0];
    [__orderReciver setTitleColor:[UIColor redColor] forState:0];
    __orderReciver.layer.borderColor = [APP_COLOR CGColor];
    __orderReciver.layer.borderWidth = 1;
    __orderReciver.layer.masksToBounds = YES;
    __orderReciver.layer.cornerRadius = 4;
    __orderReciver.hidden = YES;
    __orderReciver.tag = ORDER_BTN_TAG+3;
    [self addSubview:__orderReciver];

    //1.
    __store_name_label.frame = CGRectMake(storeIcon.frame.origin.x+storeIcon.frame.size.width+5, storeIcon.frame.origin.y, 200, 20);
    //2.
    __state_desc_label.frame = CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2-20, 20);
    //3.
    __goods_image_view.frame = CGRectMake(10, __store_name_label.frame.origin.y+__store_name_label.frame.size.height+5, 80, 80);
    //4.
    __goods_name_label.frame = CGRectMake(__goods_image_view.frame.origin.x+__goods_image_view.frame.size.width+10, __goods_image_view.frame.origin.y, SCREEN_WIDTH-__goods_image_view.frame.origin.x-__goods_image_view.frame.size.width-30, 40);
    //5.
    __shipping_fee_label.frame = CGRectMake(__goods_name_label.frame.origin.x, __goods_name_label.frame.origin.y+__goods_name_label.frame.size.height+10, 60, 20);
    //6.
    __goods_price_label.frame = CGRectMake(__shipping_fee_label.frame.origin.x+__shipping_fee_label.frame.origin.y+5, __shipping_fee_label.frame.origin.y, 100, 20);
    //7.
    __goods_num_label.frame = CGRectMake(__goods_price_label.frame.origin.x+__goods_price_label.frame.origin.y+5, __goods_price_label.frame.origin.y, 30, 20);
    //8.
    __order_amount_label.frame = CGRectMake(__goods_image_view.frame.origin.x, __goods_image_view.frame.origin.y+__goods_image_view.frame.size.height+5, __goods_image_view.frame.size.width, 30);
    
    //b1
    __orderCancel.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/4- 20, __order_amount_label.frame.origin.y, SCREEN_WIDTH/4, 30);
    //b2
    //    __orderPay.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/4- 20, __order_amount_label.frame.origin.y, SCREEN_WIDTH/4, 30);
    
    //b3
    __searchDeliver.frame = CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/8, __order_amount_label.frame.origin.y, SCREEN_WIDTH/4, 30);
    //b4
    __orderReciver.frame = CGRectMake(__searchDeliver.frame.origin.x+__searchDeliver.frame.size.width + 20, __order_amount_label.frame.origin.y,SCREEN_WIDTH/4, 30);

}



@end
