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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(5,0, SCREEN_WIDTH-10,230)];
    view.layer.cornerRadius=3;
    view.backgroundColor=[UIColor whiteColor];
    view.layer.borderColor = [[UIColor colorWithWhite:0.88 alpha:0.93] CGColor];
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    [self.contentView addSubview:view];
    
    
    //商品名
    __goods_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
    __goods_name_label.numberOfLines = 2;
    __goods_name_label.font = FONT(14);
//    __goods_name_label.adjustsFontSizeToFitWidth = YES;
    __goods_num_label.textColor = [UIColor blackColor];
    [view addSubview:__goods_name_label];
    //商品数量
    __goods_num_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __goods_num_label.textAlignment = NSTextAlignmentRight;
    __goods_num_label.adjustsFontSizeToFitWidth = YES;
    __goods_num_label.textColor=[UIColor lightGrayColor];
    [view addSubview:__goods_num_label];
    //订单总价
    __order_amount_label = [[UILabel alloc] initWithFrame:CGRectZero];
    __order_amount_label.adjustsFontSizeToFitWidth = YES;
    __order_amount_label.textColor = APP_COLOR;
    __order_amount_label.textAlignment=NSTextAlignmentRight;
    [view addSubview:__order_amount_label];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [view addSubview:view1];
    //状态
    __state_desc_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __state_desc_label.textAlignment = NSTextAlignmentLeft;
    __state_desc_label.adjustsFontSizeToFitWidth = YES;
    __state_desc_label.textColor = APP_COLOR;
    __state_desc_label.font = FONT(12);
    [view1 addSubview:__state_desc_label];
    
    __goods_number_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __goods_number_label.textAlignment = NSTextAlignmentRight;
    __goods_number_label.adjustsFontSizeToFitWidth = YES;
    __goods_number_label.textColor = [UIColor lightGrayColor];
    [view1 addSubview:__goods_number_label];

    //运费
    __shipping_fee_label =[[UILabel alloc] initWithFrame:CGRectZero];
    __shipping_fee_label.adjustsFontSizeToFitWidth = YES;
    __shipping_fee_label.textColor = APP_COLOR;
    [view addSubview:__shipping_fee_label];
//    UIImageView *storeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
//    storeIcon.image = IMAGE(@"store_image");
//    [self.contentView addSubview:storeIcon];
    //店铺名
    __store_name_label = [[UILabel alloc] initWithFrame:CGRectZero];
//    __store_name_label.adjustsFontSizeToFitWidth = YES;
    __store_name_label.font = FONT(15);
    __store_name_label.textColor=[UIColor lightGrayColor];
    [view addSubview:__store_name_label];
    
    
    //商品单价
    __goods_price_label =[[UILabel alloc] initWithFrame:CGRectZero];
