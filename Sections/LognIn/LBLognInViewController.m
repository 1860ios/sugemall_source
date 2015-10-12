//
//  LBLognInViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBLognInViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import <TSMessage.h>
#import "SUGE_API.h"
#import "AppMacro.h"
#import "NotificationMacro.h"
#import "SVProgressHUD.h"
#import "MobClick.h"
#import "UIView+Extension.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialDataService.h"
#import "UMSocialAccountManager.h"
#import "LBFirstSignViewController.h"
#import "LBVMoblieViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "VendorMacro.h"

@interface LBLognInViewController(){
    NSString *wx_code;
    NSString *access_token;
    NSString *openid;
    NSString *_token;
    UIView *separeateView1;
    UIView *separeateView;

}
@property (nonatomic, strong) UIScrollView *_scrollView;

@end

@implementation LBLognInViewController
@synthesize showPSW;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登陆";
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *fastSignUpButton = [[UIBarButtonItem alloc] initWithTitle:@"快速注册"
//                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(fastSignUp)];
//    self.navigationItem.rightBarButtonItem = fastSignUpButton;
    _token = [USER_DEFAULT objectForKey:@"token"];
    if (_token == nil) {
        _token = @"";
    }
    [self initScrollView];
    [self drawTextFeild];
}
#pragma mark 快速注册
- (void)fastSignUp
{
    LBSignUpViewController *signUpVC = [[LBSignUpViewController alloc] init];
    [self presentViewController:signUpVC animated:YES completion:nil];
    NSLog(@"进入注册界面");
}

#pragma mark loadScrollView
-(void)initScrollView
{
    //背景图
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
//    bgView.image = IMAGE(@"suge_signin_bg");
//    bgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view insertSubview:bgView atIndex:0];

    __scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    __scrollView.backgroundColor = [UIColor clearColor];
    __scrollView.alwaysBounceVertical = YES;
    __scrollView.directionalLockEnabled = YES;
    __scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+100);
    [self.view addSubview:__scrollView];
    
}

- (void)drawTextFeild
{
    
//    UIImageView *nameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_account"]];
//    UIImageView *pwdView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password"]];
    
    _nameCount = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 50)];
    _nameCount.delegate = self;
    _nameCount.borderStyle = UITextBorderStyleNone;
    _nameCount.clearButtonMode = UITextFieldViewModeWhileEditing;
     _nameCount.keyboardType = UIKeyboardTypeNumberPad;
    _nameCount.placeholder = @"请输入手机号";
    _nameCount.returnKeyType = UIReturnKeyNext;
    _nameCount.tag = 1011;
//    _nameCount.leftView = nameView;
//    _nameCount.leftViewMode = UITextFieldViewModeAlways;
    
//    UIImageView *icon =  [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-30, _nameCount.frame.origin.y-80, 60, 60)];
//    icon.image = [UIImage imageNamed:@"user_no_image"];
//    icon.layer.masksToBounds = 30;
//    icon.layer.cornerRadius = 30;
//    [__scrollView addSubview:icon];
    
    separeateView=  [[UIView alloc] initWithFrame:CGRectMake(0 ,_nameCount.frame.size.height-3, SCREEN_WIDTH-20, 1)];
    separeateView.backgroundColor = [UIColor blackColor];
    [__scrollView addSubview:_nameCount];
    [_nameCount addSubview:separeateView];
    
    //密码
    _pwd = [[UITextField alloc] initWithFrame:CGRectMake(20, _nameCount.frame.origin.y+_nameCount.frame.size.height + 5, SCREEN_WIDTH-40, _nameCount.frame.size.height)];
    _pwd.delegate = self;
    _pwd.borderStyle = UITextBorderStyleNone;
    _pwd.keyboardAppearance = UIKeyboardAppearanceAlert;
    _pwd.secureTextEntry = YES;
    _pwd.returnKeyType = UIReturnKeyGo;
    _pwd.placeholder = @"请输入密码";
    _pwd.tag = 1012;
//    _pwd.leftView = pwdView;
//    _pwd.leftViewMode = UITextFieldViewModeAlways;
    [__scrollView addSubview:_pwd];
    separeateView1=  [[UIView alloc] initWithFrame:CGRectMake(0,_pwd.frame.size.height-3, SCREEN_WIDTH-20, 1)];
    separeateView1.backgroundColor = [UIColor blackColor];
    [_pwd addSubview:separeateView1];
   
    //显示密码
    showPSW = [UIButton buttonWithType:UIButtonTypeCustom];
    showPSW.frame = CGRectMake(_pwd.frame.origin.x+_pwd.frame.size.width-60, _pwd.frame.origin.y+5, 60, 35);
    [showPSW setImage:IMAGE(@"pwd_nor") forState:UIControlStateNormal];
    [showPSW setImage:IMAGE(@"pwd_sele") forState:UIControlStateSelected];
    [showPSW addTarget:self action:@selector(showPsw:) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:showPSW];
    
    //登陆
    _lognIn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lognIn.frame = CGRectMake(20, _pwd.frame.origin.y+_pwd.frame.size.height + 30, (SCREEN_WIDTH-40), _pwd.frame.size.height);
