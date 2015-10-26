//
//  LBOrderListCell.h
//  SuGeMarket
//
//
//  Created by Apple on 15-5-5.
//  Copyright (c) 2015年 Josin_乔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBOrderListCell : UITableViewCell

@property (retain, nonatomic)  UIButton *_orderCancel;
//@property (retain, nonatomic)  UIButton *_orderPay;
@property (retain, nonatomic)  UIButton *_searchDeliver;
@property (retain, nonatomic)  UIButton *_orderReciver;

@property (retain, nonatomic)  UILabel *_goods_num_label;
@property (retain, nonatomic)  UILabel *_order_amount_label;
@property (retain, nonatomic)  UILabel *_shipping_fee_label;
@property (retain, nonatomic)  UILabel *_goods_price_label;
@property (retain, nonatomic)  UILabel *_goods_name_label;
@property (retain, nonatomic)  UIImageView *_goods_image_view;
@property (retain, nonatomic)  UILabel *_state_desc_label;
@property (retain, nonatomic)  UILabel *_goods_number_label;
@property (retain, nonatomic)  UILabel *_store_name_label;

@end
