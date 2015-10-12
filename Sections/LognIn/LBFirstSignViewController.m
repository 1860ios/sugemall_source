//
//  LBFirstSignViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/14.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBFirstSignViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UtilsMacro.h"
#import "NotificationMacro.h"
#import "AppMacro.h"
#import "UMSocialAccountManager.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"


@interface LBFirstSignViewController ()<UITextFieldDelegate>
{
    NSString *_des;
    NSString *_des1;
    UITextField *moblieT;
    NSString *m1;
    UITextField *vCodeT;
    NSString *m2;
    UIButton *getVcodeButton;
    UIButton *doneBlindMobile;
    NSString *str1;
    NSString *str2;
    NSString *kDesc;
}
@end

@implementation LBFirstSignViewController
@synthesize type;
@synthesize openid;
@synthesize device_token;
@synthesize unid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完成绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    

//    _des = kk_desc;
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation WX is %@",response.data);
        _des =[NSString stringWithFormat:@"%@,%@,%@",response.data[@"openid"],response.data[@"screen_name"],response.data[@"profile_image_url"]];
    }];
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation QQ is %@",response.data);
        _des1 = [NSString stringWithFormat:@"%@,%@,%@",response.data[@"openid"],response.data[@"screen_name"],response.data[@"profile_image_url"]];
    }];
    [self initBlindView];
    
}