//    _lognIn.layer.cornerRadius = 5;
    _lognIn.layer.borderWidth = 1.0;
    _lognIn.layer.borderColor = [[UIColor blackColor] CGColor];
    [_lognIn setTitle:@"登 录" forState:0];
    [_lognIn setTitleColor:[UIColor blackColor] forState:0];
    _lognIn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_lognIn addTarget:self action:@selector(signIn1) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:_lognIn];
    
    //忘记密码
    
    UIButton *Forgot = [UIButton buttonWithType:UIButtonTypeCustom];
    Forgot.frame = CGRectMake(_lognIn.frame.origin.x+_lognIn.frame.size.width-80, _lognIn.frame.origin.y+_lognIn.frame.size.height+10, 80, 20);
    [Forgot setTitle:@"忘记密码?" forState:0];
    [Forgot setTitleColor:[UIColor grayColor] forState:0];
    Forgot.titleLabel.font = [UIFont systemFontOfSize:16];
    [Forgot addTarget:self action:@selector(forgotPwd) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:Forgot];
    
    //合作账号登陆
    UIView *separeateView3=  [[UIView alloc] initWithFrame:CGRectMake(40,Forgot.frame.origin.y+Forgot.frame.size.height+10,80, 1)];
    separeateView3.backgroundColor = APP_Grey_COLOR;
    [__scrollView addSubview:separeateView3];
    
    UILabel *partLabel = [[UILabel alloc] initWithFrame:CGRectMake(__scrollView.center.x-40, separeateView3.center.y-10, 120, 20)];
    partLabel.text = @"合作账号登陆";
    partLabel.font = FONT(14);
    partLabel.textColor = [UIColor lightGrayColor];
    partLabel.backgroundColor  = [UIColor clearColor];
    [__scrollView addSubview:partLabel];
    
    UIView *separeateView4=  [[UIView alloc] initWithFrame:CGRectMake(partLabel.frame.origin.x+partLabel.frame.size.width-10,separeateView3.frame.origin.y,90, 1)];
    separeateView4.backgroundColor = APP_Grey_COLOR;
    [__scrollView addSubview:separeateView4];
    
    //微信登陆
    
    UIButton *WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    WXButton.frame = CGRectMake(60, separeateView3.frame.origin.y+separeateView3.frame.size.height+25, (SCREEN_WIDTH-120), 50);
    
    [WXButton setBackgroundImage:IMAGE(@"signupweixin") forState:0];
    [WXButton addTarget:self action:@selector(WXsignIn) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:WXButton];
    /*
    //其他账号
    UILabel *otherlabel = [[UILabel alloc] initWithFrame:CGRectMake(WXButton.center.x, WXButton.center.y+35, 60, 30)];
    otherlabel.textAlignment = NSTextAlignmentCenter;
    otherlabel.font = FONT(14);
    otherlabel.textColor = [UIColor grayColor];
    otherlabel.text = @"其他账号";
    [__scrollView addSubview:otherlabel];
    
   
    //QQ登陆
    UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QQButton.frame = CGRectMake(otherlabel.frame.origin.x+otherlabel.frame.size.width+5, otherlabel.frame.origin.y, 40,40);
    [QQButton setBackgroundImage:IMAGE(@"signupqq") forState:0];
    [QQButton addTarget:self action:@selector(QQsignIn) forControlEvents:UIControlEventTouchUpInside];
    [__scrollView addSubview:QQButton];
    
    */
    NSArray *views = @[_nameCount,_pwd];
    shaker = [[AFViewShaker alloc] initWithViewsArray:views];
}

#pragma mark 忘记密码

- (void)showPsw:(UIButton *)btn
{
    if (btn.selected) {

        _pwd.secureTextEntry = YES;
        btn.selected = NO;
    }else{
        _pwd.secureTextEntry = NO;
        btn.selected = YES;

    }
    
}
#pragma mark 忘记密码

- (void)forgotPwd
{
    LBVMoblieViewController *vmoblie = [[LBVMoblieViewController alloc] init];
    vmoblie.phoneString =_nameCount.text;
    [self.navigationController pushViewController:vmoblie animated:YES];
}
#pragma mark 微信登陆
- (void)WXsignIn
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, openId is %@, token is %@ url is %@",snsAccount.userName,snsAccount.openId,snsAccount.accessToken,snsAccount.iconURL);
            NSString *_desc = [NSString stringWithFormat:@"%@,%@,%@",snsAccount.unionId,snsAccount.userName,snsAccount.iconURL];

            NSLog(@"_desc:%@",_desc);
            NSArray *values = @[snsAccount.userName,snsAccount.iconURL];
            NSArray *keys = @[@"userName",@"iconURL"];
            //第三方通知头像更新
            [NOTIFICATION_CENTER postNotificationName:SUGEGETAVASTAR_THREE object:nil userInfo:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
            
            [self signIn3:snsAccount.openId type:@"wx" des:_desc unionid:snsAccount.unionId];
        }
        
    });
    
    
}

