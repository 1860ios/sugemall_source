//
//  LBBlingStepViewController.m
//  SuGeMarket
//
//  验证手机号
//  Created by 1860 on 15/7/14.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBBlingStepViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBBlingViewController.h"

@interface LBBlingStepViewController ()<UITextFieldDelegate>
{
    UITextField *moblieT;
    UITextField *vCodeT;
    UIButton *getVcodeButton;
    UIButton *nextButton;
    //
    UIView *separeateView;
    UIView *separeateView1;
}
@end

@implementation LBBlingStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"验证手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView5];
}

- (void)setUpView5
{
    //手机号
    moblieT = [[UITextField alloc] initWithFrame:CGRectMake(20, 73, SCREEN_WIDTH-40, 50)];
    moblieT.delegate = self;
    moblieT.tag = 90;
    moblieT.borderStyle = UITextBorderStyleNone;
    //moblieT.placeholder = @"请输入原始手机号";
    moblieT.text=_agoNumString;
    moblieT.enabled=NO;
    moblieT.clearButtonMode = UITextFieldViewModeWhileEditing;
    moblieT.keyboardType = UIKeyboardTypeNumberPad;
    separeateView=  [[UIView alloc] initWithFrame:CGRectMake(moblieT.frame.origin.x-15,moblieT.frame.size.height-1, moblieT.frame.size.width, 1)];
    
    separeateView.backgroundColor = [UIColor lightGrayColor];
    [moblieT addSubview:separeateView];
    [self.view addSubview:moblieT];
    
        //验证码
        vCodeT = [[UITextField alloc] initWithFrame:CGRectMake(moblieT.frame.origin.x, moblieT.frame.origin.y+moblieT.frame.size.height, SCREEN_WIDTH-40, 50)];
        vCodeT.delegate = self;
        vCodeT.tag = 91;
        vCodeT.borderStyle = UITextBorderStyleNone;
        vCodeT.placeholder = @"请输入验证码";
        vCodeT.keyboardType = UIKeyboardTypeNumberPad;
        separeateView1=  [[UIView alloc] initWithFrame:CGRectMake(vCodeT.frame.origin.x-15,vCodeT.frame.size.height-1, vCodeT.frame.size.width, 1)];
        separeateView1.backgroundColor = [UIColor lightGrayColor];
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
        nextButton= [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(vCodeT.frame.origin.x, vCodeT.frame.size.height+vCodeT.frame.origin.y+20, SCREEN_WIDTH-40, 40);
        
        [nextButton setTitle:@"下一步" forState:0];
        [nextButton setTitleColor:APP_COLOR forState:0];
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.borderWidth = 1;
        nextButton.layer.borderColor = [APP_COLOR CGColor];
        nextButton.titleLabel.font = FONT(14);
    
        [nextButton addTarget:self action:@selector(checkBlindMobile) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:nextButton];
    
}
- (void)kGetVVcode
{
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
                //                NSLog(@"____%@",strTime);
                [getVcodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                getVcodeButton.titleLabel.font = FONT(13);
                getVcodeButton.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
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
    if (moblieT.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }else{
        [self getVercode];
    }
    
}
//获取验证码
- (void)getVercode
{
    //HUD
    [SVProgressHUD showWithStatus:@"发送验证码..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *key  = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameters = @{@"key":key,@"mobile":moblieT.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_SEND_VCODE parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"获取验证码responObject:%@,%@",responObject,responObject[@"datas"][@"error"]);
        [self kGetVVcode];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];
}

//验证手机号
- (void)checkBlindMobile
{
    if (moblieT.text.length == 0||vCodeT.text.length  == 0) {
        [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请填写完整信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }else{
        
        //HUD
        [SVProgressHUD showWithStatus:@"验证手机号..." maskType:SVProgressHUDMaskTypeClear];
        NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"key":key,@"vcode":vCodeT.text,@"mobile":moblieT.text,@"type":@"mobile"};
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [manager POST:SUGE_CHECK_EMAIL_CODE parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
            
            NSLog(@"验证手机号:responObject:%@",responObject);

            if ([responObject[@"datas"] isEqual:@"1"]) {
                [TSMessage showNotificationWithTitle:@"成功" subtitle:@"验证手机号成功!" type:TSMessageNotificationTypeSuccess];
                [self.navigationController pushViewController:[LBBlingViewController new] animated:YES];
            }else{
                NSString *error = responObject[@"datas"][@"error"];
                [[[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            
            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            
        }];
        [SVProgressHUD dismiss];
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 90:
            separeateView.backgroundColor = APP_COLOR;
            break;
            
        case 91:
            separeateView1.backgroundColor = APP_COLOR;
            break;
            
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [moblieT resignFirstResponder];
    [vCodeT resignFirstResponder];
    return YES;
}

//绑定
- (void)senderEmailCode:(UIButton *)btn
{
    //HUD
    [SVProgressHUD showWithStatus:@"发送验证码..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *key  = [LBUserInfo sharedUserSingleton].userinfo_key;
    NSDictionary *parameters = @{@"key":key,@"email":moblieT.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_BLING_EMAIL parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"绑定新手机号responObject:%@,%@",responObject,responObject);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        
    }];
    [SVProgressHUD dismiss];
}


@end
