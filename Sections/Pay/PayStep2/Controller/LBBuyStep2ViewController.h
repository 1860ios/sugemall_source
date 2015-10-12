//
//  LBBuyStep2ViewController.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LBBuyStep2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *pdr_amount;
@property(nonatomic, copy)NSString *tnMode;

@end
