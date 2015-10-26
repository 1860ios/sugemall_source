//
//  LBNewHandViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/17.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBNewHandViewController.h"
#import "LBQuestionsViewController.h"
#import "LBQuestionsViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AppMacro.h"
#import "LBContentViewController.h"
@interface LBNewHandViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    UILabel * label;
}
@end

@implementation LBNewHandViewController
- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    self.title= @"新手指南";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor=RGBCOLOR(0, 160, 233);
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toGoDetail:) name:@"xiangqing" object:nil ];


    [super viewDidLoad];
}


- (void)toGoDetail:(NSNotification *)not
{
    NSString *str1 = [[not userInfo] objectForKey:@"ac_id"];

    LBContentViewController *content=[[LBContentViewController alloc]init];
    content.ac_id=str1;
    
    [self.navigationController pushViewController:content animated:YES];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    switch (index) {
        case 0:
            label.text=_title1;
            break;
        case 1:
            label.text=_title2;
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
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
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor whiteColor];
            break;
        case ViewPagerTabsView:
            return RGBCOLOR(0, 160, 233);
            break;
        default:
            break;
    }
    
    return color;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    LBQuestionsViewController *Questions = [[LBQuestionsViewController alloc] init];
    switch (index) {
        case 0:
            Questions.tag=@"0";
            break;
        case 1:
            Questions.tag=@"1";
            break;
    }

    return Questions;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //        self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithWhite:0.93 alpha:0.93];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];

}

@end
