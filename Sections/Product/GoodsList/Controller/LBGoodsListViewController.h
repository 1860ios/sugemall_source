//
//  LBGoodsListViewController.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGoodsListViewController : UIViewController

@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, retain) NSString *_goodsID;
@property (nonatomic, retain) NSString *_keyWord;
@property (nonatomic, strong) UITableView *_tableView;

@end
