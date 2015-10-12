//
//  LBSignUpViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/4/22.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBSignUpViewController.h"
#import "UtilsMacro.h"
#import "SUGE_API.h"
#import <AFNetworking.h>
#import <TSMessage.h>
#import "SVProgressHUD.h"
#import "MobClick.h"
#import "LBUserInfo.h"


@interface LBSignUpViewController ()

@property (nonatomic, strong) UIScrollView *_scrollView;
@end

@implementation LBSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadScrollView];
    [self initNavBar];
    [self drawTextFeild];
}
#pragma mark loadScrollView
-(void)loadScrollView
{
    __scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    __scrollView.backgroundColor = [UIColor clearColor];
    __scrollView.alwaysBounceVertical = YES;
    __scrollView.directionalLockEnabled = YES;
    __scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+80);
    [self.view addSubview:__scrollView];
    
}

- (void)initNavBar
{
    //背景图
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgView.image = IMAGE(@"suge_signin_bg");
    bgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view insertSubview:bgView atIndex:0];
    //
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    _navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navView];
    //取消
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(5, _navView.frame.origin.y+25, 60, 30);
    [cancel setTitle:@"取消" forState:0];
    [cancel setTitleColor:[UIColor grayColor] forState:0];
    [cancel addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:cancel];
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_navView.center.x-50, _navView.center.y-7, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"快速注册";
    titleLabel.font = BFONT(20);
    titleLabel.textColor = [UIColor blackColor];
    [_navView addSubview:titleLabel];
}

- (void)drawTextFeild
{
    
    NSArray *textPlaceholder = @[@"请填写手机号",@"请填写验证码",@"请填写密码"];
    NSArray *usernameIcon = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_account"]],[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password"]],[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_password"]],[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mailbox"]]];
    
    for (int i = 0; i<3; i++) {
        tt = [[UITextField alloc] initWithFrame:CGRectMake(10, 100+i*60, SCREEN_WIDTH-20, 50)];
        tt.tag = TT_TAG+i;
        tt.delegate = self;
        tt.borderStyle = UITextBorderStyleNone;
        tt.placeholder = [textPlaceholder objectAtIndex:i];
        tt.clearButtonMode = UITextFieldViewModeWhileEditing;
        tt.leftView = [usernameIcon objectAtIndex:i];
        tt.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *separeateView=  [[UIView alloc] initWithFrame:CGRectMake(tt.frame.origin.x-5,tt.frame.size.height-1, tt.frame.size.width, 1)];
        separeateView.backgroundColor = APP_COLOR;
        [tt addSubview:separeateView];
        [__scrollView addSubview:tt];
        if (tt.tag == TT_TAG) {
            tt.keyboardType = UIKeyboardTypeNumberPad;
        }
        //
        if (tt.tag == TT_TAG+1) {
            tt.keyboardType = UIKeyboardTypeNumberPad;
            getVcode = [UIButton buttonWithType:UIButtonTypeCustom];
            getVcode.frame = CGRectMake(tt.frame.size.width-80, tt.center.y-15, 80, 30);
            [getVcode setTitle:@"获取验证码" forState:0];
            [getVcode setTitleColor:APP_COLOR forState:0];
            getVcode.layer.cornerRadius = 5;
            getVcode.layer.borderWidth = 1;
            getVcode.layer.borderColor = [APP_COLOR CGColor];
            getVcode.titleLabel.font = FONT(14);
            [getVcode addTarget:self action:@selector(getVcode) forControlEvents:UIControlEventTouchUpInside];
            [__scrollView addSubview:getVcode];
                   }
        
        if (tt.tag == TT_TAG+2) {
            tt.secureTextEntry = YES;
            _signUp = [UIButton buttonWithType:UIButtonTypeCustom];
            _signUp.frame = CGRectMake(10, tt.frame.origin.y+tt.frame.size.height+20, tt.frame.size.width, tt.frame.size.height-10);
            _signUp.layer.cornerRadius = 5;
            _signUp.layer.borderWidth = 1;
            _signUp.layer.borderColor = [APP_COLOR CGColor];
            [_signUp setTitle:@"注   册" forState:0];
            [_signUp setTitleColor:[UIColor redColor] forState:0];
            [_signUp addTarget:self action:@selector(toSignUp) forControlEvents:UIControlEventTouchUpInside];
            [__scrollView addSubview:_signUp];
        }
    }
    
    
}

