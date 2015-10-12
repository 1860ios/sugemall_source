//
//  LBGoodsBodyViewController.h
//  SuGeMarket
//
//  Created by 1860 on 15/5/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGoodsBodyViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *_webView;
@property (nonatomic, strong) NSString *_goods_id;

@end
