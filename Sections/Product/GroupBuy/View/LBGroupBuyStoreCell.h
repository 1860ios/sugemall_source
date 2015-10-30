//
//  LBGroupBuyStoreCell.h
//  SuGeMarket
//
//  Created by Apple on 15/10/30.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGroupBuyStoreCell : UITableViewCell
@property (nonatomic, strong) UIButton *all_goods_button;
@property (nonatomic, strong) UIButton *go_store_button;
- (void)addValueForGroupBuyStoreCell:(NSDictionary *)value;
@end