- (void)kFetVcode{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getVcode setTitle:@"发送验证码" forState:UIControlStateNormal];
                getVcode.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [getVcode setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                getVcode.titleLabel.font = FONT(13);
                getVcode.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    

}

-(void)getVcode{
    
    [self getVercode];
}


#pragma mark 获取验证码

- (void)getVercode
{
    UITextField *textfield = (UITextField *)[self.view viewWithTag:TT_TAG];
    if (textfield.text.length !=0) {
        
    //HUD
    [SVProgressHUD showWithStatus:@"正在获取..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"mobile":textfield.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [manager POST:SUGE_GETVCODE parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
        
        NSLog(@"responObject:%@",responObject);
        [self kFetVcode];
        
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];

    }];
    [SVProgressHUD dismiss];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"输入有误,请重新输入!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}

#pragma mark 注册

- (void)toSignUp
{
    
    UITextField *textfield = (UITextField *)[self.view viewWithTag:TT_TAG];
    UITextField *textfield1 = (UITextField *)[self.view viewWithTag:TT_TAG+1];
    UITextField *textfield2 = (UITextField *)[self.view viewWithTag:TT_TAG+2];
//    UITextField *textfield3 = (UITextField *)[self.view viewWithTag:TT_TAG+3];
    
//    NSString *mobile = textfield.text;
//    NSString *regex =  @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//      NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isValid = [pred evaluateWithObject:mobile];
//    if (!isValid) {
//        [TSMessage showNotificationWithTitle:@"请输入正确的手机号!" type:TSMessageNotificationTypeWarning];
//    }

    
    if (textfield.text.length&&textfield1.text.length&&textfield2.text.length) {
        //HUD
        [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"method":@"mobile",@"mobile":textfield.text,@"vcode":textfield1.text,@"password":textfield2.text,@"password_confirm":textfield2.text,@"client":@"ios"};
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
        [manager POST:SUGE_REGISTER parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
            
            NSString *str3 = responObject[@"datas"][@"error"];
            
            NSLog(@"responObject:%@",str3);
            if ([str3 isEqualToString:@"手机号已存在"]) {
                //HUD
                [SVProgressHUD showSuccessWithStatus:@"该手机号也存在,请换个手机号注册!" maskType:SVProgressHUDMaskTypeClear];
            }else{
                //HUD
                [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:SVProgressHUDMaskTypeClear];
               //
//                [self signIn];
            //[TSMessage showNotificationWithTitle:@"注册完成" subtitle:@"你可以登录了" type:TSMessageNotificationTypeWarning];
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"注册完成");
            }];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [SVProgressHUD dismiss];
            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            NSLog(@"Error: 注册失败:%@", error);
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"输入有误,请重新输入"
                                  delegate:self
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
        NSLog(@"输入有误");
    }
}


//
- (void)signIn
{
    UITextField *textfield = (UITextField *)[self.view viewWithTag:TT_TAG];
    UITextField *textfield1 = (UITextField *)[self.view viewWithTag:TT_TAG+2];
    //HUD 提示
    [SVProgressHUD showWithStatus:@"正在登陆..." maskType:SVProgressHUDMaskTypeClear];
    
    AFHTTPRequestOperationManager *maneger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"username":textfield.text,@"password":textfield1.text,@"client":@"ios"};
    maneger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
    
    [maneger POST:SUGE_LOGIN parameters:parameter success:^(AFHTTPRequestOperation *op,id responObject){
        //dismiss
        [SVProgressHUD dismiss];
        NSLog(@"登录responObject:%@",responObject);
        NSLog(@"登录错误responObject:%@",responObject[@"datas"][@"error"]);
        NSString *str1 = responObject[@"datas"][@"username"];
        NSString *str2 = responObject[@"datas"][@"key"];
        NSString *str3 = responObject[@"datas"][@"error"];
        NSLog(@"username:%@,key:%@,error:%@",str1,str2,str3);
            //提示
            [TSMessage showNotificationWithTitle:@"登陆成功" type:TSMessageNotificationTypeSuccess];
            //保存密码
            [[LBUserInfo sharedUserSingleton] saveLoginInfo:responObject[@"datas"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *op,NSError *error){
        [SVProgressHUD dismiss];
        [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
        NSLog(@"登陆失败:%@",error);
    }];
}

- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消注册界面");
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tt resignFirstResponder];
    return YES;
}
#pragma mark --统计页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"注册界面"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册界面"];
    
}
@end
