//
//  LBMineViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/20.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBMineViewController.h"
#import "UtilsMacro.h"
#import "LBLognInViewController.h"
#import "LBUserInfo.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import "AppMacro.h"
#import <MBProgressHUD.h>
#import "NotificationMacro.h"
#import "LBMySettingViewController.h"
#import <UIImageView+WebCache.h>
#import "LBFavoriteListViewController.h"
#import "LBMyAddressViewController.h"
#import "LBInvoiceListViewController.h"
#import "LBOrderListViewController.h"
#import "LBAboutViewController.h"
#import "LBFeedbackViewController.h"
#import "TSMessage.h"
#import "MobClick.h"
#import "RKNotificationHub.h"
#import "FXBlurView.h"
#import "SVProgressHUD.h"
#import "LBMyRefereeViewController.h"
#import "LBMyQRCodeViewController.h"
#import "LBMyMessageViewController.h"
#import <RKNotificationHub.h>
#import "XMBadgeView.h"
#import "LBCommissionViewController.h"
#import "LBMyPointViewController.h"
#import "LBBankViewController.h"
#import "LBMyBlotterViewController.h"
#import <FXBlurView.h>
#import "LBOrderRefundViewController.h"
#import "HostViewController.h"
#import "LBVoucherHostViewController.h"
#import "LBMyInviteViewController.h"
#import <YLImageView.h>
#import "YFGIFImageView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LBSetViewController.h"
#import "LBWeathViewController.h"
#import "LBSafeViewController.h"
#import "LBRechargeViewController.h"
#import "LBPrefectureViewController.h"
#import "LBShoppingCarViewController.h"
#import "LBNewHandViewController.h"
#import "LBStartAuthenticationViewController.h"
#import "LBAddressListViewController.h"
#import "LBRedBagViewController.h"
#import "LBAdvViewController.h"


static NSString *cid = @"cid";
static SystemSoundID shake_sound_male_id = 0;
static SystemSoundID shake_sound_male_id1 = 1;
static NSString *collectionView_cid = @"collectionViewcid";

@interface LBMineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSArray *sectionTitle;
    NSArray *titles;
    NSArray *images;
    
    UIView *headerView;
    UIView *headerView2;
    
    UIButton *lognIn;//登陆
    UIButton *LognOut;//注销
    
    UILabel *order;
    UILabel *welcome;
    NSString *avstar;
    
    NSString *sender_name;
    NSString *sender_IconURL;
    NSString *vip_consume;
    
    UIImageView *userIcon;//用户头像
    UILabel *userName;//用户名
    UILabel *luckName;//幸运号
    UILabel *inviterLabel;
    //    UIButton *
    UIImageView *userNameIcon;
    UIImageView *levelIcon;
    UILabel *isVip;//vip
    NSString *iconUrl;
    NSString *namee;
    NSString *point;
    UIView *View1;
    NSString *inviter;
    //
    NSArray *buttonTitles;
    //
    UIImageView *edictImage;
    UIButton *edictButton;
    
    MBProgressHUD *HUD;
    RKNotificationHub *hub;
    RKNotificationHub *hud1;
    RKNotificationHub *hud2;
    RKNotificationHub *hud3;
    RKNotificationHub *hud4;
    NSInteger no_pay_num;
    
    //
    YFGIFImageView *gifImageView;
    BOOL isRedBag;
//    BOOL isLogin;
    UIImageView *redbagImageView;
    UIButton *caifuButton;
    UIButton *button1;
    //
    UILabel *redbagLabel;
    UILabel *centerLabel;
    UILabel *caifuLabel;
    UIImageView *jiantouImageView;
    UIImageView *jiantouImageView1;
    UIImageView *caifuImageView;
    UILabel *numLabel;
    UIView *lineView;
    NSString *title;
    NSString *title1;
    NSString *money;
    
    NSString *ac_id;
}

@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UICollectionView *_collectionView;

@end

