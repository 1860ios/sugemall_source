//
//  LBMainViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMainViewController.h"
#import "UtilsMacro.h"
#import <RKNotificationHub.h>
#import "LBHomeViewController.h"
#import "LBClassifyViewContrtoller.h"
#import "LBShoppingCarViewController.h"
#import "LBMineViewController.h"
#import "RKNotificationHub.h"
#import "AppMacro.h"
#import "NotificationMacro.h"
#import "AppDelegate.h"
#import "ADo_ViewController.h"
#import "AFViewShaker.h"
#import "LBLeftClassifyView.h"
#import "LBNewsViewController.h"
#import "LBWeathViewController.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

static BOOL FirstLaunch = NO;

@interface LBMainViewController ()<ZFTabBarDelegate>
{
    NSString *carBadgeValue;
}
@property (nonatomic, weak) ZFTabBar *customTabBar;
@end

@implementation LBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pushLeftView) name:@"pushleftView" object:nil];
    
    //1.
    [self setupTabbar];
    
    //2. 初始化Controllers
    [self initControllers];
    
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

    [NOTIFICATION_CENTER addObserver:self selector:@selector(toShowCarIconValue:) name:SUGE_NOT_CARLIST_COUNT_NAME object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(toClearBadgeValue) name:SUGE_NOT_LOGNOUT object:nil];
}

- (void)pushLeftView
{
    [self.drawer open];
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ZFTabBar *customTabBar = [[ZFTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;

}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZFTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    if (self.selectedIndex == to && to == 0 ) {
        //双击刷新制定页面的列表
//        UINavigationController *nav = self.viewControllers[0];
//        LBHomeViewController *firstVC = nav.viewControllers[0];
//        [firstVC refrshUI];
    }
    self.selectedIndex = to;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
#pragma mark ---CarBadgeValue
- (void)toShowCarIconValue:(id)sender
{
    carBadgeValue = [[sender userInfo] objectForKey:SUGE_NOT_CARLIST_KEY];
}
#pragma mark 清除小红数
- (void)toClearBadgeValue
{
    carBadgeValue = @"0";
}

- (void)initControllers
{
    LBHomeViewController *Home = [[LBHomeViewController alloc] init];
    [self setupChildViewController:Home title:@"首页" imageName:@"shouye" selectedImageName:@"shouye_s"];
    
    LBNewsViewController *news = [[LBNewsViewController alloc] init];
    [self setupChildViewController:news title:@"消息" imageName:@"news_normal" selectedImageName:@"news_select"];
    
    LBWeathViewController *weath = [[LBWeathViewController alloc] init];
    weath.tabBarItem.badgeValue = carBadgeValue;
    [self setupChildViewController:weath title:@"财富" imageName:@"treasure_normal" selectedImageName:@"treasure_select"];
    
    LBMineViewController *mine = [[LBMineViewController alloc] init];
    [self setupChildViewController:mine title:@"个人中心" imageName:@"zhongxin" selectedImageName:@"zhongxin_s"];
        
}
/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.tintColor = [UIColor lightGrayColor];
//    nav.navigationBar.translucent = YES;
    [self addChildViewController:nav];
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark 判断第一次进入

+(void)initialize{
    BOOL notFirstLaunch = [USER_DEFAULT boolForKey:SUGE_NotFirstLaunch];
    FirstLaunch = !notFirstLaunch;
    
}

+ (id)getMainController
{
    if (FirstLaunch) {
        ADo_ViewController *guideVC = [ADo_ViewController new];
        return guideVC;
    }else{
        LBMainViewController *mainVC = [LBMainViewController new];
        LBLeftClassifyView *left = [LBLeftClassifyView new];
        ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:left centerViewController:mainVC];

        return drawer;
    }
    
}

+ (void)endOfGuide
{
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    LBMainViewController *main = [[LBMainViewController alloc] init];
    appdelegate.window.rootViewController = main;
    
    [USER_DEFAULT setBool:YES forKey:SUGE_NotFirstLaunch];
    [USER_DEFAULT synchronize];
    
}

@end
