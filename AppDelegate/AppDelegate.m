//
//  AppDelegate.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMainViewController.h"
#import "AppDelegate.h"
#import "AppMacro.h"
#import <MobClick.h>
#import "UMessage.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UMSocial.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "VendorMacro.h"
#import "NotificationMacro.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "LBOrderListViewController.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HYBUMessageHelper.h"
#import "CALayer+Transition.h"
#import "LBBaseMethod.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>
{
    UIButton *getVcodeButton,*skipButton;
    NSTimer *countDownTimer;
    __block int timeout;
    SystemSoundID soundID;
   // NSTimeInterval secondsCountDown;
    // int secondsCountDown;
}
@property (strong, nonatomic) UIView *lunchView;
@property (strong, nonatomic) UIImageView *imageV;
@end

@implementation AppDelegate
@synthesize lunchView;
@synthesize imageV;


- (void)loadRequest1{
    lunchView = [[NSBundle mainBundle ]loadNibNamed:@"Launch Screen" owner:nil options:nil][0];
    lunchView.backgroundColor = [UIColor whiteColor];
    lunchView.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageV.userInteractionEnabled = YES;
    [LBBaseMethod get:@"http://sugemall.com/mobile/index.php?act=index&op=start_adv" parms:nil success:^(id json){
        NSLog(@"首页:%@",json);
        NSDictionary *start1= json[@"datas"][@"start_adv_list"][0];
        NSString *picString=start1[@"adv_pic"];
        [imageV sd_setImageWithURL:[NSURL URLWithString:picString] placeholderImage:nil];
        [lunchView addSubview:imageV];
    }failture:^(id error){
        
    }];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//SUGE_VERSION
    [self.window makeKeyAndVisible];
    
    if (launchOptions != nil) {
        // UIApplicationLaunchOptionsRemoteNotificationKey 这个key值就是push的信息
        NSDictionary *dic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        // 为了复用代码，统一到下面这个处理方法中handlePushNotify.
        [self handlePushNotify:dic];
    }
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    [HYBUMessageHelper startWithLaunchOptions:launchOptions];
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        [self loadRequest1];
    });

    getVcodeButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 30, 40, 40)];
    [getVcodeButton setTitleColor:APP_COLOR forState:0];
    getVcodeButton.layer.cornerRadius=20;
    getVcodeButton.layer.masksToBounds = YES;
    getVcodeButton.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];
    [imageV addSubview:getVcodeButton];
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-60, 80, 40);
    [skipButton setTitleColor:APP_COLOR forState:0];
    [skipButton setTitle:@"跳过 >>" forState:0];
    [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    skipButton.userInteractionEnabled = YES;
    [imageV addSubview:skipButton];
    [self.window addSubview:lunchView];
    [self.window bringSubviewToFront:lunchView];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLunchView) userInfo:nil repeats:NO];
    [self timeFireMethod];
   

    return YES;
}

-(void)skipAction
{
    [self removeLunchView];
    self.window.rootViewController = [LBMainViewController getMainController];
}
    
                                      
-(void)timeFireMethod
{
    
    timeout=3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
       
                [self removeLunchView];

            });
        }else{
            int seconds = timeout % 10;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getVcodeButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                getVcodeButton.titleLabel.font = FONT(13);
                getVcodeButton.userInteractionEnabled = NO;
                
            });
            
            timeout--;

        }

    });

    dispatch_resume(_timer);

}
-(void)removeLunchView
{

    //添加一个转场动画
    [lunchView.superview.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
    
    [lunchView removeFromSuperview];
    self.window.rootViewController = [LBMainViewController getMainController];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
       [UMessage registerDeviceToken:deviceToken];
    NSString* dvsToken =[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];

    [USER_DEFAULT setObject:dvsToken forKey:@"device_token"];
    [USER_DEFAULT synchronize];
    NSLog(@"dvsToken:%@",dvsToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [HYBUMessageHelper didReceiveRemoteNotification:userInfo];
    if (application.applicationState != UIApplicationStateActive) { // 一般在应用运行状态下不做处理，或做特殊处理
        [self handlePushNotify:userInfo];
    }
    [HYBUMessageHelper setAutoAlertView:NO];
    /*
    AudioServicesPlaySystemSound(1007); //系统的通知声音

    //自定义声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dingdang" ofType:@"caf"];
    //组装并播放音效
    SystemSoundID soundID_push;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID_push);
    AudioServicesPlaySystemSound(soundID_push);
    //声音停止
    AudioServicesDisposeSystemSoundID(soundID_push);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//震动
    */

}

- (void)handlePushNotify:(NSDictionary *)info {
    [NOTIFICATION_CENTER postNotificationName:@"tuisongxiaoxi" object:nil userInfo:info];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url]||[TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == NO) {
        //调用其他SDK，例如新浪微博SDK等
        //支付宝支付跳转
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSLog(@"APP_result = %@",resultDic);
                                                      }]; }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"APP++result = %@",resultDic);
            }];
        }
        if ([WXApi handleOpenURL:url delegate:self]) {
                return [WXApi handleOpenURL:url delegate:self];
        }

    }
    return result;
}


//回调方法
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//    [NOTIFICATION_CENTER postNotificationName:SUGE_WX_PAY_RESULT object:nil userInfo:nil];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付失败"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                [NOTIFICATION_CENTER postNotificationName:SUGE_WX_PAY_RESULT object:nil userInfo:nil];
                break;
        }
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    });
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [NOTIFICATION_CENTER postNotificationName:SUGE_WX_PAY_RESULT object:nil userInfo:nil];
    }
}



@end
