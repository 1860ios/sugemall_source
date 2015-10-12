//
//  LBGoodsDetailViewController.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioBox.h"
#import "RadioGroup.h"

@interface LBGoodsDetailViewController : UIViewController
@property (nonatomic, assign) NSString *_goodsID;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, retain) RadioBox *radiobox1;
@property (nonatomic, retain) RadioBox *radiobox2;
@property (nonatomic, retain) RadioGroup *radioGroup1;
@property (nonatomic, retain) RadioGroup *radioGroup2;

@end