- (void)initBlindView
{
    //手机号
    moblieT = [[UITextField alloc] initWithFrame:CGRectMake(20, 73, SCREEN_WIDTH-40, 50)];
    moblieT.delegate = self;
    moblieT.borderStyle = UITextBorderStyleNone;
    moblieT.placeholder = @"请输入手机号";
    moblieT.clearButtonMode = UITextFieldViewModeWhileEditing;
    moblieT.keyboardType = UIKeyboardTypeNumberPad;
    UIView *separeateView=  [[UIView alloc] initWithFrame:CGRectMake(moblieT.frame.origin.x-15,moblieT.frame.size.height-1, moblieT.frame.size.width, 1)];
    separeateView.backgroundColor = APP_COLOR;
    [moblieT addSubview:separeateView];
    [self.view addSubview:moblieT];
    
    //验证码
    vCodeT = [[UITextField alloc] initWithFrame:CGRectMake(moblieT.frame.origin.x, moblieT.frame.origin.y+moblieT.frame.size.height, SCREEN_WIDTH-40, 50)];
    vCodeT.delegate = self;
    vCodeT.borderStyle = UITextBorderStyleNone;
    vCodeT.placeholder = @"请输入验证码";
    vCodeT.clearButtonMode = UITextFieldViewModeWhileEditing;
    vCodeT.keyboardType = UIKeyboardTypeNumberPad;
    UIView *separeateView1=  [[UIView alloc] initWithFrame:CGRectMake(vCodeT.frame.origin.x-15,vCodeT.frame.size.height-1, vCodeT.frame.size.width, 1)];
    separeateView1.backgroundColor = APP_COLOR;
    [vCodeT addSubview:separeateView1];
    [self.view addSubview:vCodeT];

    //获取验证码
    getVcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getVcodeButton.frame = CGRectMake(vCodeT.frame.size.width-80, vCodeT.center.y-15, 80, 30);
    [getVcodeButton setTitle:@"获取验证码" forState:0];
    [getVcodeButton setTitleColor:APP_COLOR forState:0];
    getVcodeButton.layer.cornerRadius = 5;
    getVcodeButton.layer.borderWidth = 1;
    getVcodeButton.layer.borderColor = [APP_COLOR CGColor];
    getVcodeButton.titleLabel.font = FONT(14);
    [getVcodeButton addTarget:self action:@selector(starGetVcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getVcodeButton];

    //完成绑定手机号
    doneBlindMobile= [UIButton buttonWithType:UIButtonTypeCustom];
    doneBlindMobile.frame = CGRectMake(vCodeT.frame.origin.x, vCodeT.frame.size.height+vCodeT.frame.origin.y+20, SCREEN_WIDTH-40, 40);
    [doneBlindMobile setTitle:@"完成绑定手机号" forState:0];
    [doneBlindMobile setTitleColor:APP_COLOR forState:0];
    doneBlindMobile.layer.cornerRadius = 5;
    doneBlindMobile.layer.borderWidth = 1;
    doneBlindMobile.layer.borderColor = [APP_COLOR CGColor];
    doneBlindMobile.titleLabel.font = FONT(14);
    [doneBlindMobile addTarget:self action:@selector(doneBlindMobile1) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:doneBlindMobile];

    
}
//开始获取验证码
- (void)starGetVcode
{

//    NSString *mobile = moblieT.text;
//    NSString *regex =  @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isValid = [pred evaluateWithObject:mobile];
//    if (!isValid) {
//        [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
//    }else{
        [self getVercode];
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [getVcodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    getVcodeButton.userInteractionEnabled = YES;
//                    [self getVercode];
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                    [getVcodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                    getVcodeButton.titleLabel.font = FONT(13);
                    getVcodeButton.userInteractionEnabled = NO;
                    
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
    }


//}
//获取验证码
- (void)getVercode
{
    //HUD
    [SVProgressHUD showWithStatus:@"发送验证码..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"mobile":moblieT.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_GETVCODE parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"验证码:responObject:%@",responObject[@"datas"][@"message"]);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];
}


//绑定手机号..
- (void)doneBlindMobile1
{
    //HUD
    [SVProgressHUD showWithStatus:@"完成绑定..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    m1 = moblieT.text;
    m2 = vCodeT.text;
    NSDictionary *parameters;
    if ([type isEqualToString:@"wx"]) {
        parameters = @{@"unionid":unid,@"desc":_des,@"openid":openid,@"type":type,@"mobile":m1,@"vcode":m2,@"client":@"ios"};

    }else{
        parameters = @{@"desc":_des1,@"openid":openid,@"type":type,@"mobile":m1,@"vcode":m2,@"client":@"ios"};

    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_QUIKREGISTER parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSString *_error =responObject[@"datas"][@"error"];
        NSLog(@"绑定手机号:responObject:%@,错误:%@",responObject,_error);
        if ([_error isEqualToString:@"手机验证码错误"]) {
            //提示
            [TSMessage showNotificationWithTitle:@"错误" subtitle:@"验证码错误!" type:TSMessageNotificationTypeSuccess];
        }else{

        //提示
        [TSMessage showNotificationWithTitle:@"绑定成功" subtitle:@"请重新登录成功~" type:TSMessageNotificationTypeSuccess];
        //保存密码
        str1 = responObject[@"datas"][@"username"];
        str2 = responObject[@"datas"][@"key"];
        NSString *redbag = responObject[@"datas"][@"redbag"];
        [NOTIFICATION_CENTER postNotificationName:@"isRedBag" object:nil userInfo:[NSDictionary dictionaryWithObject:redbag forKey:@"redbag"]];
        [[LBUserInfo sharedUserSingleton] saveLoginInfo:responObject[@"datas"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        //登录
//        [self signIn];
        }


//        //
//        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//            NSLog(@"SnsInformation is %@",response.data);
//        }];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];
}

- (void)signIn
{
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在登陆..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter;
    if ([type isEqualToString:@"wx"]) {
        parameter = @{@"desc":_des,@"openid":openid,@"type":type,@"device_token":@"",@"client":@"ios"};
    }else{
        parameter = @{@"desc":_des1,@"openid":openid,@"type":type,@"device_token":@"",@"client":@"ios"};
    }
    
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_QUIKRELOGIN parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //dismiss
        [SVProgressHUD dismiss];
        NSLog(@"快速登录responObject:%@",responObject);
        NSLog(@"登录错误responObject:%@",responObject[@"datas"][@"error"]);
        
        //保存密码
        str1 = responObject[@"datas"][@"username"];
        str2 = responObject[@"datas"][@"key"];
        if (str2 == nil) {
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"登录错误!" type:TSMessageNotificationTypeWarning];
        }else{
        [[LBUserInfo sharedUserSingleton] saveLoginInfo:responObject[@"datas"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [moblieT resignFirstResponder];
    [vCodeT resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    kDesc = _desc;
}




@end
