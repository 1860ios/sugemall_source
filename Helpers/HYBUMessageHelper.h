//
//  HYBUMessageHelper.h
//  SuGeMarket
//
//  Created by 1860 on 15/8/19.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*!
 * @brief 友盟消息推送API相关封装类
 * @author huangyibiao
 */
@interface HYBUMessageHelper : NSObject<UIAlertViewDelegate>

/// 在应用启动时调用此方法注册
+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions;

+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
// 关闭接收消息通知
+ (void)unregisterRemoteNotifications;

// default is YES
// 使用友盟提供的默认提示框显示推送信息
+ (void)setAutoAlertView:(BOOL)shouldShow;

// 应用在前台时，使用自定义的alertview弹出框显示信息
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo;

@end
