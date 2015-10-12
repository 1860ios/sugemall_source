//
//  LBAboutViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/29.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBAboutViewController.h"
#import "UtilsMacro.h"
#import "MobClick.h"

@implementation LBAboutViewController

- (void)viewDidLoad
{
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *aboutMe = [[UILabel alloc]initWithFrame:CGRectMake(20,0, SCREEN_WIDTH - 40, 430)];
    aboutMe.text = @"     苏格时代商城是苏格实业有限公司倾情打造的线下线上同步销售的一体网站，致力于为消费者提供愉悦的在线购物体验。通过内容丰富、人性化的网站（www.sugemall.com）和移动客户端。\n     苏格时代商城以富有竞争力的价格，提供具有丰富品类及卓越品质的商品和服务，以快速可靠的方式送达消费者，并且提供灵活多样的支付方式。      \n •	苏格商家服务热线：400-6203-777  周一至周日 （09:00-24:00)        \n •	公司地址：南阳市车站南路中达明淯新城E区2层22号商铺";
    aboutMe.numberOfLines = 0;
    [self.view addSubview:aboutMe];
    
    
}

#pragma mark viewWillAppear
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于我们"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于我们"];
}

@end
