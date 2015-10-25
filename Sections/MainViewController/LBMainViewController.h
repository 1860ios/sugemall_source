//
//  LBMainViewController.h
//  SuGeMarket
//
//  Tab bar 管理
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTabBar.h"
#import "ICSDrawerController.h"

@interface LBMainViewController : UITabBarController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;
+ (id)getMainController;
+ (void)endOfGuide;

@end