//    __goods_price_label.adjustsFontSizeToFitWidth = YES;
//    __goods_price_label.font = [UIFont boldSystemFontOfSize:15];
    __goods_price_label.textAlignment=NSTextAlignmentRight;
    [__goods_price_label sizeToFit];
    
    [view addSubview:__goods_price_label];
    //图
    __goods_image_view = [[UIImageView alloc] initWithFrame:CGRectZero];
    __goods_image_view.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:__goods_image_view];
    

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
    __orderCancel.titleLabel.font=FONT(13);
    __orderCancel.layer.masksToBounds = YES;
    __orderCancel.hidden = YES;
    __orderCancel.tag = ORDER_BTN_TAG+1;
    [view addSubview:__orderCancel];

    __searchDeliver = [UIButton buttonWithType:UIButtonTypeCustom];
    [__searchDeliver setTitle:@"查询物流" forState:0];
    [__searchDeliver setTitleColor:[UIColor redColor] forState:0];
    __searchDeliver.layer.borderColor = [[UIColor colorWithWhite:0.93 alpha:0.93] CGColor];
    __searchDeliver.layer.borderWidth = 1;
    __searchDeliver.titleLabel.font=FONT(13);
    __searchDeliver.layer.masksToBounds = YES;
    __searchDeliver.hidden = YES;
    __searchDeliver.tag = ORDER_BTN_TAG+2;
    [view addSubview:__searchDeliver];
    
    __orderReciver = [UIButton buttonWithType:UIButtonTypeCustom];
    [__orderReciver setTitle:@"确认收货" forState:0];
    [__orderReciver setTitleColor:[UIColor whiteColor] forState:0];
    __orderReciver.backgroundColor =APP_COLOR;
    __orderReciver.layer.borderWidth = 1;
    __orderReciver.layer.masksToBounds = YES;
    __orderReciver.hidden = YES;
    __orderReciver.titleLabel.font=FONT(13);
    __orderReciver.tag = ORDER_BTN_TAG+3;
    [view addSubview:__orderReciver];

    //2.
    __state_desc_label.frame = CGRectMake(20, 5,100, 20);
    __goods_number_label.frame = CGRectMake(SCREEN_WIDTH-200-15,__state_desc_label.frame.origin.y,200, 20);
    //1.
    __store_name_label.frame = CGRectMake(15,view1.frame.origin.y+view1.frame.size.height, SCREEN_WIDTH, 20);
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x,__store_name_label.frame.origin.y+__store_name_label.frame.size.height+5, SCREEN_WIDTH-10, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [view addSubview:lineView];

    //3.
    __goods_image_view.frame = CGRectMake(10, lineView.frame.origin.y+lineView.frame.size.height+5, 80, 80);
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(lineView.frame.origin.x,__goods_image_view.frame.origin.y+__goods_image_view.frame.size.height+10, SCREEN_WIDTH-10, 1)];
    lineView1.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [view addSubview:lineView1];
    
    //4.
    __goods_name_label.frame = CGRectMake(__goods_image_view.frame.origin.x+__goods_image_view.frame.size.width+10, __goods_image_view.frame.origin.y, SCREEN_WIDTH-__goods_image_view.frame.origin.x-__goods_image_view.frame.size.width-20, 40);

    //7.
    __goods_price_label.frame = CGRectMake(SCREEN_WIDTH-100-20, __goods_name_label.frame.origin.y+__goods_name_label.frame.size.height-3, 100, 20);
    //6.
    __goods_num_label.frame = CGRectMake(__goods_price_label.frame.origin.x, __goods_price_label.frame.origin.y+__goods_price_label.frame.size.height, __goods_price_label.frame.size.width, 20);

    //8.
    __order_amount_label.frame = CGRectMake(SCREEN_WIDTH-150-20, __goods_num_label.frame.origin.y+__goods_num_label.frame.size.height+15, 150, 30);
    //5.
    __shipping_fee_label.frame = CGRectMake(__order_amount_label.frame.origin.x-10, __order_amount_label.frame.origin.y, 60, 30);
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(lineView.frame.origin.x,__order_amount_label.frame.origin.y+__order_amount_label.frame.size.height+10, SCREEN_WIDTH-10, 1)];
    lineView2.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [view addSubview:lineView2];
    
    //b1
    __orderCancel.frame = CGRectMake(SCREEN_WIDTH - 120-25, lineView2.frame.origin.y+lineView2.frame.size.height+5, 60, 25);
    //b2
    //    __orderPay.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/4- 20, __order_amount_label.frame.origin.y, SCREEN_WIDTH/4, 30);

    //b4
    __orderReciver.frame = CGRectMake(SCREEN_WIDTH-__orderReciver.frame.size.width-10, __orderCancel.frame.origin.y,__orderCancel.frame.size.width,  __orderCancel.frame.size.height);
    //b3
    __searchDeliver.frame = CGRectMake(__orderReciver.frame.origin.x-__orderReciver.frame.size.width-10, __orderCancel.frame.origin.y, __orderReciver.frame.size.width, __orderCancel.frame.size.height);
}



@end
