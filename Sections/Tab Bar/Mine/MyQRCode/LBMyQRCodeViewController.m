//
//  LBMyQRCodeViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/8.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//
#import "LBMyQRCodeViewController.h"
#import "LBUserInfo.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import <MobClick.h>
#import <AFNetworking.h>
#import "SUGE_API.h"
#import <TSMessage.h>
#import "UMSocial.h"

@interface LBMyQRCodeViewController ()<UIScrollViewDelegate>
{
    UIButton *copyButton;
    UILabel *lianjieLabel;
    NSString *p1;
    NSString *fr;
    
}
@property (nonatomic,strong) UIImageView *QRCodeIMGView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation LBMyQRCodeViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的名片";
       self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:0.93];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+70);
    scrollView.delegate =self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    [self loadQRCodeImage];
    [self loadQRCodeDatas];
}

- (void)loadQRCodeDatas
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameter = @{@"key":key};
    [manager POST:SUGE_QR parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"二维码:%@",responseObject);
        p1 = responseObject[@"datas"];
        lianjieLabel.text = p1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"homeError:%@",error);
    }];
}


-(void)loadQRCodeImage
{
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH-50, 120)];
    view2.backgroundColor=RGBCOLOR(96, 83, 101);
    [scrollView addSubview:view2];
    
    NSString *userUrl = [LBUserInfo sharedUserSingleton].avatar;
    UIImageView *useImageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    useImageView.layer.cornerRadius = 40;
    useImageView.layer.masksToBounds = YES;
    [[SDImageCache sharedImageCache] clearMemory];
    [useImageView sd_setImageWithURL:[NSURL URLWithString:userUrl] placeholderImage:IMAGE(@"user_no_image") options:SDWebImageCacheMemoryOnly];
    [[SDImageCache sharedImageCache] clearMemory];
    [view2 addSubview:useImageView];
    
    NSString *usename = [LBUserInfo sharedUserSingleton].userinfo_username;
    UILabel *usenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(useImageView.frame.origin.x+useImageView.frame.size.width+5, useImageView.center.y-25, SCREEN_WIDTH-200-5, 50)];
    usenameLabel.text = [NSString  stringWithFormat:@"我是%@,我为[苏格时代]代言.",usename];
    usenameLabel.textColor=[UIColor whiteColor];
    usenameLabel.numberOfLines = 2;
    [view2 addSubview:usenameLabel];

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(view2.frame.origin.x, view2.frame.origin.y+view2.frame.size.height, SCREEN_WIDTH-50,SCREEN_WIDTH -100+70)];
    view1.backgroundColor =[UIColor whiteColor];
    [scrollView addSubview:view1];
    
    //二维码背景图
    UIImageView *BGQRCodeIMGView = [[UIImageView alloc]initWithFrame:CGRectMake(20,20, SCREEN_WIDTH-100, SCREEN_WIDTH - 100)];
    BGQRCodeIMGView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    BGQRCodeIMGView.layer.cornerRadius = 10;
    BGQRCodeIMGView.layer.masksToBounds = YES;
    [view1 addSubview:BGQRCodeIMGView];
    
    //二维码图
    CGFloat QRCodeIMGViewWidth = BGQRCodeIMGView.frame.size.width;
    _QRCodeIMGView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, QRCodeIMGViewWidth - 20, QRCodeIMGViewWidth - 20)];
    [BGQRCodeIMGView addSubview:_QRCodeIMGView];

    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, BGQRCodeIMGView.frame.origin.y+BGQRCodeIMGView.frame.size.height+10, view1.frame.size.width, 30)];
    Label2.text = @"长按扫描二维码去关注";
    Label2.font = FONT(15);
    Label2.textAlignment=NSTextAlignmentCenter;
    Label2.textColor = [UIColor grayColor];
    [view1 addSubview:Label2];
    //
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *QRCodeStr = [NSString stringWithFormat:@"%@%@",SUGE_QRCODEURL,key];
    NSURL *QRCodeURL = [NSURL URLWithString:QRCodeStr];

    //更新界面
    [_QRCodeIMGView sd_setImageWithURL:QRCodeURL];//把二维码请求网址添上
    
    NSArray *orderTitles = @[@"保存至手机",@"分享到朋友圈",@"分享给微信好友"];
    //    buttonTitles = @[@"90",@"20",@"10"];
    NSArray *orderTitles1 = @[@"订单",@"我的喜欢",@"会员专区"];

    for (int i = 0; i<3; i++) {
        
       UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame =CGRectMake(EACH_W(3 * i)+45, view1.frame.origin.y+view1.frame.size.height+20, 25, 25);
        [button1 setImage:IMAGE(orderTitles1[i]) forState:0];
        button1.tag = i+10;
        [button1 addTarget:self action:@selector(shareWeiXin:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button1];
        UILabel *orderTitlesLabel = [[UILabel alloc] init];
        orderTitlesLabel.frame = CGRectMake(button1.center.x-45, button1.frame.origin.y+button1.frame.size.height+10, 100, 15);
        orderTitlesLabel.textAlignment = NSTextAlignmentCenter;
        orderTitlesLabel.font = FONT(15);
        orderTitlesLabel.text = [orderTitles objectAtIndex:i];
        [scrollView addSubview:orderTitlesLabel];
    }

}
- (IBAction)shareWeiXin:(UIButton *)btn
{
//    // 设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
//    // UMSocialWXMessageTypeImage为图片类型
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
//    // 分享图盘到微信朋友圈显示字数比较少，只显示分享标题
//    [UMSocialData defaultData].extConfig.title = @"朋友圈分享内容";
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *QRCodeStr = [NSString stringWithFormat:@"%@%@",SUGE_QRCODEURL,key];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = QRCodeStr;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = QRCodeStr;
    switch (btn.tag) {
        case 10:
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:QRCodeStr]]], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            break;
        case 11:
            // 显示分享平台
            [UMSocialSnsService presentSnsController:self appKey:nil shareText:@"分享的内容" shareImage:nil shareToSnsNames:@[UMShareToWechatSession] delegate:nil];
            break;
        case 12:
            // 显示分享平台
            [UMSocialSnsService presentSnsController:self appKey:nil shareText:@"分享的内容" shareImage:nil shareToSnsNames:@[UMShareToWechatTimeline] delegate:nil];
            break;
        default:
            break;
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message=nil;
    if (!error) {
        [TSMessage showNotificationWithTitle:@"成功保存到相册" type:TSMessageNotificationTypeSuccess];
    }else
    {
        [TSMessage showNotificationWithTitle:@"保存图片失败" type:TSMessageNotificationTypeSuccess];
        message = [error description];
    }
    NSLog(@"message is %@",message);
}
//- (void)copyValue
//{
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string =  lianjieLabel.text;
//    [TSMessage showNotificationWithTitle:@"复制成功~" type:TSMessageNotificationTypeSuccess];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"我的二维码"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的二维码"];
}



@end