- (void)signIn3: (NSString *)openID type:(NSString *)type des:(NSString *)des unionid:(NSString *)unionid
{
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在登陆..." maskType:SVProgressHUDMaskTypeClear];
    NSString *devs = [USER_DEFAULT objectForKey:@"device_token"];
    if (devs == nil) {
        devs = @"";
    }
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"unionid":unionid,@"device_token":devs,@"desc":des,@"openid":openID,@"type":type,@"client":@"ios"};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_QUIKRELOGIN parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //dismiss
        [SVProgressHUD dismiss];
        NSLog(@"SUGE_QUIKRELOGIN:%@",responObject);
        NSString *str1 = responObject[@"datas"][@"username"];
        NSString *str2 = responObject[@"datas"][@"key"];
        NSString *str3 = responObject[@"datas"][@"error"];
        NSLog(@"username:%@,key:%@,error:%@",str1,str2,str3);

        if (str1.length == 0) {
            NSLog(@"绑定手机号");
            [NOTIFICATION_CENTER postNotificationName:@"blingphone" object:nil userInfo:[NSDictionary dictionaryWithObject:des forKey:@"desc"]];
            LBFirstSignViewController *first = [[LBFirstSignViewController alloc] init];
            first.openid = openID;
            first.type = type;
            first.unid = unionid;
            [self.navigationController pushViewController:first animated:YES];
        }else{
            //提示
            [TSMessage showNotificationWithTitle:@"登陆成功" type:TSMessageNotificationTypeSuccess];
//            NSString *redbag = responObject[@"datas"][@"redbag"];
            //保存密码
            [[LBUserInfo sharedUserSingleton] saveLoginInfo:responObject[@"datas"]];
//            [NOTIFICATION_CENTER postNotificationName:@"isRedBag" object:nil userInfo:[NSDictionary dictionaryWithObject:redbag forKey:@"redbag"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];

    
}

#pragma mark  登陆
- (void)signIn1
{
    
    if(_nameCount.text.length || _pwd.text.length ){
        //HUD 提示
        [SVProgressHUD showWithStatus:@"正在登陆..." maskType:SVProgressHUDMaskTypeClear];
        NSString *devs = [USER_DEFAULT objectForKey:@"device_token"];
        if (devs == nil) {
            devs = @"";
        }
        AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameter = @{@"device_token":devs,@"username":_nameCount.text,@"password":_pwd.text,@"client":@"ios"};
        maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [maneger POST:SUGE_LOGIN parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){

            NSLog(@"登录responObject:%@",responObject);
//            NSString *redbag = responObject[@"datas"][@"redbag"];
//            NSLog(@"登录错误responObject:%@",responObject[@"datas"][@"error"]);
            NSDictionary *resp = responObject[@"datas"];
            if (resp.count >= 2) {
                //提示
                [TSMessage showNotificationWithTitle:@"登陆成功" type:TSMessageNotificationTypeSuccess];
                //保存密码
                [[LBUserInfo sharedUserSingleton] saveLoginInfo:responObject[@"datas"]];
//                [NOTIFICATION_CENTER postNotificationName:@"isRedBag" object:nil userInfo:[NSDictionary dictionaryWithObject:redbag forKey:@"redbag"]];
                [self.navigationController popViewControllerAnimated:YES];

            }else{
                NSString *str3 = responObject[@"datas"][@"error"];
                [TSMessage showNotificationWithTitle:@"错误" subtitle:str3 type:TSMessageNotificationTypeError];
                
            }
            
        } failure:^(AFHTTPRequestOperation *op,NSError *error){

            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            NSLog(@"登陆失败:%@",error);
        }];
            [SVProgressHUD dismiss];
    }else{
        [TSMessage iOS7StyleEnabled];
        [TSMessage showNotificationWithTitle:@"请认真输入!" type:TSMessageNotificationTypeError];
        [shaker shake];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1011) {
        separeateView.backgroundColor = APP_COLOR;
    }else if (textField.tag == 1012){
    separeateView1.backgroundColor = APP_COLOR;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameCount resignFirstResponder];
    [_pwd resignFirstResponder];
    return YES;
}

- (void)getWXcode:(id)sender
{
    wx_code = [[sender userInfo] objectForKey:@"code"];
}

#pragma mark --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登陆界面"];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(getWXcode:) name:@"wx_code" object:nil];


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登陆界面"];
    
}


@end
