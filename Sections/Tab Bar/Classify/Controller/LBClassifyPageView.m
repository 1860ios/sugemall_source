//
//  LBClassifyPageView.m
//  SuGeMarket
//
//  Created by 1860 on 15/10/24.
//  Copyright © 2015年 Josin_Q. All rights reserved.
//

#import "LBClassifyPageView.h"
#import "LBOrderListViewController.h"
#import "MobClick.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"
#import "AppMacro.h"
#import "LBClassifyViewContrtoller.h"
#import "LBBaseMethod.h"
#import "SUGE_API.h"
#import "LBGoodsDetailViewController.h"
#import "LBGoodsListViewController.h"

@interface LBClassifyPageView () <ViewPagerDataSource, ViewPagerDelegate>
{
}
@end

@implementation LBClassifyPageView

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;
    self.title = @"分类";
    [self loadNOTIFICATION_CENTER];

    IOS_NAVBAR
    
    [super viewDidLoad];
}
- (void)loadNOTIFICATION_CENTER
{
    [NOTIFICATION_CENTER addObserver:self selector:@selector(doPushFenLeiView:) name:@"POSTCLASSIFY" object:nil];
    
}
- (void)doPushFenLeiView:(NSNotification *)not
{
    NSString *gc_id = [[not userInfo] valueForKey:@"gc_id"];
    NSString *isList = [[not userInfo] valueForKey:@"isList"];
    
    if ([isList isEqualToString:@"YES"]) {
        LBGoodsListViewController *listVC = [[LBGoodsListViewController alloc] init];
        listVC._goodsID = gc_id;
        [self.navigationController pushViewController:listVC animated:YES];
    
    }else{
        LBGoodsDetailViewController *detailVC = [[LBGoodsDetailViewController alloc] init];
        detailVC._goodsID = gc_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }

}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.nameArray.count;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = self.nameArray[index];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    NSString *gcid = self.idArray[index];
    LBClassifyViewContrtoller *classify = [[LBClassifyViewContrtoller alloc] init];
    classify.gc_id = gcid;
    return classify;
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
            return [APP_COLOR colorWithAlphaComponent:0.94];
            break;
        default:
            break;
    }
    
    return color;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"分类"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类"];
}

@end
