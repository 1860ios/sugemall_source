//
//  LBOrderDetailModel.h
//  SuGeMarket
//
//  Created by 1860 on 15/7/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBOrderDetailModel : NSObject

@property (nonatomic, strong) NSMutableArray *extend_order_goods;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *buyer_email;
@property (nonatomic, copy) NSString *buyer_id;
@property (nonatomic, copy) NSString *buyer_name;
@property (nonatomic, copy) NSString *delay_time;
@property (nonatomic, copy) NSString *evaluation_state;
@property (nonatomic, copy) NSString *delete_state;
@property (nonatomic, copy) NSString *finnshed_time;
@property (nonatomic, copy) NSString *goods_amount;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *if_cancel;
@property (nonatomic, copy) NSString *if_complain;
@property (nonatomic, copy) NSString *if_deliver;
@property (nonatomic, copy) NSString *if_evaluation;
@property (nonatomic, copy) NSString *if_lock;
@property (nonatomic, copy) NSString *if_receive;
@property (nonatomic, copy) NSString *if_refund_cancel;
@property (nonatomic, copy) NSString *if_share;
@property (nonatomic, copy) NSString *invoice_info;
@property (nonatomic, copy) NSString *lock_state;
@property (nonatomic, copy) NSString *order_add_date;
@property (nonatomic, copy) NSString *order_amount;
@property (nonatomic, copy) NSString *order_from;
@property (nonatomic, copy) NSString *order_cancel_day;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *order_state;
@property (nonatomic, copy) NSString *pay_sn;
@property (nonatomic, copy) NSString *payment_code;
@property (nonatomic, copy) NSString *payment_name;
@property (nonatomic, copy) NSString *payment_time;
@property (nonatomic, copy) NSString *reciver_info;
@property (nonatomic, copy) NSString *reciver_name;
@property (nonatomic, copy) NSString *refund_amount;
@property (nonatomic, copy) NSString *refund_state;
@property (nonatomic, copy) NSString *shipping_code;
@property (nonatomic, copy) NSString *shipping_fee;
@property (nonatomic, copy) NSString *state_desc;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *store_name;

@end
