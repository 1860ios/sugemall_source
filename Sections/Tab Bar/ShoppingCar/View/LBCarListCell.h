//
//  LBCarListCell.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBCarListModel.h"

@interface LBCarListCell : UITableViewCell

//@property(assign,nonatomic)BOOL selectState;//选中状态
//赋值
-(void)addTheValue:(LBCarListModel *)goodsModel;
//-(void)addTheValue:(LBCarListModel *)goodsModel selectState:(BOOL)isSelect;
@property (strong,nonatomic)   UIImageView *storeImage;//是否选中图片
@property (strong,nonatomic)   UIImageView *storeImageJ;
@property (retain, nonatomic)  UIButton *_deleteBtn;
@property (retain, nonatomic)  UIButton *_addBtn;
@property (retain, nonatomic)  UIButton *_searchDeliver;
@property (retain, nonatomic)  UIButton *_orderReciver;

@property (retain, nonatomic)  UITextField *_goods_num_label;
@property (retain, nonatomic)  UILabel *_goods_price_label;
@property (retain, nonatomic)  UILabel *_goods_name_label;
@property (retain, nonatomic)  UIImageView *_goods_image_view;
@property (retain, nonatomic)  UILabel *_store_name_label;
@property (retain, nonatomic)  UILabel *_goods_sum;//小计
@end
