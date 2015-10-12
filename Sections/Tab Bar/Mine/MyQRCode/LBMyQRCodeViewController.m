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

@interface LBMyQRCodeViewController ()<UIScrollViewDelegate>
{
    UIButton *copyButton;
    UILabel *lianjieLabel;
    NSString *p1;
}
@property (nonatomic,strong) UIImageView *QRCodeIMGView;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation LBMyQRCodeViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的二维码";
       self.view.backgroundColor = [UIColor whiteColor];
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
    NSString *userUrl = [LBUserInfo sharedUserSingleton].avatar;
    UIImageView *useImageView =[[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 80, 80)];
    useImageView.layer.cornerRadius = 40;
    useImageView.layer.masksToBounds = YES;
    [[SDImageCache sharedImageCache] clearMemory];
    [useImageView sd_setImageWithURL:[NSURL URLWithString:userUrl] placeholderImage:IMAGE(@"user_no_image") options:SDWebImageCacheMemoryOnly];
    [[SDImageCache sharedImageCache] clearMemory];
    [scrollView addSubview:useImageView];
    
    NSString *usename = [LBUserInfo sharedUserSingleton].userinfo_username;
    UILabel *usenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(useImageView.frame.origin.x+useImageView.frame.size.width+5, useImageView.center.y-25, SCREEN_WIDTH-200-5, 50)];
    usenameLabel.text = [NSString  stringWithFormat:@"我是%@,我为[苏格时代]代言.",usename];
    usenameLabel.numberOfLines = 2;
    [scrollView addSubview:usenameLabel];
    
    UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, useImageView.frame.origin.y+useImageView.frame.size.height, SCREEN_WIDTH, 50)];
    Label1.text = @"扫码关注 分享赚钱";
    Label1.font = BFONT(25);
    Label1.textColor = APP_COLOR;
    Label1.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:Label1];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, Label1.frame.origin.y+Label1.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-(Label1.frame.origin.y+Label1.frame.size.height+10)+70)];
    view1.backgroundColor = RGBCOLOR(217 ,67 ,78);
    [scrollView addSubview:view1];
    
    //二维码背景图
    UIImageView *BGQRCodeIMGView = [[UIImageView alloc]initWithFrame:CGRectMake(50,20, SCREEN_WIDTH - 100, SCREEN_WIDTH - 100)];
    BGQRCodeIMGView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    BGQRCodeIMGView.layer.cornerRadius = 10;
    BGQRCodeIMGView.layer.masksToBounds = YES;
    [view1 addSubview:BGQRCodeIMGView];
    
    //二维码图
    CGFloat QRCodeIMGViewWidth = BGQRCodeIMGView.frame.size.width;
    _QRCodeIMGView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, QRCodeIMGViewWidth - 20, QRCodeIMGViewWidth - 20)];
    [BGQRCodeIMGView addSubview:_QRCodeIMGView];

    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, BGQRCodeIMGView.frame.origin.y+BGQRCodeIMGView.frame.size.height+10, 160, 30)];
    Label2.text = @"专属链接:";
    Label2.font = FONT(15);
    Label2.textColor = [UIColor whiteColor];
    [view1 addSubview:Label2];
    //
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSString *QRCodeStr = [NSString stringWithFormat:@"%@%@",SUGE_QRCODEURL,key];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(Label2.frame.origin.x, Label2.frame.origin.y+Label2.frame.size.height, BGQRCodeIMGView.frame.size.width, 60)];
    view2.layer.cornerRadius = 5;
    view2.layer.masksToBounds = YES;
    view2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:view2];
    
    lianjieLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,view2.frame.size.width-20,60)];
    lianjieLabel.numberOfLines = 2;
//    lianjieLabel.adjustsFontSizeToFitWidth = YES;
    lianjieLabel.text = p1;
    lianjieLabel.textColor = APP_COLOR;
    [view2 addSubview:lianjieLabel];
    //
    copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(view2.frame.origin.x, view2.frame.origin.y+view2.frame.size.height+10, 60, 30);
    [copyButton setTitle:@"复制" forState:0];
    [copyButton addTarget:self action:@selector(copyValue) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview: copyButton];
    
    NSURL *QRCodeURL = [NSURL URLWithString:QRCodeStr];

    //更新界面
    [_QRCodeIMGView sd_setImageWithURL:QRCodeURL];//把二维码请求网址添上
}

- (void)copyValue
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =  lianjieLabel.text;
    [TSMessage showNotificationWithTitle:@"复制成功~" type:TSMessageNotificationTypeSuccess];
}

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
