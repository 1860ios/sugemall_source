//
//  LBVoucherViewController.m
//  SuGeMarket
//
//  Created by Apple on 15/7/18.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBVoucherHostViewController.h"
#import "UtilsMacro.h"
#import "MobClick.h"
#import "LBVoucherViewController.h"
@interface LBVoucherHostViewController ()<ViewPagerDataSource, ViewPagerDelegate>


@end

@implementation LBVoucherHostViewController

- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    self.title = @"代金券";
    [super viewDidLoad];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    switch (index) {
        case 0:
            label.text = @"未使用";
            break;
        case 1:
            label.text = @"已使用";
            break;
        case 2:
            label.text = @"已过期";
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {

    LBVoucherViewController *voucher = [[LBVoucherViewController alloc] init];
    switch (index) {
        case 0:
            voucher.voucher_state = @"1";
            break;
            
        case 1:
            voucher.voucher_state = @"2";
            break;
        case 2:
            voucher.voucher_state = @"3";
            break;
    }
    return voucher;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case  ViewPagerOptionTabWidth:
            return SCREEN_WIDTH/3;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [APP_COLOR colorWithAlphaComponent:0.64];
            break;
        default:
            break;
    }
    
    return color;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [MobClick beginLogPageView:@"优惠券"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"优惠券"];
}

@end
