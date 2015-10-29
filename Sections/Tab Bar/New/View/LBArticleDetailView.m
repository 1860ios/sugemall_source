//
//  LBArticleDetailView.m
//  SuGeMarket
//
//  文章详情
//  Created by Apple on 15/10/28.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBArticleDetailView.h"
#import "UtilsMacro.h"

@interface LBArticleDetailView ()<UIWebViewDelegate>
{
        UIWebView *_webView;
}
@end

@implementation LBArticleDetailView
@synthesize articleURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"详情";
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.delegate =self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:articleURL]];
    [self.view addSubview: _webView];
    [_webView loadRequest:request];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    articleURL = nil;
}
@end
