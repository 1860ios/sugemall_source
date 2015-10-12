//
//  LBForgotViewController.m
//  SuGeMarket
//
//  Created by 1860 on 15/6/14.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBForgotViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBUserInfo.h"


@interface LBForgotViewController ()<UITextFieldDelegate>
{
    UITextField *newPSW;
    UITextField *newPSW2;
    UIButton *setDone;
    NSString *t1;
}
@end

@implementation LBForgotViewController
@synthesize member_id;
@synthesize member_name;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView2];
}

- (void)setUpView2
{
    //手机号z
    newPSW = [[UITextField alloc] initWithFrame:CGRectMake(20, 73, SCREEN_WIDTH-40, 50)];
    newPSW.delegate = self;
    newPSW.borderStyle = UITextBorderStyleNone;
    newPSW.placeholder = @"请输入新密码";
    newPSW.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *separeateView=  [[UIView alloc] initWithFrame:CGRectMake(newPSW.frame.origin.x-15,newPSW.frame.size.height-1, newPSW.frame.size.width, 1)];
    separeateView.backgroundColor = APP_COLOR;
    [newPSW addSubview:separeateView];
    [self.view addSubview:newPSW];
    
    //验证码
    newPSW2 = [[UITextField alloc] initWithFrame:CGRectMake(newPSW.frame.origin.x, newPSW.frame.origin.y+newPSW.frame.size.height, SCREEN_WIDTH-40, 50)];
    newPSW2.delegate = self;
    newPSW2.borderStyle = UITextBorderStyleNone;
    newPSW2.placeholder = @"请再次输入密码";
    newPSW2.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *separeateView1=  [[UIView alloc] initWithFrame:CGRectMake(newPSW2.frame.origin.x-15,newPSW2.frame.size.height-1, newPSW2.frame.size.width, 1)];
    separeateView1.backgroundColor = APP_COLOR;
    [newPSW2 addSubview:separeateView1];
    [self.view addSubview:newPSW2];
    
    
    //设置完成手机号
    setDone= [UIButton buttonWithType:UIButtonTypeCustom];
    setDone.frame = CGRectMake(newPSW2.frame.origin.x, newPSW2.frame.size.height+newPSW2.frame.origin.y+20, SCREEN_WIDTH-40, 40);
    [setDone setTitle:@"密码设置完成" forState:0];
    [setDone setTitleColor:APP_COLOR forState:0];
    setDone.layer.cornerRadius = 5;
    setDone.layer.borderWidth = 1;
    setDone.layer.borderColor = [APP_COLOR CGColor];
    setDone.titleLabel.font = FONT(14);
    [setDone addTarget:self action:@selector(doneSetUpPWD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setDone];
    
}

- (void)doneSetUpPWD
{
    if ([newPSW.text isEqualToString:newPSW2.text ]&&newPSW.text.length !=0) {
        //HUD
        [SVProgressHUD showWithStatus:@"设置中..." maskType:SVProgressHUDMaskTypeClear];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSString *_mid = member_id;
//        NSLog(@"member_id:%@",_mid);
        t1 = member_id;
        NSDictionary *parameters = @{@"member_id":t1,@"password":newPSW.text,@"password_confirm":newPSW2.text,@"client":@"ios"};
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
        
        [manager POST:SUGE_SET_PWD parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
            
            NSLog(@"忘记密码:responObject:%@",responObject);
            [TSMessage showNotificationWithTitle:@"提示" subtitle:@"密码已重设,请重新登录~" type:TSMessageNotificationTypeSuccess];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            
            [TSMessage showNotificationWithTitle:@"网络连接不顺" subtitle:@"请重新尝试" type:TSMessageNotificationTypeWarning];
            
        }];
        [SVProgressHUD dismiss];
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不一样~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];

    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [newPSW resignFirstResponder];
    [newPSW2 resignFirstResponder];
    return YES;
}

@end