@implementation LBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self loadDatas:@"faq,video"];
    [self loadDatas];
    [self loadLeftNav];
    [self drawTableView];
    [self drawTableViewHeaderView];
    [self drawCollectionView];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(isRedBag:) name:@"isRedBag" object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(lognOut:) name:SUGE_NOT_LOGNOUT1 object:nil];
    
}
- (void)loadLeftNav
{
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(0, 0, 35, 20);
    [button2 setTitle:@"设置" forState:0];
    button2.titleLabel.font=FONT(14);
    [button2 setTitleColor:[UIColor blackColor] forState:0];
    [button2 addTarget:self action:@selector(goToMySetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightNavBarItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightNavBarItem;

}
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma  mark 注销密码
- (void)lognOut:(NSNotification *)not
{
    //注销密码
    [[LBUserInfo sharedUserSingleton] deleteAccountInfo];
    userName.hidden = YES;
    userIcon.hidden = YES;
    levelIcon.hidden = YES;
    userNameIcon.hidden = YES;
    edictImage.hidden = YES;
    edictButton.hidden = YES;
    luckName.hidden = YES;
    inviterLabel.hidden = YES;
    lognIn.hidden = NO;
    welcome.hidden = NO;
    View1.hidden = YES;
    caifuButton.hidden=YES;
    caifuLabel.hidden=YES;
    jiantouImageView.hidden=YES;
    caifuImageView.hidden=YES;
    numLabel.hidden=YES;
    jiantouImageView1.hidden=YES;
    lineView.hidden=YES;
    [hud1 setCount:0];
    [hud2 setCount:0];
    [hud3 setCount:0];
    
    //发送通知
    [NOTIFICATION_CENTER postNotificationName:SUGE_NOT_LOGNOUT object:nil];
}

- (void)isRedBag:(NSNotification *)not
{
    NSString *_isRedBag = [[not userInfo] objectForKey:@"redbag"];
    if ([_isRedBag isEqual:@"0"]) {
        isRedBag = YES;
        self.navigationController.navigationBar.hidden = YES;
        
        //动画
        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"redbag.gif" ofType:nil]];
        gifImageView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        gifImageView.gifData = gifData;
        gifImageView.image = IMAGE(@"beginRedbag");
        [self.view addSubview:gifImageView];
        gifImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [gifImageView addGestureRecognizer:tap];
        
        //        redbagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //        redbagImageView.image = IMAGE(@"beginRedbag");
        //        [self.view addSubview:redbagImageView];
        //        isRedBag = NO;
    }else{
        //        isRedBag = YES;
        isRedBag = NO;
    }
    
}
- (void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"点击动画");
}
/**
 *  红包
 *
 *  @return 红包
 */

- (void)shakRedBag
{
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key,@"activity":@"1"};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_REDBAG parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"红包:%@",responObject);
        NSLog(@"红包错误:%@",responObject[@"datas"][@"error"]);
        /*
         imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
         [self.view addSubview:imageView];
         imageView.image = [YLGIFImage imageNamed:@"redbag.gif"];
         */
        
        //获奖信息
        redbagLabel = [[UILabel alloc] initWithFrame:CGRectMake(gifImageView.center.x-(SCREEN_WIDTH/3)/2, (gifImageView.frame.size.height)/6, SCREEN_WIDTH/3, 100)];
        redbagLabel.text = [NSString stringWithFormat:@"恭喜你摇到%@￥,赶紧去使用红包吧~",responObject[@"datas"][@"amount"]];
        money=responObject[@"datas"][@"amount"];
        redbagLabel.numberOfLines = 2;
        redbagLabel.textColor = APP_COLOR;
        redbagLabel.adjustsFontSizeToFitWidth = YES;
        [gifImageView stopGIF];
        [gifImageView addSubview:redbagLabel];
        [self playSound1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                gifImageView.alpha = 0;
            } completion:^(BOOL finish){
                self.navigationController.navigationBar.hidden = NO;
                [gifImageView removeFromSuperview];
                
            }];
        });
        
    }failure:^(AFHTTPRequestOperation *op,NSError *error){
        
    }];
    
}
-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
-(void) playSound1

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id1);
        AudioServicesPlaySystemSound(shake_sound_male_id1);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id1);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

#pragma mark - 摇动

