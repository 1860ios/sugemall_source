//
//  LBDeliverViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/13.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBDeliverViewController.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "SUGE_API.h"
//#import "TimeLineViewControl.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"

@interface LBDeliverViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation LBDeliverViewController
@synthesize _orderID;
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看物流";
    self.view.backgroundColor = [UIColor whiteColor];
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:webView];

    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *urlstr= [NSString stringWithFormat:@"http://sugemall.com/mobile/index.php?act=member_order&op=kuaidi100&key=%@&order_id=%@",key,_orderID];
    //NSLog(@"%@",urlstr);
    NSURL *url=[NSURL URLWithString:urlstr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
}

@end
