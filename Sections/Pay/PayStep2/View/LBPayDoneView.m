//
//  LBPayDoneView.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/5.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBPayDoneView.h"
#import "UtilsMacro.h"
#import "UIView+Extension.h"

@interface LBPayDoneView ()

@end

@implementation LBPayDoneView
@synthesize payOverImage;
@synthesize backHomeButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付完成";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadPayDoneView];
}

- (void)loadPayDoneView
{
    payOverImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, SCREEN_HEIGHT/2)];
    payOverImage.image = IMAGE(@"zhifu");
    payOverImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:payOverImage];
    
    backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backHomeButton.frame = CGRectMake(20, payOverImage.y+payOverImage.height+49, SCREEN_WIDTH-40, 49);
    [backHomeButton setTitle:@"返回首页" forState:0];
    [backHomeButton setTitleColor:[UIColor whiteColor] forState:0];
    [backHomeButton setBackgroundColor:APP_COLOR];
    backHomeButton.titleLabel.font = BFONT(18);
    [backHomeButton addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backHomeButton];
    
}

- (void)backToHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