/**
 *  摇动开始
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        if (isRedBag) {
            //            static dispatch_once_t onceToken;
            //            dispatch_once(&onceToken, ^{
            NSLog(@"开始摇了");
            //                SUGE_REDBAG
            [self playSound];
            [gifImageView startGIF];
            [self shakRedBag];
            
            //            });
        }
        
        
    }
}

/**
 *  摇动结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (isRedBag) {
        NSLog(@"摇动结束");
    }
    
}


- (void)goToMySetting
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (isLogin) {
        LBSetViewController *setting = [[LBSetViewController alloc] init];
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
    }else{
        [self goSigin];
    }
    
}
- (void)goSigin
{
    LBLognInViewController *loginIn = [[LBLognInViewController alloc] init];
    loginIn.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginIn animated:YES];
    
}

- (void)goToMymessage
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (isLogin) {
        LBMyMessageViewController *myMessage = [[LBMyMessageViewController alloc] init];
        myMessage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myMessage
                                             animated:YES];
    }else{
        [self goSigin];
    }
}


#pragma mark  加载数据
- (void)loadIconsDatas
{
    
    NSString *key = [LBUserInfo sharedUserSingleton].userinfo_key;
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"key":key,@"client":@"ios"};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_MY_SUGE parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        NSLog(@"会员中心:%@",responObject);
        iconUrl = responObject[@"datas"][@"member_info"][@"avator"];
        [[SDImageCache sharedImageCache] clearMemory];
        [userIcon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:IMAGE(@"user_no_image.png")options:SDWebImageCacheMemoryOnly];
        [[SDImageCache sharedImageCache] clearMemory];
        NSLog(@"iconUrl:%@",iconUrl);
        //积分...
        
        NSNumber *po = responObject[@"datas"][@"member_info"][@"point"];
        point = [NSString stringWithFormat:@"%0.2f",[po floatValue]];
        NSString *predepoit = responObject[@"datas"][@"member_info"][@"predepoit"];
        NSString *favs=responObject[@"datas"][@"member_info"][@"favorites"];
        vip_consume = responObject[@"datas"][@"member_info"][@"vip_consume"];
        namee = [LBUserInfo sharedUserSingleton].userinfo_username;
        NSString *menid =responObject[@"datas"][@"member_info"][@"member_id"];
        //推荐人
        inviter =responObject[@"datas"][@"member_info"][@"inviter"];
        if (![inviter isEqual:[NSNull null]]) {
            edictImage.hidden = YES;
            edictButton.hidden = YES;
            inviterLabel.hidden = NO;
            inviterLabel.text = [NSString stringWithFormat:@"推荐人:%@",inviter];
        }else{
            edictImage.hidden = NO;
            edictButton.hidden = NO;
            inviterLabel.hidden = YES;
            //   inviterLabel.text = [NSString stringWithFormat:@"推荐人:%@",inviter];
            
        }
        
        userName.text = [NSString stringWithFormat:@"%@",namee];
        luckName.text = [NSString stringWithFormat:@"%@",menid];
        //        int vip = [vip_consume intValue];
        levelIcon.userInteractionEnabled=YES;
        if ([vip_consume isEqualToString:@"168"]) {
            levelIcon.image = IMAGE(@"vip_top");
        }if ([vip_consume isEqualToString:@"1000"]) {
            levelIcon.image = IMAGE(@"huangjin_top");
        }else if ([vip_consume isEqualToString:@"2000"]){
            levelIcon.image = IMAGE(@"bojin_top");
        }else if ([vip_consume isEqualToString:@"3000"]){
            levelIcon.image = IMAGE(@"zuanshi_02");
        }else{
//            levelIcon.image=IMAGE(@"123");
            levelIcon.userInteractionEnabled=NO;
            levelIcon.image=IMAGE(@"kongbai");
        }
        if (predepoit == nil) {
            buttonTitles = @[point,@"0",@"0"];
        }else{
            buttonTitles = @[point,predepoit,favs];
        }
        
        
        for (int i = 0; i<3; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:88+i];
            [button setTitle:[buttonTitles objectAtIndex:i] forState:0];
        }
        NSString *num1 =responObject[@"datas"][@"order_count"][@"order_unpay"];
        NSString *num2 =responObject[@"datas"][@"order_count"][@"order_payed"];
        NSString *num3 =responObject[@"datas"][@"order_count"][@"order_send"];
        //        NSString *num4 =responObject[@"datas"][@"order_count"][@"order_sender"];
        [hud1 setCount:[num1 intValue]];
        [hud2 setCount:[num2 intValue]];
        [hud3 setCount:[num3 intValue]];
        //        [hud4 setCount:[num4 intValue]];
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
    }];
    //dimiss HUD
    [SVProgressHUD dismiss];
    
}

- (void)initDatas
{
    
    titles = @[@[@"全部订单"],@[@"我的钱包"],@[@"我的二维码",@"我的客户",],@[@"个人设置",@"帮助与反馈"]];
    images = @[@[@"suge_personel_waitpay_order"],@[@"my_shop"],@[@"mine_qcode",@"mine_customer"],@[@"mine_setting",@"suge_discuss"]];
    
}

#pragma mark    初始化tableView
- (void)drawTableView
{
    __tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    __tableView.delegate =self;
    __tableView.dataSource =self;
    //#warning iOS7 表格separatorInset
    __tableView.separatorInset=UIEdgeInsetsMake(0, -11, 0,11);
    [__tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cid];
    [self.view addSubview:__tableView];
    
}
#pragma mark 进入设置

- (void)pushSettingView
{
    LBMySettingViewController *setting = [[LBMySettingViewController alloc] init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}


#pragma mark  drawTableViewHeaderView
-(void)drawTableViewHeaderView
{
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 215)];
    //    FXBlurView *blur = [[FXBlurView alloc] initWithFrame:headerView.frame];
    //    blur.blurRadius = 5;
    headerView.backgroundColor=[UIColor whiteColor];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSettingView)];
    //用户头像
    userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 70, 70)];
    userIcon.userInteractionEnabled = YES;
    userIcon.contentMode = UIViewContentModeScaleAspectFit;
    userIcon.layer.cornerRadius = 35;
    userIcon.layer.masksToBounds  = YES;
    [userIcon addGestureRecognizer:tap1];
    [headerView addSubview:userIcon];
    
    lineView=[[UIView alloc]initWithFrame:CGRectMake(10, userIcon.frame.origin.y+userIcon.frame.size.height+10, SCREEN_WIDTH-20, 1)];
    lineView.backgroundColor=[UIColor colorWithWhite:0.95 alpha:0.93];
    [headerView addSubview:lineView];
    
    //"订单","储值金额","我的喜欢","会员专区
    View1 = [[UIView alloc] initWithFrame:CGRectMake(0, userIcon.frame.origin.y+userIcon.frame.size.height+25, SCREEN_WIDTH, 30)];
    View1.alpha = 0.5;
    //    [View1 setBlurRadius:20];
    NSArray *orderTitles = @[@"订单",@"购物车",@"会员专区",@"我的收藏"];
    NSArray *orderTitles1 = @[@"订单",@"个人中心修改_05",@"会员专区",@"我的喜欢"];
    //    buttonTitles = @[@"90",@"20",@"10"];
    if (buttonTitles.count == 0) {
        buttonTitles = @[@"0",@"0",@"0",@"0"];
    }
    for (int i = 0; i<4; i++) {
        
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame =CGRectMake(EACH_W(4 * i)+25, 0, 30, 30);
        //        button1.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        [button1 setTitleColor:[UIColor whiteColor] forState:0];
        //        [button1 setTitle:[buttonTitles objectAtIndex:i] forState:0];
        //        button1.titleLabel.font = FONT(14);
        [button1 setImage:IMAGE(orderTitles1[i]) forState:0];
        button1.tag = i+88;
        [button1 addTarget:self action:@selector(pushOtherView:) forControlEvents:UIControlEventTouchUpInside];
        [View1 addSubview:button1];

        
        UILabel *orderTitlesLabel = [[UILabel alloc] init];
        orderTitlesLabel.frame = CGRectMake(button1.center.x-33, button1.frame.origin.y+button1.frame.size.height, 70, 15);
        orderTitlesLabel.textAlignment = NSTextAlignmentCenter;
        orderTitlesLabel.font = FONT(12);
        orderTitlesLabel.text = [orderTitles objectAtIndex:i];
        [View1 addSubview:orderTitlesLabel];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(orderTitlesLabel.frame.origin.x+orderTitlesLabel.frame.size.width+15, orderTitlesLabel.frame.origin.y-15, 1, 30)];
        lineView1.backgroundColor=[UIColor colorWithWhite:0.85 alpha:0.93];
        [View1 addSubview:lineView1];
        if (i==3) {
            lineView1.backgroundColor=[UIColor whiteColor];
        }
        
    }
    
    [headerView addSubview:View1];
    [headerView addSubview:userIcon];
    //
    luckName = [[UILabel alloc] initWithFrame:CGRectMake(userIcon.frame.origin.x+userIcon.frame.size.width+10, userIcon.frame.origin.y, 60, 20)];
    luckName.textAlignment = NSTextAlignmentLeft;
    luckName.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:luckName];
    //CGRectMake(userName.frame.origin.x,+userName.frame.size.height+userName.frame.origin.y+5, 250, 20)];
    //用户名
    userName = [[UILabel alloc] initWithFrame:CGRectMake(luckName.frame.origin.x,+luckName.frame.size.height+luckName.frame.origin.y+5, 250, 20)];
    userName.textAlignment = NSTextAlignmentLeft;
    userName.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:userName];
    
    jiantouImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, userName.frame.origin.y, 20, 20)];
    jiantouImageView1.image=IMAGE(@"个人中心修改_03");
    jiantouImageView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSettingView)];
    [jiantouImageView1 addGestureRecognizer:tap2]                                                 ;
    [headerView addSubview:jiantouImageView1];

    
    //用户vip图标
    levelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(luckName.frame.origin.x+luckName.frame.size.width, luckName.frame.origin.y, 80, 20)];
    levelIcon.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushRecharge)];
    levelIcon.userInteractionEnabled=YES;
    [levelIcon addGestureRecognizer:tap3];
    [headerView addSubview:levelIcon];
    
    //修改推荐人
    edictImage = [[UIImageView alloc] initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y+userName.frame.size.height+5, 20, 20)];
    edictImage.image = IMAGE(@"1");
    [headerView addSubview:edictImage];
    // edictImage.hidden = YES;
    edictButton = [UIButton buttonWithType:UIButtonTypeCustom];
    edictButton.frame = CGRectMake(edictImage.frame.origin.x+edictImage.frame.size.width,edictImage.frame.origin.y, 80, 20);
    [edictButton setTitle:@"修改推荐人" forState:0];
    edictButton.titleLabel.font = FONT(14);
    [edictButton setTitleColor:[UIColor blackColor] forState:0];
    [edictButton addTarget:self action:@selector(edictMyInvite) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:edictButton];
    // edictButton.hidden = YES;
    // 推荐人
    inviterLabel =[[UILabel alloc] initWithFrame:CGRectMake(userName.frame.origin.x, userName.frame.origin.y+userName.frame.size.height+5, 150, 20)];
    inviterLabel.font = [UIFont systemFontOfSize:14];
    inviterLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:inviterLabel];
    //inviterLabel.hidden = YES;
    
    caifuImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20,View1.frame.origin.y+View1.frame.size.height+30,30, 30)];
    caifuImageView.image=IMAGE(@"caifu_01");
    [headerView addSubview:caifuImageView];
    
    caifuLabel=[[UILabel alloc]initWithFrame:CGRectMake(caifuImageView.frame.origin.x+caifuImageView.frame.size.width+10,caifuImageView.frame.origin.y,40,30)];
    caifuLabel.text=@"财富";
    caifuLabel.font=FONT(15);
    [headerView addSubview:caifuLabel];
    
    jiantouImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, caifuLabel.frame.origin.y, 20, 20)];
    jiantouImageView.image=IMAGE(@"个人中心修改_03");
    [headerView addSubview:jiantouImageView];
    
    numLabel=[[UILabel alloc]initWithFrame:CGRectMake(jiantouImageView.frame.origin.x-210, jiantouImageView.frame.origin.y,200, 25)];
    numLabel.font=FONT(15);
    numLabel.textAlignment=NSTextAlignmentRight;
    [headerView addSubview:numLabel];
    
    caifuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    caifuButton.frame=CGRectMake(0,caifuLabel.frame.origin.y,SCREEN_WIDTH, caifuLabel.frame.size.height);
    //    [caifuButton setImage:IMAGE(@"syncart_round_check1@2x") forState:UIControlStateNormal];
    [caifuButton setImage:IMAGE(@"syncart_round_check2@2x") forState:UIControlStateSelected];
    [caifuButton addTarget:self action:@selector(clickWeath) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:caifuButton];
    
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,caifuLabel.frame.origin.y+caifuLabel.frame.size.height+20, SCREEN_WIDTH, 10)];
    view1.backgroundColor= [UIColor colorWithWhite:0.93 alpha:0.97];
    // view1.backgroundColor=[UIColor redColor];
    [headerView addSubview:view1];
    //欢迎
    welcome =[[UILabel alloc] initWithFrame:CGRectMake(headerView.center.x-85, headerView.center.y-20-30, 170, 35)];
    welcome.text = @"欢迎来到苏格商城";
    welcome.font = [UIFont systemFontOfSize:21];
    welcome.textColor = [UIColor whiteColor];
    [headerView addSubview:welcome];
    
    //登陆/注册
    lognIn = [UIButton buttonWithType:UIButtonTypeCustom];
    lognIn.frame = CGRectMake(headerView.center.x-60, headerView.center.y-30, 120, 40);
    lognIn.layer.cornerRadius = 5;
    lognIn.layer.borderWidth = 1;
    lognIn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [lognIn setTitle:@"登录/注册" forState:0];
    [lognIn setTitleColor:[UIColor lightGrayColor] forState:0];
    [lognIn addTarget:self action:@selector(pushLognInView) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:lognIn];
    
    self._tableView.tableHeaderView = headerView;
    
}

#pragma mark  tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    cell.selected=NO;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    centerLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 18, 60, 20)];
    centerLabel.text=@"账户中心";
    centerLabel.font=FONT(12);
    centerLabel.textColor=[UIColor lightGrayColor];
    [cell addSubview:centerLabel];
    [cell.contentView addSubview:__collectionView];
    
    UILabel *serviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,__collectionView.frame.origin.y+__collectionView.frame.size.height+20, 60, 20)];
    serviceLabel.textColor=[UIColor lightGrayColor];
    serviceLabel.text=@"客户服务";
    serviceLabel.font=FONT(12);
    [cell.contentView addSubview:serviceLabel];
    NSArray *serviceArray=@[@"个人中心修改_25-44",@"个人中心修改_43",@"个人中心修改_41"];
    UIButton *serviceButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton1 = [[UIButton alloc] initWithFrame:CGRectZero];
    serviceButton1.frame = CGRectMake(30,serviceLabel.frame.origin.y+serviceLabel.frame.size.height+10, SCREEN_WIDTH/4-30-30, SCREEN_WIDTH/4-30-30);
    [serviceButton1 setImage:IMAGE(serviceArray[0]) forState:0];
    [serviceButton1 addTarget:self action:@selector(pushToAbout) forControlEvents:UIControlEventTouchUpInside];
    serviceButton1.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:serviceButton1];
    
    UIButton *serviceButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton2 = [[UIButton alloc] initWithFrame:CGRectZero];
    serviceButton2.frame = CGRectMake(serviceButton1.frame.origin.x+serviceButton1.frame.size.width+60,serviceButton1.frame.origin.y,serviceButton1.frame.size.width,serviceButton1.frame.size.height);
    [serviceButton2 setImage:IMAGE(serviceArray[1]) forState:0];
    serviceButton2.contentMode = UIViewContentModeScaleAspectFit;
    [serviceButton2 addTarget:self action:@selector(pushToQuestions) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:serviceButton2];
    
    UIButton *serviceButton3=[UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton3 = [[UIButton alloc] initWithFrame:CGRectZero];
    serviceButton3.frame = CGRectMake(serviceButton2.frame.origin.x+serviceButton2.frame.size.width+60,serviceButton2.frame.origin.y,serviceButton2.frame.size.width,serviceButton2.frame.size.height);
    [serviceButton3 setImage:IMAGE(serviceArray[2]) forState:0];
    serviceButton3.contentMode = UIViewContentModeScaleAspectFit;
    [serviceButton3 addTarget:self action:@selector(pushToFeedback) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:serviceButton3];
    
    UILabel *serviceLabel1=[[UILabel alloc]initWithFrame:CGRectMake(serviceButton1.center.x-22,serviceButton1.frame.origin.y+serviceButton1.frame.size.height,60, 20)];
    serviceLabel1.text=@"关于苏格";
    serviceLabel1.textColor=[UIColor lightGrayColor];
    serviceLabel1.font=FONT(12);
    [cell.contentView addSubview:serviceLabel1];
    
    UILabel *serviceLabel2=[[UILabel alloc]initWithFrame:CGRectMake(serviceButton2.center.x-22,serviceButton2.frame.origin.y+serviceButton2.frame.size.height,60, 20)];
    serviceLabel2.text=@"新手指南";
    serviceLabel2.textColor=[UIColor lightGrayColor];
    serviceLabel2.font=FONT(12);
    [cell.contentView addSubview:serviceLabel2];
    
    UILabel *serviceLabel3=[[UILabel alloc]initWithFrame:CGRectMake(serviceButton3.center.x-27,serviceButton3.frame.origin.y+serviceButton3.frame.size.height,60, 20)];
    serviceLabel3.text=@"苏格商学院";
    serviceLabel3.textColor=[UIColor lightGrayColor];
    serviceLabel3.font=FONT(12);
    [cell.contentView addSubview:serviceLabel3];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(serviceButton1.frame.origin.x+serviceButton1.frame.size.width+30,serviceButton1.frame.origin.y+10, 1, 30)];
    lineView4.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];
    [cell.contentView addSubview:lineView4];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT-headerView.frame.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (void)pushOtherView:(UIButton *)btn
{
    HostViewController *OrderList = [[HostViewController alloc] init];
    LBFavoriteListViewController *fa = [[LBFavoriteListViewController alloc] init];
    LBPrefectureViewController *pre=[[LBPrefectureViewController alloc]init];
    LBShoppingCarViewController *shopping=[[LBShoppingCarViewController alloc]init];
//    NSString *yue = buttonTitles[1];
    switch (btn.tag) {
        case 88:
            OrderList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:OrderList animated:YES];
            break;
            
        case 89:
            //com._yue = yue;
            shopping.hidesBottomBarWhenPushed = YES;
            shopping.isPushIn = YES;
            [self.navigationController pushViewController:shopping animated:YES];
            break;
        case 90:
            pre.hidesBottomBarWhenPushed = YES;
            pre.iconString=iconUrl;
            pre.nameString=namee;
            pre.integrationString=point;
            if ([vip_consume isEqualToString:@"168"]) {
                pre.vipNum=vip_consume;
            }if ([vip_consume isEqualToString:@"1000"]) {
                pre.vipNum=vip_consume;
            }else if ([vip_consume isEqualToString:@"2000"]){
                pre.vipNum=vip_consume;
            }else if ([vip_consume isEqualToString:@"3000"]){
                pre.vipNum=vip_consume;
            }
            [self.navigationController pushViewController:pre animated:YES];
            break;
        case 91:
            fa.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fa animated:YES];
            break;
    }
}
#pragma mark 初始化collectionView
-(void)drawCollectionView
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    __collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(20,centerLabel.frame.origin.y+centerLabel.frame.size.height,SCREEN_WIDTH,SCREEN_WIDTH/2+10)collectionViewLayout:layout];
    __collectionView.backgroundColor = [UIColor whiteColor];
    __collectionView.delegate = self;
    __collectionView.dataSource = self;
    __collectionView.scrollEnabled  = YES;
    [__collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:collectionView_cid];
}
#pragma mark  __collectionView 代理方法

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell= [collectionView dequeueReusableCellWithReuseIdentifier:collectionView_cid forIndexPath :indexPath];
    while ([cell.contentView.subviews lastObject]) {
        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    NSArray *array=@[@"个人中心修改_19",@"个人中心修改_21",@"个人中心修改_21-21",@"个人中心修改_27",@"个人中心修改_22-35",@"个人中心修改_32-36",@"suge_bank_1"];
    NSArray *array1=@[@"通讯录",@"我的名片",@"实名认证",@"红包",@"安全设置",@"收货地址",@"银行卡"];
    
    UIImageView *cardImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH/4-30-30, SCREEN_WIDTH/4-30-30)];
    cardImageView.image=IMAGE([array objectAtIndex:indexPath.row]);

    [cell.contentView addSubview:cardImageView];
    
    UILabel *cardLabel=[[UILabel alloc]initWithFrame:CGRectMake(cardImageView.center.x-20,cardImageView.frame.origin.y+cardImageView.frame.size.height,60, 20)];
    cardLabel.text=[array1 objectAtIndex:indexPath.row];
    cardLabel.textColor=[UIColor lightGrayColor];
    cardLabel.font=FONT(12);
    if (indexPath.row==6) {
        cardLabel.frame=CGRectMake(cardImageView.center.x-17,cardImageView.frame.origin.y+cardImageView.frame.size.height,60, 20);
    }else if (indexPath.row==4||indexPath.row==5)
    {
        cardLabel.frame=CGRectMake(cardImageView.center.x-23,cardImageView.frame.origin.y+cardImageView.frame.size.height,60, 20);
    }
    else if (indexPath.row==3)
    {
        cardLabel.frame=CGRectMake(cardImageView.center.x-12,cardImageView.frame.origin.y+cardImageView.frame.size.height,60, 20);
    }
//    else if (indexPath.row==6)
//    {
//        cardLabel.frame=CGRectMake(cardImageView.center.x,cardImageView.frame.origin.y+cardImageView.frame.size.height,60, 20);
//    }
    [cell.contentView addSubview:cardLabel];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(cardImageView.frame.origin.x+cardImageView.frame.size.width+30,cardImageView.frame.origin.y+10, 1, 30)];
    lineView3.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.97];

    if (indexPath.row==6||indexPath.row==3) {
        lineView3.backgroundColor=[UIColor whiteColor];
    }
    [cell.contentView addSubview:lineView3];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/4-10,SCREEN_WIDTH/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 0, 2 );
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;

    switch (indexPath.row) {
        case 0:
            if (isLogin) {
                LBAddressListViewController *List = [[LBAddressListViewController alloc] init];
                List.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:List animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 1:
            if (isLogin) {
                LBMyQRCodeViewController *QRCode = [[LBMyQRCodeViewController alloc] init];
                QRCode.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:QRCode animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 2:

            if (isLogin) {
                LBStartAuthenticationViewController *StartAuthentication = [[LBStartAuthenticationViewController alloc] init];
                StartAuthentication.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:StartAuthentication animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 3:
            if (isLogin) {
                LBRedBagViewController *RedBag = [[LBRedBagViewController alloc] init];
                RedBag.hidesBottomBarWhenPushed = YES;
                RedBag.iconString=iconUrl;
                RedBag.name=namee;
                RedBag.money=money;
                [self.navigationController pushViewController:RedBag animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 4:
            if (isLogin) {
                LBSafeViewController *Safe = [[LBSafeViewController alloc] init];
                Safe.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Safe animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 5:
            if (isLogin) {
                LBMyAddressViewController *Address = [[LBMyAddressViewController alloc] init];
                Address.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Address animated:YES];
            }else{
                [self goSigin];
            }
            break;
        case 6:
            if (isLogin) {
                LBBankViewController *bank = [[LBBankViewController alloc] init];
                bank.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bank animated:YES];
            }else{
                [self goSigin];
            }

            break;
            
        default:
            break;
    }

}
//修改推荐人
- (void)edictMyInvite
{
    BOOL islogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (islogin) {
        
        LBMyInviteViewController *invite = [[LBMyInviteViewController alloc] init];
        //        invite.isInvite = YES;
        invite.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:invite animated:YES];
    }else{
        [self goSigin];
    }
}


- (void)pushOrderView: (UIButton *)btn
{
    BOOL islogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (islogin) {
        NSString *status;
        LBOrderListViewController *orderlist = [[LBOrderListViewController alloc] init];
        LBOrderRefundViewController *refund = [[LBOrderRefundViewController alloc] init];
        refund.hidesBottomBarWhenPushed = YES;
        orderlist.hidesBottomBarWhenPushed = YES;
        if (btn.tag == ORDER_BUTTON_TAG) {
            status = @"10";
            orderlist._recycle = @"0";
            orderlist._orderStatus = status;
            [self.navigationController pushViewController:orderlist animated:YES];
        }else if (btn.tag == ORDER_BUTTON_TAG+1){
            status = @"20";
            orderlist._recycle = @"0";
            orderlist._orderStatus = status;
            [self.navigationController pushViewController:orderlist animated:YES];
        }else if (btn.tag == ORDER_BUTTON_TAG+2){
            status = @"30";
            orderlist._recycle = @"0";
            orderlist._orderStatus = status;
            [self.navigationController pushViewController:orderlist animated:YES];
        }else if (btn.tag == ORDER_BUTTON_TAG+3){
            [self.navigationController pushViewController:refund animated:YES];
        }
        
    }else{
        [self goSigin];
    }
}

-(void)pushComView:(UIButton *)btn
{
    BOOL islogin = [LBUserInfo sharedUserSingleton].isLogin;
    if (islogin) {
        
        LBCommissionViewController *comview = [[LBCommissionViewController alloc] init];
        LBBankViewController *Bank=[[LBBankViewController alloc]init];
        LBVoucherHostViewController *voucherHost=[[LBVoucherHostViewController alloc]init];
        switch (btn.tag) {
            case ORDER_BUTTON_TAG:
                Bank.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Bank animated:YES];
                break;
                
            case ORDER_BUTTON_TAG+1:
                comview.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:comview animated:YES];
                break;
            case ORDER_BUTTON_TAG+2:
                voucherHost.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:voucherHost animated:YES];
                break;
                
        }
    }else{
        [self goSigin];
    }
    
}
-(void)pushToQuestions
{
        LBNewHandViewController *NewHand = [[LBNewHandViewController alloc] init];
        NewHand.hidesBottomBarWhenPushed = YES;
        NewHand.title1=title;
        NewHand.title2=title1;
        [self.navigationController pushViewController:NewHand animated:YES];
}
-(void)pushToFeedback
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    
    if (isLogin) {
        LBAdvViewController *adv = [[LBAdvViewController alloc] init];
        NSString *url = [NSString stringWithFormat:@"http://test.sugemall.com/wap/tmpl/member/question_list.html?ac_id=%@",ac_id];
        adv.advURL =url;
        adv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:adv animated:YES];
    }else{
        [self goSigin];
    }
}
#pragma mark 商学院

- (void)loadDatas
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"ac_id":@""};
    [manager POST:SUGE_NEWHANDSTEP1 parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"商学院%@",responseObject);
        ac_id=responseObject[@"datas"][@"article_class_list"][2][@"ac_id"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}
-(void)pushToAbout
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;

    if (isLogin) {
        LBAboutViewController *About = [[LBAboutViewController alloc] init];
        About.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:About animated:YES];
    }else{
        [self goSigin];
    }

}
#pragma mark  进入财富页面
-(void)clickWeath
{
    BOOL isLogin = [LBUserInfo sharedUserSingleton].isLogin;
    
    if (isLogin) {
        LBWeathViewController *weath=[[LBWeathViewController alloc]init];
        weath.hidesBottomBarWhenPushed=YES;
        weath.block = ^(NSString *num){
            numLabel.text=num;
        };
        [self.navigationController pushViewController:weath animated:YES];
    }else{
        [self goSigin];
    }
   }
-(void)pushRecharge
{
    LBRechargeViewController *Recharge=[[LBRechargeViewController alloc]init];
    Recharge.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:Recharge animated:YES];
}

- (void)loadDatas:(NSString *)ac_code
{
    //提示
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    NSDictionary *parameter =@{@"ac_code":ac_code};
    [manager POST:SUGE_NEWHAND parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"新手指引%@",responseObject);
        title=responseObject[@"datas"][@"article_class_list"][@"faq"][@"ac_name"];
        title1=responseObject[@"datas"][@"article_class_list"][@"video"][@"ac_name"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}

#pragma mark  进入注册界面
- (void)pushLognInView
{
    [self goSigin];
    
}


#pragma mark --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[SDImageCache sharedImageCache] clearMemory];
    
    BOOL isLognIn = [LBUserInfo sharedUserSingleton].isLogin;
    if (isLognIn) {
        welcome.hidden = YES;
        lognIn.hidden = YES;
        LognOut.hidden = NO;
        userIcon.hidden = NO;
        userName.hidden = NO;
        levelIcon.hidden = NO;
        userNameIcon.hidden = NO;
        View1.hidden = NO;
        edictImage.hidden = NO;
        edictButton.hidden = NO;
        luckName.hidden = NO;
        inviterLabel.hidden = NO;
        caifuButton.hidden=NO;
        caifuLabel.hidden=NO;
        jiantouImageView.hidden=NO;
        caifuImageView.hidden=NO;
        numLabel.hidden=NO;
        jiantouImageView1.hidden=NO;
        lineView.hidden=NO;
        [self loadIconsDatas];
        
    }else{
        welcome.hidden = NO;
        lognIn.hidden = NO;
        LognOut.hidden = YES;
        userIcon.hidden = YES;
        userName.hidden = YES;
        levelIcon.hidden = YES;
        userNameIcon.hidden = YES;
        View1.hidden = YES;
        edictImage.hidden = YES;
        edictButton.hidden = YES;
        luckName.hidden = YES;
        inviterLabel.hidden = YES;
        caifuButton.hidden=YES;
        caifuLabel.hidden=YES;
        jiantouImageView.hidden=YES;
        caifuImageView.hidden=YES;
        numLabel.hidden=YES;
        jiantouImageView1.hidden=YES;
        lineView.hidden=YES;

    }
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.translucent = YES;
    [MobClick beginLogPageView:@"个人中心"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"个人中心"];
    
}

@end
