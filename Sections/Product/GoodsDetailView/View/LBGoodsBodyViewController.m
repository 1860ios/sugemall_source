//
//  LBGoodsBodyViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/5/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBGoodsBodyViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "SUGE_API.h"
#import "TSMessage.h"
#import "UtilsMacro.h"
@interface LBGoodsBodyViewController ()<UIWebViewDelegate>


@end

@implementation LBGoodsBodyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图文介绍";
    [self loadWebView];
}

- (void)loadWebView
{
    __webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    __webView.scalesPageToFit= YES;
    [self.view addSubview:__webView];

    __webView.delegate = self;
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
    [__webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&goods_id=%@",SUGE_GOODS_BODY,__goods_id]]]];
    });

    
}


@end
