//
//  LBBlingMobileViewController.m
//  SuGeMarket
//
//  修改绑定邮箱
//  Created by 1860 on 15/7/14.
//  Copyright (c) 2015年 Josin_Q. All rights reserved.
//

#import "LBBling1ViewController.h"
#import "UtilsMacro.h"
#import <AFNetworking.h>
#import "SUGE_API.h"
#import "LBUserInfo.h"
#import "SVProgressHUD.h"
#import <TSMessage.h>
#import "LBSafeViewController.h"

@interface LBBling1ViewController ()<UITextFieldDelegate>
{
    UITextField *moblieT;
    UIButton *nextButton;
    //
    UIView *separeateView;

}
@end

@implementation LBBling1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"修改绑定邮箱";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView6];
}

- (void)setUpView6
{
    //邮箱
    moblieT = [[UITextField alloc] initWithFrame:CGRectMake(20, 73, SCREEN_WIDTH-40, 50)];
    moblieT.delegate = self;
    moblieT.tag = 90;
    moblieT.borderStyle = UITextBorderStyleNone;
    moblieT.placeholder = @"请输入新邮箱";
    moblieT.clearButtonMode = UITextFieldViewModeWhileEditing;
//    moblieT.keyboardType = UIKeyboardTypeNumberPad;
    separeateView=  [[UIView alloc] initWithFrame:CGRectMake(moblieT.frame.origin.x-15,moblieT.frame.size.height-1, moblieT.frame.size.width, 1)];
    separeateView.backgroundColor = [UIColor lightGrayColor];
    [moblieT addSubview:separeateView];
    [self.view addSubview:moblieT];
    
    
    //完成绑定手机号
    nextButton= [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(moblieT.frame.origin.x, moblieT.frame.size.height+moblieT.frame.origin.y+20, SCREEN_WIDTH-40, 40);
    [nextButton setTitle:@"获取邮箱验证" forState:0];
    [nextButton setTitleColor:APP_COLOR forState:0];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = [APP_COLOR CGColor];
    nextButton.titleLabel.font = FONT(14);
    [nextButton addTarget:self action:@selector(doneBlindMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    

}
//绑定邮箱
- (void)doneBlindMobile
{
    if (moblieT.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"错误" message:@"请填写完整信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
    }else{
            
            //HUD
            [SVProgressHUD showWithStatus:@"验证邮箱..." maskType:SVProgressHUDMaskTypeClear];
            NSString *key  =[LBUserInfo sharedUserSingleton].userinfo_key;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"key":key,@"email":moblieT.text};
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",nil];
            
            [manager POST:SUGE_BLING_EMAIL parameters:parameters success:^(AFHTTPRequestOperation *operation,id responObject){
                
                NSLog(@"绑定新邮箱:responObject:%@",responObject);
                NSDictionary *success = responObject[@"datas"];
                NSString *result = [success allKeys][0];
                if ([result isEqualToString:@"msg"]) {
                    NSString *suc = responObject[@"datas"][@"msg"];
                    [TSMessage showNotificationWithTitle:@"提示" subtitle:suc type:TSMessageNotificationTypeSuccess];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    NSString *error = responObject[@"datas"][@"error"];
                    NSLog(@"error:%@",error);
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
    
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [moblieT resignFirstResponder];
    return YES;
}

@end
