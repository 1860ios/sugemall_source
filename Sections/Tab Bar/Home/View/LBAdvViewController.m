//
//  LBAdvViewController.m
//  SuGeMarket
//
//  广告视图
//  Created by 1860 on 15/8/4.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAdvViewController.h"
#import "UtilsMacro.h"
#import "UMSocial.h"
#import "LBUserInfo.h"


@interface LBAdvViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@property (strong,nonatomic)NSString *currentURL;
@property (strong,nonatomic)NSString *currentTitle;
@property (strong,nonatomic)NSString *currentHTML;
@end

@implementation LBAdvViewController
@synthesize advURL;
@synthesize isActivty;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"share_one") style:UIBarButtonItemStylePlain target:self action:@selector(shareYueBing)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.delegate =self;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:advURL]];
    [self.view addSubview: _webView];
    [_webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    self.currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
   
}

- (void)shareYueBing
{
//    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
//    NSString *apingd = [NSString stringWithFormat:@"&recookie=1&key=%@",key];
    
    NSString *shareText = @"真爱月饼 , 为爱而付";
    UIImage *shareImage = [UIImage imageNamed:@"suge_icon"];          //分享内嵌图片
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.currentURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.currentURL;
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"https://sugemall.com/data/upload/mobile/special/s0/s0_04945073657104406.jpg"];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5541f4cf67e58e03a9002933"
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,nil]
                                       delegate:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    advURL = nil;
}

@end
